import 'package:flutter/material.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/globals/restaurant_coords.dart';
import 'package:lunch_buddy/home_page.dart';
import 'package:lunch_buddy/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/nearby/custom_marker_info_window.dart';
import 'package:provider/provider.dart';

class NewPublicRequestPage extends StatefulWidget {
  const NewPublicRequestPage({Key? key}) : super(key: key);

  @override
  State<NewPublicRequestPage> createState() => _NewPublicRequestPageState();
}

class _NewPublicRequestPageState extends State<NewPublicRequestPage> {
  DateTime meetingDateTime = DateTime.now();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<DateTime?> pickDate()
    =>  showDatePicker(
          context: context,
          initialDate: meetingDateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(
            meetingDateTime.year,
            meetingDateTime.month + 1,
            meetingDateTime.day
          )
        );

  Future<TimeOfDay?> pickTime()
    =>  showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: meetingDateTime.hour, minute: meetingDateTime.minute)
        );

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return; //  pressed CANCEL

    TimeOfDay? time = await pickTime();
    if (time == null) return; //  pressed CANCEL

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );

    setState(() {
      meetingDateTime = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserID = context.read<AuthenticationService>().getCurrentUser()
                            ?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Requests'),
        backgroundColor: MyApp.bGreen,
        elevation: 4,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                       color: MyApp.aqua,
                    child:
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CustomMarketInfoWindow()),
                            );
                          }, child: Text("Pick a Restaurant"),
                      )
                  ),
                  Text("Picked Restaurant Name: "),
                  Text(restaurantName),
                  Text(
                    "Picked Restaurant Address: "
                  ),
                  Text(formattedAddress),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                  ),
                  ElevatedButton(
                    onPressed: pickDateTime,
                    child: Text ("Pick a Time And Date")
                  ),
                  Text("Picked Time:  "+'${meetingDateTime.month}/${meetingDateTime.day}/${meetingDateTime.year}'
                      ' ${meetingDateTime.hour}:${meetingDateTime.minute}'),
                  ElevatedButton(
                    onPressed: () {
                      db.collection("public_requests").add(
                        {"restaurant_name": restaurantName,
                        "restaurant_image": "",
                        "restaurant_street_address": formattedAddress,
                        "restaurant_city": globalCity,
                        "restaurant_state": globalState.trimLeft(),
                        "date_posted": Timestamp.now(),
                        "meeting_datetime": meetingDateTime,
                        "publisher_id": currentUserID,
                        "accepted_users_id": []
                        }
                      ).then((documentSnapshot) =>
                        db.collection("users").doc(currentUserID)
                            .update({'posted_requests': FieldValue.arrayUnion([documentSnapshot.id])})
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyApp.bYellow,
                      elevation: 4
                    ),
                    child: Text(
                      "Create New Public Request",
                      style: GoogleFonts.indieFlower(
                          fontSize: 24, color: MyApp.dGreen
                      )
                    )
                  )
                ],
              ),
            ),
          )),
    );
  }
}
