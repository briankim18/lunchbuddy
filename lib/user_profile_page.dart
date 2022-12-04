import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';
import 'package:lunch_buddy/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? id = context.read<AuthenticationService>().getCurrentUser()?.uid;
    final db = FirebaseFirestore.instance.collection("users").doc(id);

    var data = <String, dynamic>{};

    db.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
        debugPrint(data.toString());
      },
      onError: (e) => print("Error getting document: $e"),
    );

    getData(String field) {
      return data[field];
    }

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
                  title: Text('yo'),
                  leading: const Icon(Icons.person),
                  trailing: const Icon(Icons.select_all),
                  onTap: () {
                    debugPrint('Item ${(data['last_name'])}');
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
                      decoration: InputDecoration(
                        labelText: '${(getData('last_name'))}',
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
