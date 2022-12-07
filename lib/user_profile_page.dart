import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/user.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? id = context.read<AuthenticationService>().getCurrentUser()?.uid;
    final db = FirebaseFirestore.instance.collection("users").doc(id);
    User currUser = users[0];

    var data = <String, dynamic>{};

    db.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
        debugPrint(data.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );

    getData(String field) {
      return data[field];
    }
    
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
                    Row(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            currUser.image,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.height * 0.2,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${currUser.firstName} ${currUser.lastName}',
                              overflow: TextOverflow.ellipsis,
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
                                    genderSymbol(currUser),
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Text(
                                  '${currUser.gender} ${currUser.age}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.indieFlower(
                                    fontSize: 20,
                                    height: .5,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              currUser.location,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.indieFlower(
                                fontSize: 20,
                                color: MyApp.dGreen,
                                height: .5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Bio:',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.indieFlower(
                        fontSize: 20,
                        color: MyApp.dGreen,
                      ),
                    ),
                    Text(
                      currUser.bio,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.indieFlower(
                        fontSize: 20,
                        color: MyApp.dGreen,
                      ),
                    ),
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        publicRequests.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          child: GestureDetector(
                              child: MyRequestItem(
                                  myRequestItem: publicRequests[index])),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 96,
                    ),
                  ],
                ),
              ),
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
              top: 12,
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
              top: 12,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${myRequestItem.user.firstName} ${myRequestItem.user.lastName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 20,
                            height: .5,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 8.0),
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
                                height: .5,
                              ),
                            ),
                          ],
                        ),
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
                            height: 1,
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
                top: 90,
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
