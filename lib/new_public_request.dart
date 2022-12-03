import 'package:flutter/material.dart';
import 'package:lunch_buddy/main.dart';

class NewPublicRequestPage extends StatefulWidget {
  const NewPublicRequestPage({Key? key}) : super(key: key);

  @override
  State<NewPublicRequestPage> createState() => _NewPublicRequestPageState();
}

class _NewPublicRequestPageState extends State<NewPublicRequestPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Requests'),
        backgroundColor: MyApp.bGreen,
        elevation: 4,
      ),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    color: MyApp.aqua,
                    child: TextFormField(
                      controller: _firstNameController,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "First Name cannot be empty.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return "Last Name cannot be empty.";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // if (_formKey.currentState!.validate()) {
          debugPrint(
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}');
          Navigator.pop(context);
          // }
        },
        backgroundColor: MyApp.bGreen,
        elevation: 4.0,
        child: const Icon(Icons.add),
      ),
    );
  }
}
