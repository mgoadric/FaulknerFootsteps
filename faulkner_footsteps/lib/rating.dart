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
      title: Text(
        'Please rate your experience at this location:',
        style: GoogleFonts.sancreek(
            textStyle:
                const TextStyle(color: Color.fromARGB(255, 124, 54, 16))),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            //Stars
            child: StarRating(
              rating: userRating,
              starCount: 5,
              onRatingChanged: (rating) {
                setState(() {
                  userRating = rating;
                });
              },
              borderColor: Color.fromARGB(220, 190, 114, 74),
              color: Color.fromARGB(255, 124, 54, 16),
              size: 60.0,
            ),
          )
        ],
      ),
      actions: [
        //cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        //submit button, sends rating data to database (eventually)
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(userRating);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
