import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/user.dart';

class PublicRequestPage extends StatefulWidget {
  const PublicRequestPage({Key? key}) : super(key: key);

  @override
  State<PublicRequestPage> createState() => _PublicRequestPageState();
}

class _PublicRequestPageState extends State<PublicRequestPage> {
  bool isSwitch = false;
  bool? isCheckbox = false;

  List<PublicRequest> realRequests = [];

  void fetchData() async {
    Map<String, dynamic> requestInfo;

    await FirebaseFirestore.instance.collection("public_requests").get()
        .then((QuerySnapshot qSnap) => {
          for (QueryDocumentSnapshot doc in qSnap.docs) {
            requestInfo = doc.data() as Map<String, dynamic>,
            realRequests.add(
                PublicRequest(
                  restName: requestInfo['restaurant_name'],
                  restImage: "images/PandaExpress.png",
                  restAddress: requestInfo['restaurant_street_address'],
                  city: requestInfo['restaurant_city'],
                  state: requestInfo['restaurant_state'],
                  datePosted: DateTime.parse(requestInfo['date_posted'].toDate().toString()),
                  dateToMeet: DateTime.parse(requestInfo['meeting_datetime'].toDate().toString()),
                  user: users[0],
                  acceptedUsers: []
                )
            )
          }
        });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(realRequests.toString());
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
            Column(
              children: List.generate(
                realRequests.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  child: GestureDetector(
                      child: PublicRequestItem(
                          publicRequestItem: realRequests[index]
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 96,),
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
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // This is for the image 1
            Positioned(
              top: 24,
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
              top: 24,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${publicRequestItem.user.firstName} ${publicRequestItem.user.lastName}',
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
                                genderSymbol(publicRequestItem.user),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Text(
                              '${publicRequestItem.user.gender} ${publicRequestItem.user.age}',
                              style: GoogleFonts.indieFlower(
                                fontSize: 20,
                                height: .5,
                              ),
                            ),
                          ],
                        ),
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
                            height: 1,
                          ),
                        ),
                        Text(
                          '${getMeetWeekday(publicRequestItem)} ${publicRequestItem.dateToMeet.month}/${publicRequestItem.dateToMeet.day} ${getMeetTime(publicRequestItem)}',
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
                top: 100,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyApp.bGreen,
                ),
                onPressed: () {
                  debugPrint("YO");
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
