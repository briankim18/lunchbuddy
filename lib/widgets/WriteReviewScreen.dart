import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  // Variable to store the user's review message
  String reviewMessage = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Button to open the review dialog
        ElevatedButton(
          onPressed: () {
            // Use the showDialog() function to display the review dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Write a Review'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TextField to allow the user to enter the review message
                      TextField(
                        onChanged: (text) {
                          // Update the reviewMessage variable with the user's input
                          setState(() => reviewMessage = text);
                        },
                      ),
                      // Button to submit the review message
                      ElevatedButton(
                        onPressed: () {
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
          child: Text('Write a Review'),
        ),
      ],
    );
  }
  }