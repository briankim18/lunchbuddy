import 'package:flutter/material.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/globals/restaurant_coords.dart';
import 'package:lunch_buddy/home_page.dart';
import 'package:lunch_buddy/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/nearby/custom_marker_info_window.dart';
import 'package:lunch_buddy/public_request.dart';
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

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: meetingDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(meetingDateTime.year, meetingDateTime.month + 1,
          meetingDateTime.day));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: meetingDateTime.hour, minute: meetingDateTime.minute));

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return; //  pressed CANCEL

    TimeOfDay? time = await pickTime();
    if (time == null) return; //  pressed CANCEL

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      meetingDateTime = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserID =
        context.read<AuthenticationService>().getCurrentUser()?.uid;

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
                  Row(
                    children: [
                      const SizedBox(
                        width: 32,
                      ),
                      Positioned(
                        top: 40,
                        left: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/Here.png',
                            height: 64,
                            width: 64,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomMarketInfoWindow()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyApp.mGreen,
                            elevation: 4,
                          ),
                          child: Text(
                            "Pick a Restaurant",
                            style: GoogleFonts.indieFlower(
                                fontSize: 24, color: MyApp.dGreen),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(4),
                    ),
                    child: Container(
                      color: MyApp.bGreen,
                      width: MediaQuery.of(context).size.width * .8,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Restaurant Name: ",
                              style: GoogleFonts.indieFlower(
                                  fontSize: 24, color: MyApp.dGreen)),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Text(restaurantName,
                              style: GoogleFonts.indieFlower(
                                  fontSize: 20, color: MyApp.dGreen)),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                          ),
                          Text("Restaurant Address: ",
                              style: GoogleFonts.indieFlower(
                                  fontSize: 24, color: MyApp.dGreen)),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                          ),
                          Text(formattedAddress,
                              style: GoogleFonts.indieFlower(
                                  fontSize: 20, color: MyApp.dGreen)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 32,
                      ),
                      Positioned(
                        top: 40,
                        left: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'images/Time.png',
                            height: 64,
                            width: 64,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: ElevatedButton(
                            onPressed: pickDateTime,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyApp.aqua, elevation: 4),
                          child: Text("Pick a Date/Time",
                              style: GoogleFonts.indieFlower(
                                  fontSize: 24, color: MyApp.dGreen)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(4),
                    ),
                    child: Container(
                      color: MyApp.aqua,
                      width: MediaQuery.of(context).size.width * .8,
                      padding: const EdgeInsets.all(36.0),
                      child: Text(
                        '${getWeekday(meetingDateTime.weekday)} ${meetingDateTime.month}/${meetingDateTime.day} ${getTime(meetingDateTime.hour, meetingDateTime.minute)}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.indieFlower(
                          fontSize: 24,
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(4),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          db.collection("public_requests").add({
                            "restaurant_name": restaurantName,
                            "restaurant_image": photoUrl,
                            "restaurant_street_address": formattedAddress,
                            "restaurant_city": globalCity,
                            "restaurant_state": globalState.trimLeft(),
                            "date_posted": Timestamp.now(),
                            "meeting_datetime": meetingDateTime,
                            "publisher_id": currentUserID,
                            "accepted_users_id": []
                          }).then((documentSnapshot) =>
                              db.collection("users").doc(currentUserID).update({
                                'posted_requests':
                                    FieldValue.arrayUnion([documentSnapshot.id])
                              }));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyApp.bYellow, elevation: 4),
                        child: Text("Create New Public Request",
                            style: GoogleFonts.indieFlower(
                                fontSize: 24,
                                color: MyApp.dGreen,
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
