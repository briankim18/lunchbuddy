import 'package:flutter/services.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late String gender;

  final List<String> genderList = <String>[
    "Male", "Female", "Other"
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  /// initialization is here:
  @override
  void initState() {
    super.initState();
    gender = genderList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 15, 255, 151),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Lunch Buddy",
                      style: GoogleFonts.indieFlower(fontSize: 50)),
                  Text("Sign Up", style: TextStyle(fontSize: 30)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Email", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Email cannot be empty.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Username", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: usernameController,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Username cannot be empty.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("First Name",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: firstnameController,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "First name cannot be empty.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Last Name", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: lastnameController,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Last name cannot be empty.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Age", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Age cannot be empty.";
                      }

                      if (int.parse(value!) < 18) {
                        return "You must be 18 or older to sign up for this app.";
                      }
                      
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Gender", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  DropdownButtonFormField(
                    value: gender,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        gender = value!;
                      });
                    },
                    items: genderList.map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Password", style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Password cannot be empty.";
                      }
                      
                      if (value != null && value.length < 6) {
                        return "Password must be longer than 6 characters.";
                      }
                      
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Confirm Password",
                        style: GoogleFonts.indieFlower(fontSize: 20, height: 2)),
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Please re-enter your password.";
                      }
                      if (passwordController.text != value) {
                        return "Password does not match.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Only allow signing up when all validations passed
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthenticationService>().signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim()
                        )
                        .then((String? result) => {
                          if (result != null && result.startsWith("ERROR")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result)
                              )
                            )
                          }
                          else {
                            db.collection("users").doc(result).set(
                              {"email": emailController.text.trim(),
                                "username": usernameController.text.trim(),
                                "first_name": firstnameController.text.trim(),
                                "last_name": lastnameController.text.trim(),
                                "age": ageController.text.trim(),
                                "gender": gender}
                            ),
                            Navigator.pop(context)
                          }
                        });
                      }
                    },
                    child: const Text("Sign Up"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Go Back")
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}