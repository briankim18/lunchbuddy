import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/user.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();


class PublicRequestPage extends StatefulWidget {
  const PublicRequestPage({Key? key}) : super(key: key);

  @override
  State<PublicRequestPage> createState() => _PublicRequestPageState();
}

class _PublicRequestPageState extends State<PublicRequestPage> {
  bool isSwitch = false;
  bool? isCheckbox = false;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController ageController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawerEnableOpenDragGesture: false,
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
                    Text(
                      "Filters",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          height: 3),
                    ),
                    Text(
                        "Search Restaurant",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Restaurant Name",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                        "Search Location",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Location",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                        "From Date",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)
                    ),
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
                              fromDate.text = DateFormat("mm-dd-yyyy").format(
                                  from);
                            }
                          }
                      ),
                    ),
                    Text(
                        "To Date",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)
                    ),
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
                              toDate.text = DateFormat("mm-dd-yyyy").format(
                                  to);
                            }
                          }
                      ),
                    ),
                    Text(
                        "Distance",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                      child: TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Distance",
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Public Requests'),
        backgroundColor: MyApp.bGreen,
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
            Column(
              children: List.generate(
                publicRequests.length,
                    (index) =>
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: GestureDetector(
                          child: PublicRequestItem(
                              publicRequestItem: publicRequests[index]
                          )
                      ),
                    ),
              ),
            ),
            SizedBox(
              height: 96,
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
        height: MediaQuery
            .of(context)
            .size
            .height * 0.22,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
                          '${publicRequestItem.user
                              .firstName} ${publicRequestItem.user.lastName}',
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
                              '${publicRequestItem.user
                                  .gender} ${publicRequestItem.user.age}',
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
                          '(${publicRequestItem.city}, ${publicRequestItem
                              .state})',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.indieFlower(
                            fontSize: 16,
                            height: 1,
                          ),
                        ),
                        Text(
                          '${getMeetWeekday(
                              publicRequestItem)} ${publicRequestItem.dateToMeet
                              .month}/${publicRequestItem.dateToMeet
                              .day} ${getMeetTime(publicRequestItem)}',
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
