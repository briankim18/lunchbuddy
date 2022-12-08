import 'package:lunch_buddy/public_request.dart';

class Person {
  final String firstName, lastName, location, gender, image, bio;
  final int age;
  final List<String> myRequests;
  final List<String> takenRequests;
  // List of publicRequests taken

  Person({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.gender,
    required this.image,
    required this.bio,
    required this.age,
    required this.myRequests,
    required this.takenRequests,
  });
}

// Changes symbol based on gender
genderSymbol(Person? user) {
  var g = user?.gender;
  if (g == 'Male') {
    return 'images/Male.png';
  } else if (g == 'Female') {
    return 'images/Female.png';
  } else {
    return 'images/LGBTQ.png';
  }
}

List<Person> users = [
  Person(
    firstName: "Kevin",
    lastName: "Vu",
    location: "Centreville, VA",
    gender: "M",
    image: 'images/Kevin.png',
    bio: '''
    Close enough Close enough Close enough Close enough Close enough Close enough Close enough 
    VTech Hokies 23
    Art @yubelportraits
    ''',
    age: 21,
    myRequests: [
      // PublicRequest(
      //   restName: "Panda Express",
      //   restImage: "images/PandaExpress.png",
      //   city: "Blacksburg",
      //   state: "VA",
      //   restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
      //   datePosted: DateTime.parse('2022-10-20 20:18:04Z'),
      //   dateToMeet: DateTime.parse('2022-11-14 20:18:04Z'),
      //   user: Person(
      //     firstName: "Ryan",
      //     lastName: "Le",
      //     location: "Mechanicsville, VA",
      //     gender: "M",
      //     image: 'images/Ryan.png',
      //     bio: "",
      //     age: 22,
      //     myRequests: [],
      //     takenRequests: [],
      //   ),
      //   acceptedUsers: [],
      // ),
      // PublicRequest(
      //   restName: "Panda Express",
      //   restImage: "images/PandaExpress.png",
      //   city: "Blacksburg",
      //   state: "VA",
      //   restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
      //   datePosted: DateTime.parse('2022-10-20 10:18:04Z'),
      //   dateToMeet: DateTime.parse('2022-11-14 10:18:04Z'),
      //   user: Person(
      //     firstName: "Ryan",
      //     lastName: "Le",
      //     location: "Mechanicsville, VA",
      //     gender: "M",
      //     image: 'images/Ryan.png',
      //     bio: "",
      //     age: 22,
      //     myRequests: [],
      //     takenRequests: [],
      //   ),
      //   acceptedUsers: [],
      // ),
    ],
    takenRequests: [],
  ),
  Person(
    firstName: "Ryan",
    lastName: "Le",
    location: "Mechanicsville, VA",
    gender: "M",
    image: 'images/Ryan.png',
    bio: "",
    age: 22,
    myRequests: [],
    takenRequests: [],
  ),
  Person(
    firstName: "Emily",
    lastName: "Lu",
    location: "Westminster, CA",
    gender: "F",
    image: 'images/Female.png',
    bio: "",
    age: 22,
    myRequests: [],
    takenRequests: [],
  ),
  Person(
    firstName: "Jessie",
    lastName: "Jess",
    location: "New York City, NY",
    gender: "LGBTQ",
    image: 'images/LGBTQ.png',
    bio: "",
    age: 30,
    myRequests: [],
    takenRequests: [],
  ),
];
