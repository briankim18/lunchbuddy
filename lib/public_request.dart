import 'package:lunch_buddy/person.dart';

class PublicRequest {
  final String restName, restImage, restAddress, city, state, id;
  final DateTime datePosted, dateToMeet;
  final Person user;
  final List<String> acceptedUsers;
  bool going, here;

  PublicRequest({
    required this.id,
    required this.restName,
    required this.restImage,
    required this.restAddress,
    required this.city,
    required this.state,
    required this.datePosted,
    required this.dateToMeet,
    required this.user,
    required this.acceptedUsers,
    this.going = true,
    this.here = false,
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