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
