import 'package:flutter/services.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
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
              ),
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
              ),
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
              ),
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
              ),
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
              ),
            ),
            DropdownButtonFormField(
              value: gender,
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  gender = value!;
                });
              },
              items: genderList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Gender"
              ),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (String? value) {
                if (value != null && value.isEmpty) {
                  return "Password cannot be empty.";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Password",
              ),
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
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Only allow signing up when all validations passed
                if (_formKey.currentState!.validate()) {
                  context.read<AuthenticationService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim()).then((credential) {
                    db.collection("users").doc(credential?.user?.uid).set(
                        {"email": credential?.user?.email,
                         "username": usernameController.text.trim(),
                         "first_name": firstnameController.text.trim(),
                         "last_name": lastnameController.text.trim(),
                         "age": ageController.text.trim(),
                         "gender": gender}
                    );
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Sign Up"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Go Back")
            )
          ],
        ),
      ),
    );
  }
}