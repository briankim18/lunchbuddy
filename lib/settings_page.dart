import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:lunch_buddy/main.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final TextEditingController emailController = TextEditingController();
final TextEditingController newEmailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController newPasswordController = TextEditingController();
final TextEditingController newReviewController = TextEditingController();
final TextEditingController confirmNewPasswordController =
TextEditingController();

final FirebaseFirestore db = FirebaseFirestore.instance;

final _formKey = GlobalKey<FormState>();

const int itemCount = 20;

String reviewMessage = '';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  var reviewObj;
  final currUserId = FirebaseAuth.instance.currentUser?.uid;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 30),
      Text("Settings", style: GoogleFonts.indieFlower(fontSize: 50)),
      TextButton(
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
        child:
        Text('Notifications', style: GoogleFonts.indieFlower(fontSize: 30)),
      ),
      TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Change Email'),
                  content: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: emailController,
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Email cannot be empty.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Old Email",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
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
                                labelText: "Old Password",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            TextFormField(
                              controller: newEmailController,
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Email cannot be empty.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "New Email",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(4),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Only allow signing up when all validations passed
                                  bool valid = false;
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<AuthenticationService>()
                                        .reauthenticate(
                                        email: emailController.text.trim(),
                                        password:
                                        passwordController.text.trim());
                                    context
                                        .read<AuthenticationService>()
                                        .updateEmail(
                                        email:
                                        newEmailController.text.trim())
                                        .then((String? result) => (String?
                                    result) =>
                                    {
                                      if (result != null &&
                                          result.startsWith("ERROR"))
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content:
                                              Text(result)))
                                        }
                                      else
                                        {
                                          db
                                              .collection("users")
                                              .doc(result)
                                              .set({
                                            "email": newEmailController
                                                .text
                                                .trim()
                                          }),
                                          Navigator.pop(context)
                                        }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyApp.bYellow,
                                  elevation: 4,
                                ),
                                child: Text(
                                  "Change Email",
                                  style: GoogleFonts.indieFlower(
                                      fontSize: 24, color: MyApp.dGreen),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        },
        child:
        Text('Change email', style: GoogleFonts.indieFlower(fontSize: 30)),
      ),
      TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Change Password'),
                  content: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: emailController,
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Email cannot be empty.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Old Email",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
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
                                labelText: "Old Password",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            TextFormField(
                              controller: newPasswordController,
                              obscureText: true,
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Password cannot be empty.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "New Password",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            TextFormField(
                              controller: confirmNewPasswordController,
                              obscureText: true,
                              validator: (String? value) {
                                if (value != null && value.isEmpty) {
                                  return "Please re-enter your password.";
                                }
                                if (newPasswordController.text != value) {
                                  return "Password does not match.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Confirm New Password",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(4),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Only allow signing up when all validations passed
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<AuthenticationService>()
                                        .reauthenticate(
                                        email: emailController.text.trim(),
                                        password:
                                        passwordController.text.trim());
                                    context
                                        .read<AuthenticationService>()
                                        .updatePassword(
                                        password: newPasswordController.text
                                            .trim())
                                        .then((String? result) => (String?
                                    result) =>
                                    {
                                      if (result != null &&
                                          result.startsWith("ERROR"))
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content:
                                              Text(result)))
                                        }
                                      else
                                        {
                                          db
                                              .collection("users")
                                              .doc(result)
                                              .set({
                                            "password":
                                            newPasswordController
                                                .text
                                                .trim()
                                          }),
                                          Navigator.pop(context)
                                        }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyApp.bYellow,
                                  elevation: 4,
                                ),
                                child: Text(
                                  "Change password",
                                  style: GoogleFonts.indieFlower(
                                      fontSize: 24, color: MyApp.dGreen),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              });
        },
        child: Text('Change Password',
            style: GoogleFonts.indieFlower(fontSize: 30)),
      ),
      TextButton(
        onPressed: () {
          // Use the showDialog() function to display the review dialog
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Review our App',
                    style: GoogleFonts.indieFlower(
                        fontSize: 24, color: MyApp.dGreen)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TextField to allow the user to enter the review message
                    TextField(
                        controller: newReviewController
                    ),
                    // Button to submit the review message
                    ElevatedButton(
                      onPressed: () {
                        db.collection("reviews").add(
                            {
                              'userID': currUserId,
                              'review': newReviewController.text.trim(),
                            }
                        );
                        // Send the review message to your app for processing
                        // ...

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      child: Text('Submit Review'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Text('Write a Review',
            style: GoogleFonts.indieFlower(
                fontSize: 28, color: Colors.green)),
      ),
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
        child: Text('Log out', style: GoogleFonts.indieFlower(fontSize: 30)),
      ),
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Are you sure?"),
                    content: ElevatedButton(
                        onPressed: () {
                          context
                              .read<AuthenticationService>()
                              .deleteUser()
                              .then((String? result) => (String? result) => {
                            if (result != null &&
                                result.startsWith("ERROR"))
                              {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                    SnackBar(content: Text(result)))
                              }
                            else
                              {
                                db
                                    .collection("users")
                                    .doc(result)
                                    .delete()
                                    .then((value) =>
                                    print("User Deleted"))
                                    .catchError((error) => print(
                                    "Failed to delete user: $error")),
                                Navigator.pop(context)
                              }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 4,
                        ),
                        child: Text("Yes")));
              });
        },
        child: Text('Delete Account',
            style: GoogleFonts.indieFlower(fontSize: 30)),
      ),
    ]);
  }
}
