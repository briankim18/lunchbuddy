import 'package:lunch_buddy/public_request.dart';

class Person {
  final String firstName, lastName, location, gender, image, bio;
  final int age;
  final List<PublicRequest> myRequests;
  final List<PublicRequest> takenRequests;
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
  if (g == "Male") {
    return 'images/Male.png';
  } else if (g == "Female") {
    return 'images/Female.png';
  } else {
    return 'images/LGBTQ.png';
  }
}