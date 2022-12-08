import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/person.dart';

final _formKey = GlobalKey<FormState>();

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController ageController = TextEditingController();
  double distance = 5;
  RangeValues range = const RangeValues(18, 30);

  late Future<List<PublicRequest>> takenRequests;

  Future<List<PublicRequest>> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> requestInfo;
    Map<String, dynamic> publisherInfo;
    Map<String, dynamic> userInfo;

    var publisher;

    List<PublicRequest> takenRequestList = [];

    final currUserID = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .get()
        .then((DocumentSnapshot doc) async {
      userInfo = doc.data() as Map<String, dynamic>;
      for (String takenRequestID in userInfo['taken_requests']) {
        await FirebaseFirestore.instance
            .collection("public_requests")
            .doc(takenRequestID)
            .get()
            .then((DocumentSnapshot docSnap) async {
          requestInfo = docSnap.data() as Map<String, dynamic>;

          await FirebaseFirestore.instance
              .collection("users")
              .doc(requestInfo['publisher_id'])
              .get()
              .then((DocumentSnapshot userDoc) {
            publisherInfo = userDoc.data() as Map<String, dynamic>;
            publisher = Person(
                firstName: publisherInfo['first_name'],
                lastName: publisherInfo['last_name'],
                location: publisherInfo['location'],
                gender: publisherInfo['gender'],
                image: 'images/Kevin.png',
                bio: publisherInfo['bio'],
                age: int.parse(publisherInfo['age']),
                myRequests:
                    publisherInfo['posted_requests'].cast<PublicRequest>(),
                takenRequests:
                    publisherInfo['taken_requests'].cast<PublicRequest>());
          });

          takenRequestList.add(PublicRequest(
              id: docSnap.id,
              restName: requestInfo['restaurant_name'],
              restImage: "images/PandaExpress.png",
              restAddress: requestInfo['restaurant_street_address'],
              city: requestInfo['restaurant_city'],
              state: requestInfo['restaurant_state'],
              datePosted: DateTime.parse(
                  requestInfo['date_posted'].toDate().toString()),
              dateToMeet: DateTime.parse(
                  requestInfo['meeting_datetime'].toDate().toString()),
              user: publisher,
              acceptedUsers: []));
        });
      }
    });
    return takenRequestList;
  }

  @override
  void initState() {
    super.initState();
    takenRequests = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filters",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, height: 3),
                    ),
                    Text("Search Restaurant",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Restaurant Name",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Text("Search Location",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Location",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Text("From Date",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                          controller: fromDate,
                          keyboardType: TextInputType.none,
                          decoration: const InputDecoration(
                            //enabled: false,
                            hintText: 'From',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onTap: () async {
                            DateTime? from = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (from != null) {
                              fromDate.text =
                                  '${from.month}/${from.day}/${from.year}';
                            }
                          }),
                    ),
                    Text("To Date",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                          controller: toDate,
                          keyboardType: TextInputType.none,
                          decoration: const InputDecoration(
                            //enabled: false,
                            hintText: 'To',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onTap: () async {
                            DateTime? to = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (to != null) {
                              toDate.text = '${to.month}/${to.day}/${to.year}';
                            }
                          }),
                    ),
                    Text("Distance(Miles): $distance",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("0"),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Slider(
                                activeColor: MyApp.bGreen,
                                value: distance,
                                divisions: 100,
                                min: 0,
                                max: 25000,
                                onChanged: (double value) {
                                  setState(() {
                                    distance = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Text("25,000")
                        ]),
                    Text("Age Range: ${range.start}-${range.end}",
                        style:
                            GoogleFonts.indieFlower(fontSize: 17, height: 2)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("18"),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: RangeSlider(
                                activeColor: MyApp.bGreen,
                                values: range,
                                divisions: 82,
                                min: 18,
                                max: 100,
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    range = values;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Text("100+")
                        ]),
                  ]),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Taken Requests'),
        backgroundColor: MyApp.mGreen,
        elevation: 4,
        // automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            // <-- Opens drawer.
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Search');
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            FutureBuilder<List<PublicRequest>>(
                future: takenRequests,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: List.generate(
                            snapshot.data!.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 8, bottom: 8),
                              child: GestureDetector(
                                  child: TakenRequestItem(
                                      publicRequestItem:
                                          snapshot.data![index])),
                            ),
                          ),
                        );
                }),
            const SizedBox(
              height: 96,
            ),
          ],
        ),
      ),
    );
  }
}

class TakenRequestItem extends StatefulWidget {
  var publicRequestItem;

  TakenRequestItem({
    Key? key,
    required this.publicRequestItem,
  }) : super(key: key);
  @override
  State<TakenRequestItem> createState() =>
      _TakenRequestItemState(publicRequestItem);
}

class _TakenRequestItemState extends State<TakenRequestItem> {
  final PublicRequest takenRequestItem;

  _TakenRequestItemState(this.takenRequestItem);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: randomColor(),
        height: MediaQuery.of(context).size.height * 0.33,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // This is for the image 1
            Positioned(
              top: 40,
              left: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  takenRequestItem.restImage,
                  height: 64,
                  width: 64,
                ),
              ),
            ),
            // This is for the image 2
            Positioned(
              top: 40,
              left: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  takenRequestItem.user.image,
                  height: 64,
                  width: 64,
                ),
              ),
            ),
            // This is for Name/Distance/Favorite Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          takenRequestItem.restName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '(${takenRequestItem.city}, ${takenRequestItem.state})',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 16,
                            height: .5,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 8.0, bottom: 8.0),
                              child: Image.asset(
                                genderSymbol(takenRequestItem.user),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Text(
                              '${takenRequestItem.user.gender} ${takenRequestItem.user.age}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.indieFlower(
                                fontSize: 20,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${takenRequestItem.user.firstName} ${takenRequestItem.user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 24,
                            height: .5,
                          ),
                        ),
                        Text(
                          '${getMeetWeekday(takenRequestItem)} ${takenRequestItem.dateToMeet.month}/${takenRequestItem.dateToMeet.day} ${getMeetTime(takenRequestItem)}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8.0),
                                child: Image.asset(
                                  'images/Going.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: takenRequestItem.going
                                      ? MyApp.mGreen
                                      : MyApp.mRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    takenRequestItem.going =
                                        !takenRequestItem.going;
                                  });
                                },
                                child: const Text('Still Going'),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8.0),
                                child: Image.asset(
                                  'images/Not Going.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: takenRequestItem.going
                                      ? MyApp.mRed
                                      : MyApp.mGreen,
                                ),
                                onPressed: () {
                                  setState(() {
                                    takenRequestItem.going =
                                        !takenRequestItem.going;
                                  });
                                },
                                child: const Text('Not Going'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8.0),
                                child: Image.asset(
                                  'images/Here.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: takenRequestItem.here
                                      ? MyApp.mGreen
                                      : MyApp.mRed,
                                ),
                                onPressed: () {
                                  setState(() {
                                    takenRequestItem.here =
                                        !takenRequestItem.here;
                                  });
                                },
                                child: const Text('At Restaurant'),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8.0),
                                child: Image.asset(
                                  'images/Delete.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyApp.mGreen,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                          'Do you really want to delete this request?'),
                                      content: const Text(
                                          'You have to take the request again from the public request page.'),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: MyApp.mRed,
                                          ),
                                          onPressed: () async {
                                            final currUserID = FirebaseAuth
                                                .instance.currentUser?.uid;
                                            final db =
                                                FirebaseFirestore.instance;

                                            await db
                                                .collection("users")
                                                .doc(currUserID)
                                                .update({
                                              'taken_requests':
                                                  FieldValue.arrayRemove(
                                                      [takenRequestItem.id])
                                            });

                                            await db
                                                .collection("public_requests")
                                                .doc(takenRequestItem.id)
                                                .update({
                                              'accepted_users_id':
                                                  FieldValue.arrayRemove(
                                                      [currUserID])
                                            });
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text('Delete'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: MyApp.mGreen,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
