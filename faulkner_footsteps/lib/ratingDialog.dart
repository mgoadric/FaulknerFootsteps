import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double userRating = 0.0;

  @override
  Widget build(BuildContext build) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 72, 52, 52), // Darker background
      title: Text(
        'Please rate your experience at this location:',
        style: GoogleFonts.sancreek(
            textStyle: const TextStyle(color: Color.fromARGB(255, 238, 214, 196))), // Lighter text color
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: StarRating(
              rating: userRating,
              starCount: 5,
              onRatingChanged: (rating) {
                setState(() {
                  userRating = rating;
                });
              },
              borderColor: const Color.fromARGB(255, 238, 214, 196), // Lighter border color
              color: const Color.fromARGB(255, 255, 243, 228), // Lighter star color
              size: 50.0,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.rakkas(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 238, 214, 196), fontSize: 20.0)), // Button text color
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(userRating);
          },
          child: Text(
            "Submit",
            style: GoogleFonts.rakkas(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 238, 214, 196), fontSize: 20.0)), // Button text color
          ),
        ),
      ],
    );
  }
}
