import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/person.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key? key}) : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  bool isSwitch = false;
  bool? isCheckbox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taken Requests'),
        backgroundColor: MyApp.mGreen,
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
                publicRequests.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  child: GestureDetector(
                      child: TakenRequestItem(
                          publicRequestItem: publicRequests[index])),
                ),
              ),
            ),
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
              top: 12,
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
              top: 12,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${takenRequestItem.user.firstName} ${takenRequestItem.user.lastName}',
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
                                height: .5,
                              ),
                            ),
                          ],
                        ),
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
                            height: 1,
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
                                child: const Text('At Resturant'),
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
                                          onPressed: () {
                                            // Add stuff to delete context
                                            Navigator.pop(context);
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
