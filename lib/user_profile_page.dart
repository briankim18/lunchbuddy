import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/public_request.dart';
import 'package:lunch_buddy/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Person?> currUser;
  late Future<List<PublicRequest>> myRequests;
  File? image;
  String bio = "";
  final TextEditingController bioController = TextEditingController();

  /// Opens the phone's image gallery to let users pick an image for their
  /// profile picture
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null){
        return;
      }
      final imageTemp = File(image.path);
      updateImage(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to select image');
    }
  }

  // Returns the image url from a user
  String getImage() {
    final currUserID = FirebaseAuth.instance.currentUser?.uid;
    String imageURL = "";
    Map<String,dynamic> data;
    FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .get().then((DocumentSnapshot snap) {
      data = snap.data() as Map<String, dynamic>;
      imageURL = data['image'];
    });

    return imageURL;
  }

  // Returns a user's bio
  String getBio() {
    final currUserID = FirebaseAuth.instance.currentUser?.uid;
    String bio = "";
    Map<String,dynamic> data;
    FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .get().then((DocumentSnapshot snap) {
      data = snap.data() as Map<String, dynamic>;
      bio = data['bio'];
    });

    return bio;
  }

  // Updates a user's bio
  Future<void> updateBio(String bio) {
    final currUserID = FirebaseAuth.instance.currentUser?.uid;
    setState(() => this.bio = bio);
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .update({'bio': bio})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateImage(String image) {
    final currUserID = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .update({'image': image})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // Fetches the current user's posted requests
  Future<List<PublicRequest>> fetchRequests() async {
    await Future.delayed(const Duration(seconds: 1));

    Map<String, dynamic> requestInfo;
    Map<String, dynamic> publisherInfo;
    Map<String, dynamic> userInfo;

    var publisher;

    List<PublicRequest> myRequestList = [];

    final currUserID = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currUserID)
        .get()
        .then((DocumentSnapshot doc) async {
      userInfo = doc.data() as Map<String, dynamic>;
      for (String postedRequestID in userInfo['posted_requests']) {
        await FirebaseFirestore.instance
            .collection("public_requests")
            .doc(postedRequestID)
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

          myRequestList.add(PublicRequest(
              id: docSnap.id,
              restName: requestInfo['restaurant_name'],
              restImage: requestInfo['restaurant_image'],
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
    return myRequestList;
  }

  // Fetches the information about a current user
  Future<Person?> fetchUser() async {
    await Future.delayed(const Duration(seconds: 1));

    final currentUserID = FirebaseAuth.instance.currentUser?.uid;
    Map<String, dynamic> data = {};

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });

    return Person(
        firstName: data['first_name'],
        lastName: data['last_name'],
        location: data['location'],
        gender: data['gender'],
        image: 'images/Kevin.png',
        bio: data['bio'],
        age: int.parse(data['age']),
        myRequests: data['posted_requests'].cast<PublicRequest>(),
        takenRequests: data['taken_requests'].cast<PublicRequest>());
  }

  @override
  void initState() {
    super.initState();

    // Fetches data from the database
    myRequests = fetchRequests();
    currUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    bio = getBio();
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
                              Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: image != null ? Image.file(
                                    image!,
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.2,
                                    width: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.2,
                                  ) :
                                  Image.asset(
                                    snapshot.data?.image ?? "",
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.2,
                                    width: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.2,
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: IconButton(
                                      icon: ClipOval(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(4),
                                          color: Colors.blue,
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        pickImage();
                                      },
                                    )),
                              ]),
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
                    Row(children: [
                      Text(
                        'Bio:',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.indieFlower(
                          fontSize: 20,
                          color: MyApp.dGreen,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('Edit Bio'),
                                    content: Column(
                                      children: [
                                        TextFormField(
                                          controller: bioController,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              updateBio(bioController.text);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Comfirm Bio'))
                                      ],
                                    )
                                );
                              }
                          );
                        },
                      ),
                    ]),
                    Text(bio),
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
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FutureBuilder<List<PublicRequest>>(
                        future: myRequests,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint(snapshot.error.toString());
                          }

                          return snapshot.connectionState ==
                              ConnectionState.waiting
                              ? SizedBox(
                            height:
                            MediaQuery.of(context).size.height / 1.3,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : Column(
                            children: List.generate(
                              snapshot.data!.length,
                                  (index) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 8,
                                    bottom: 8),
                                child: GestureDetector(
                                    child: MyRequestItem(
                                        myRequestItem:
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
            ],
          ),
        ),
      ),
    );
  }
}

class MyRequestItem extends StatefulWidget {

  var myRequestItem;

  MyRequestItem({
    Key? key,
    required this.myRequestItem,
  }) : super(key: key);

  @override
  State<MyRequestItem> createState() =>
      _MyRequestItemState(myRequestItem);
}

class _MyRequestItemState extends State<MyRequestItem> {
  final PublicRequest myRequestItem;

  _MyRequestItemState(this.myRequestItem);

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
                child: Image.network(
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
                            fontSize: 24,
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                          'Do you really want to delete your posted request?'),
                      content: const Text(
                          'You will have to make another request and this request will disappear'
                              'for other users.'),
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

                            // Deletes the id of the request from the 'posted_request'
                            // field in the current user's document in the database
                            await db
                                .collection("users")
                                .doc(currUserID)
                                .update({
                              'posted_requests':
                              FieldValue.arrayRemove(
                                  [myRequestItem.id])
                            });

                            // Deletes the id of the request from the 'taken_request'
                            // field for every user that accepted this request
                            await db
                                .collection("public_requests")
                                .doc(myRequestItem.id)
                                .get()
                                .then((DocumentSnapshot doc) async {
                                  for (String userID in doc.get("accepted_users_id")) {
                                    await db
                                        .collection("users")
                                        .doc(userID)
                                        .update(
                                          {'taken_requests': FieldValue.arrayRemove([myRequestItem.id])}
                                        );
                                  }
                            });

                            await db
                                .collection("public_requests")
                                .doc(myRequestItem.id)
                                .delete();

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
                child: const Text('Delete Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}