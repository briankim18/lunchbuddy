import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';

class PublicRequestPage extends StatefulWidget {
  const PublicRequestPage({Key? key}) : super(key: key);

  @override
  State<PublicRequestPage> createState() => _PublicRequestPageState();
}

class _PublicRequestPageState extends State<PublicRequestPage> {
  bool isSwitch = false;
  bool? isCheckbox = false;

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
            Container(height: 16, color: Colors.transparent),
            Column(
              children: List.generate(
                publicRequests.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  // index == 0
                  //     ? const EdgeInsets.only(left: 20, right: 20)
                  //     : const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      child: PublicRequestItem(
                          publicRequestItem: publicRequests[index])),
                ),
              ),
            ),
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
        height: MediaQuery.of(context).size.height * 0.20,
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
                                genderSymbol(publicRequestItem),
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
                          style: GoogleFonts.indieFlower(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '(${publicRequestItem.city}, ${publicRequestItem.state})',
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

  static const List<String> daysOfWeek = [
    "Empty Day",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  // Returns the weekday
  getMeetWeekday(PublicRequest publicRequest) {
    return daysOfWeek[publicRequest.dateToMeet.weekday];
  }

  // Hour:Minute AM/PM
  getMeetTime(PublicRequest publicRequest) {
    return publicRequest.dateToMeet.hour > 12
        ? "${publicRequestItem.dateToMeet.hour - 12}:${publicRequestItem.dateToMeet.minute} PM"
        : "${publicRequestItem.dateToMeet.hour}:${publicRequestItem.dateToMeet.minute}AM";
  }

  // Picks a random light color
  randomColor() {
    return MyApp.bColors[Random().nextInt(6)];
  }

  // Changes symbol based on gender
  genderSymbol(PublicRequest publicRequest) {
    var g = publicRequest.user.gender;
    if (g == 'M') {
      return 'images/Male.png';
    } else if (g == 'F') {
      return 'images/Female.png';
    } else {
      return 'images/LGBTQ.png';
    }
  }
}
