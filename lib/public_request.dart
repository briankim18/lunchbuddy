import 'package:lunch_buddy/user.dart';

class PublicRequest {
  final String restName, restImage, restAddress, city, state;
  final DateTime datePosted, dateToMeet;
  final User user;
  final List<User> acceptedUsers;

  PublicRequest({
    required this.restName,
    required this.restImage,
    required this.restAddress,
    required this.city,
    required this.state,
    required this.datePosted,
    required this.dateToMeet,
    required this.user,
    required this.acceptedUsers,
  });
}

List<String> daysOfWeek = [
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
      ? "${publicRequest.dateToMeet.hour - 12}:${publicRequest.dateToMeet.minute} PM"
      : "${publicRequest.dateToMeet.hour}:${publicRequest.dateToMeet.minute}AM";
}

List<PublicRequest> kevinTakenRequests = [
  PublicRequest(
    restName: "Panda Express",
    restImage: "www.google.com",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-10-20 20:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 20:18:04Z'),
    user: users[1],
    acceptedUsers: [],
  ),
  PublicRequest(
    restName: "Panda Express",
    restImage: "images/PandaExpress.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-10-20 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 10:18:04Z'),
    user: users[2],
    acceptedUsers: [],
  ),
];

List<PublicRequest> publicRequests = [
  PublicRequest(
    restName: "Panda Express",
    restImage: "images/PandaExpress.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-10-20 20:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 20:18:04Z'),
    user: users[1],
    acceptedUsers: [],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Roots Natural Kitchen, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-11-14 20:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 20:18:04Z'),
    user: users[0],
    acceptedUsers: [],
  ),
  PublicRequest(
    restName: "Panda Express",
    restImage: "images/PandaExpress.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Panda Express, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-10-20 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 10:18:04Z'),
    user: users[2],
    acceptedUsers: [],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Roots Natural Kitchen, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-11-14 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 10:18:04Z'),
    user: users[3],
    acceptedUsers: [],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    restAddress: "Roots Natural Kitchen, Prices Fork Road, Blacksburg, VA",
    datePosted: DateTime.parse('2022-11-14 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 10:18:04Z'),
    user: users[0],
    acceptedUsers: [],
  ),
];
