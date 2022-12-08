import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/person.dart';

class PublicRequestPage extends StatefulWidget {
  const PublicRequestPage({Key? key}) : super(key: key);

  @override
  State<PublicRequestPage> createState() => _PublicRequestPageState();
}

class _PublicRequestPageState extends State<PublicRequestPage> {
  bool isSwitch = false;
  bool? isCheckbox = false;

  late Future<List<PublicRequest>> realRequests;

  Future<List<PublicRequest>> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> requestInfo;
    Map<String, dynamic> publisherInfo;
    var publisher;

    List<PublicRequest> requestList = [];

    await FirebaseFirestore.instance.collection("public_requests").get()
        .then((QuerySnapshot qSnap) async => {
          for (QueryDocumentSnapshot doc in qSnap.docs) {
            requestInfo = doc.data() as Map<String, dynamic>,

            await FirebaseFirestore.instance.collection("users")
                .doc(requestInfo['publisher_id']).get()
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
                    myRequests: publisherInfo['posted_requests'].cast<PublicRequest>(),
                    takenRequests: publisherInfo['taken_requests'].cast<PublicRequest>()
                  );
                }),

            requestList.add(
                PublicRequest(
                  id: doc.id,
                  restName: requestInfo['restaurant_name'],
                  restImage: "images/PandaExpress.png",
                  restAddress: requestInfo['restaurant_street_address'],
                  city: requestInfo['restaurant_city'],
                  state: requestInfo['restaurant_state'],
                  datePosted: DateTime.parse(requestInfo['date_posted'].toDate().toString()),
                  dateToMeet: DateTime.parse(requestInfo['meeting_datetime'].toDate().toString()),
                  user: publisher,
                  acceptedUsers: []
                )
            ),
          }
        });
    return requestList;
  }

  @override
  void initState() {
    super.initState();
    realRequests = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Requests'),
        backgroundColor: MyApp.bGreen,
        elevation: 4,
        // automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).pop();
          },
          icon: const Icon(Icons.menu),
        ),
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
                future: realRequests,
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
                                  child: PublicRequestItem(
                                      publicRequestItem:
                                          snapshot.data![index])),
                            ),
                          ),
                        );
                }),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }
}

class PublicRequestItem extends StatelessWidget {
  final PublicRequest publicRequestItem;
  const PublicRequestItem({
    Key? key,
    required this.publicRequestItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: randomColor(),
        height: MediaQuery.of(context).size.height * 0.2,
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
                  publicRequestItem.restImage,
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
                  publicRequestItem.user.image,
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
                          publicRequestItem.restName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '(${publicRequestItem.city}, ${publicRequestItem.state})',
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
                                genderSymbol(publicRequestItem.user),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Text(
                              '${publicRequestItem.user.gender} ${publicRequestItem.user.age}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.indieFlower(
                                fontSize: 20,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${publicRequestItem.user.firstName} ${publicRequestItem.user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 24,
                            height: .5,
                          ),
                        ),
                        Text(
                          '${getMeetWeekday(publicRequestItem)} ${publicRequestItem.dateToMeet.month}/${publicRequestItem.dateToMeet.day} ${getMeetTime(publicRequestItem)}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 18,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // This is button that we can later change to take request
            Padding(
              padding: const EdgeInsets.only(
                left: 220,
                top: 104,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyApp.mGreen,
                ),
                onPressed: () {
                  final currID = FirebaseAuth.instance.currentUser?.uid;

                  FirebaseFirestore.instance.collection("users").doc(currID)
                  .update({'taken_requests': FieldValue.arrayUnion([publicRequestItem.id])});

                  FirebaseFirestore.instance.collection("public_requests").doc(publicRequestItem.id)
                  .update({'accepted_users_id': FieldValue.arrayUnion([currID])});
                },
                child: const Text('Take Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
