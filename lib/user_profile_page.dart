import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Person?> currUser;

  Future<Person?> fetchData() async {
    await Future.delayed(const Duration(seconds: 1));

    final currentUserID =  FirebaseAuth.instance.currentUser?.uid;
    Map<String, dynamic> data = {};

    await FirebaseFirestore.instance.collection("users").doc(currentUserID).get().then(
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>;
        }
    );

      return Person(
          firstName: data['first_name'],
          lastName: data['last_name'],
          location: data['location'],
          gender: data['gender'],
          image: 'images/Kevin.png',
          bio: data['bio'],
          age: data['age'],
          myRequests: data['posted_requests'],
          takenRequests: data['taken_requests']);
    });
    return currentPerson;
  }

  @override
  void initState() {
    super.initState();
    currUser = fetchData();
    if (currUser == null) {
      debugPrint('User is somehow null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 36, left: 20, right: 20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                color: MyApp.bGreen,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<Person?>(
                        future: currUser,
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Row(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        snapshot.data?.image ?? "",
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        width: MediaQuery.of(context).size.height * 0.2,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${snapshot.data?.firstName} ${snapshot.data?.lastName}',
                                          style: GoogleFonts.indieFlower(
                                            fontSize: 36,
                                            color: MyApp.dGreen,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, bottom: 8.0),
                                              child: Image.asset(
                                                genderSymbol(snapshot.data),
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            Text(
                                              '${snapshot.data?.gender} ${snapshot.data?.age}',
                                              style: GoogleFonts.indieFlower(
                                                fontSize: 20,
                                                height: .5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          snapshot.data?.location ?? "",
                                          style: GoogleFonts.indieFlower(
                                            fontSize: 20,
                                            color: MyApp.dGreen,
                                            height: .5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        }),
                    const SizedBox(height: 12),
                    Text(
                      'Bio:',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.indieFlower(
                        fontSize: 20,
                        color: MyApp.dGreen,
                      ),
                    ),
                    FutureBuilder<Person?>(
                        future: currUser,
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.3,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Text(
                                  snapshot.data?.bio ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.indieFlower(
                                    fontSize: 20,
                                    color: MyApp.dGreen,
                                  ),
                                );
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Your Requests',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.indieFlower(
                  fontSize: 24,
                  color: MyApp.dGreen,
                ),
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child: Column(
              //     children: [
              //       Column(
              //         children: List.generate(
              //           publicRequests.length,
              //           (index) => Padding(
              //             padding: const EdgeInsets.only(
              //                 left: 20, right: 20, top: 8, bottom: 8),
              //             child: GestureDetector(
              //                 child: MyRequestItem(
              //                     myRequestItem: publicRequests[index])),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(
              //         height: 96,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyRequestItem extends StatelessWidget {
  final PublicRequest myRequestItem;
  const MyRequestItem({
    Key? key,
    required this.myRequestItem,
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
                  myRequestItem.restImage,
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
                  myRequestItem.user.image,
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
                          myRequestItem.restName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '(${myRequestItem.city}, ${myRequestItem.state})',
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
                                genderSymbol(myRequestItem.user),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Text(
                              '${myRequestItem.user.gender} ${myRequestItem.user.age}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.indieFlower(
                                fontSize: 20,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${myRequestItem.user.firstName} ${myRequestItem.user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 20,
                            height: .5,
                          ),
                        ),
                        Text(
                          '${getMeetWeekday(myRequestItem)} ${myRequestItem.dateToMeet.month}/${myRequestItem.dateToMeet.day} ${getMeetTime(myRequestItem)}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 20,
                            height: 1.6,
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
                  debugPrint("YO");
                },
                child: const Text('Delete Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
