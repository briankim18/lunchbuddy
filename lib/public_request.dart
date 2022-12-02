import 'package:flutter/material.dart';

class PublicRequest {
  final String restName, restImage, city, state;
  final DateTime datePosted, dateToMeet;
  final User user;

  PublicRequest({
    required this.restName,
    required this.restImage,
    required this.city,
    required this.state,
    required this.datePosted,
    required this.dateToMeet,
    required this.user,
  });
}

class User {
  final String firstName, lastName, location, gender, image, bio;
  final int age;
  // List of publicRequests taken

  User({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.gender,
    required this.image,
    required this.bio,
    required this.age,
  });
}

List<User> users = [
  User(
    firstName: "Kevin",
    lastName: "Vu",
    location: "Centreville, VA",
    gender: "M",
    image: 'images/Kevin.png',
    bio: "",
    age: 21,
  ),
  User(
    firstName: "Ryan",
    lastName: "Le",
    location: "Mechanicsville, VA",
    gender: "M",
    image: 'images/Ryan.png',
    bio: "",
    age: 22,
  ),
  User(
    firstName: "Emily",
    lastName: "Lu",
    location: "Westminster, CA",
    gender: "F",
    image: 'images/Female.png',
    bio: "",
    age: 22,
  ),
  User(
    firstName: "Jessie",
    lastName: "Jess",
    location: "New York City, NY",
    gender: "LGBTQ",
    image: 'images/LGBTQ.png',
    bio: "",
    age: 30,
  ),
];

List<PublicRequest> publicRequests = [
  PublicRequest(
    restName: "Panda Express",
    restImage: "images/PandaExpress.png",
    city: "Blacksburg",
    state: "VA",
    datePosted: DateTime.parse('2022-10-20 20:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 20:18:04Z'),
    user: users[1],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    datePosted: DateTime.parse('2022-11-14 20:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 20:18:04Z'),
    user: users[0],
  ),
  PublicRequest(
    restName: "Panda Express",
    restImage: "images/PandaExpress.png",
    city: "Blacksburg",
    state: "VA",
    datePosted: DateTime.parse('2022-10-20 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-11-14 10:18:04Z'),
    user: users[2],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    datePosted: DateTime.parse('2022-11-14 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 10:18:04Z'),
    user: users[3],
  ),
  PublicRequest(
    restName: "Roots Natural Kitchen",
    restImage: "images/Roots.png",
    city: "Blacksburg",
    state: "VA",
    datePosted: DateTime.parse('2022-11-14 10:18:04Z'),
    dateToMeet: DateTime.parse('2022-10-14 10:18:04Z'),
    user: users[0],
  ),
];
String desc =
    'This cat is a domestic species of small carnivorous mammal. It is the only domesticated species in the family Felidae and is often reffered to as the domestic cat to distinguish it from the wild members of the family. A cat can either be a house cat, a farm cat or a feral cat, the latter rangers freely and avoids human contacts. Domestic cats are valued by humans for companionship and their ability to kill redonts. About 60 cat breeds are recognized by various cat registries.';
    // 'Leo is a cat that i have found on the side of the road 1 year ago he is now a cheerful and active cat';