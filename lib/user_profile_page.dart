import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _bioController = TextEditingController();

  String firstName = '';

  void fetchData() async {
    User? user = _firebaseAuth.currentUser;
    FirebaseFirestore.instance.collection("users").doc(user?.uid).snapshots()
    .listen((document) {
      setState(() {
        firstName = document.data()!['first_name'];
      });
    }
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          backgroundColor: MyApp.bGreen,
          elevation: 4,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ListTile(
                  title: Text(firstName),
                  leading: const Icon(Icons.person),
                  trailing: const Icon(Icons.select_all),
                  onTap: () {
                    debugPrint('');
                  },
                ),
                Container(
                  color: MyApp.aqua,
                  child: Expanded(
                    child: TextFormField(
                      maxLines: null,
                      controller: _bioController,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Bio";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Yo",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 300.0),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     debugPrint(_bioController.text);
        //   },
        //   backgroundColor: MyApp.bGreen,
        //   elevation: 4.0,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
