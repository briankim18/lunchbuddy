import 'package:flutter/services.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class DummyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SignUpPage();
}

class _SignUpPageState extends State<SignUpPage> {
  late String gender;

  final List<String> genderList = <String>["Male", "Female", "Other"];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  /// initialization is here:
  @override
  void initState() {
    super.initState();
    gender = genderList[0];
  }

  // This is the trick!
  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => DummyWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 15, 255, 151),
          body: SizedBox(
            height: screenHeight - keyboardHeight,
            child: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.33,
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
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                // padding: const EdgeInsets.all(10),
                                fixedSize: const Size(100, 40),
                                backgroundColor: MyApp.bGreen,
                                elevation: 4,
                              ),
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.indieFlower(
                                    fontSize: 20, color: MyApp.dGreen),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                // padding: const EdgeInsets.all(10),
                                fixedSize: const Size(100, 40),
                                backgroundColor: MyApp.aqua,
                                elevation: 4,
                              ),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.indieFlower(
                                    fontSize: 20, color: MyApp.dGreen),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Lunch Buddy",
                          style: GoogleFonts.indieFlower(
                              fontSize: 50, color: MyApp.dGreen)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Email cannot be empty.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Username",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Username cannot be empty.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("First Name",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
                          controller: firstnameController,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "First name cannot be empty.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Last Name",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
                          controller: lastnameController,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Last name cannot be empty.";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Age",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Gender",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: DropdownButtonFormField(
                          value: gender,
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              gender = value!;
                            });
                          },
                          items: genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Password",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
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
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Confirm Password",
                            style: GoogleFonts.indieFlower(
                                fontSize: 20, height: 2)),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(4),
                        ),
                        child: TextFormField(
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
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                                .signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim())
                                .then((String? result) => {
                                      if (result != null &&
                                          result.startsWith("ERROR"))
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(result)))
                                        }
                                      else
                                        {
                                          db
                                              .collection("users")
                                              .doc(result)
                                              .set({
                                            "email":
                                                emailController.text.trim(),
                                            "username":
                                                usernameController.text.trim(),
                                            "first_name":
                                                firstnameController.text.trim(),
                                            "last_name":
                                                lastnameController.text.trim(),
                                            "age": ageController.text.trim(),
                                            "gender": gender,
                                            "location": '',
                                            "bio": '',
                                            "posted_requests": [],
                                            "taken_requests": []
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
                        child: ElevatedButton(
                          onPressed: () {
                            // Only allow signing up when all validations passed
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<AuthenticationService>()
                                  .signUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim())
                                  .then((String? result) => {
                                        if (result != null &&
                                            result.startsWith("ERROR"))
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(result)))
                                          }
                                        else
                                          {
                                            db
                                                .collection("users")
                                                .doc(result)
                                                .set({
                                              "email":
                                                  emailController.text.trim(),
                                              "username": usernameController
                                                  .text
                                                  .trim(),
                                              "first_name": firstnameController
                                                  .text
                                                  .trim(),
                                              "last_name": lastnameController
                                                  .text
                                                  .trim(),
                                              "age": ageController.text.trim(),
                                              "gender": gender
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
                            "Create New Account",
                            style: GoogleFonts.indieFlower(
                                fontSize: 24, color: MyApp.dGreen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
