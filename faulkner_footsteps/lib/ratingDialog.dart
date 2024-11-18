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
      backgroundColor: const Color.fromARGB(255, 92, 54, 40),
      title: Text(
        'Please rate your experience at this location:',
        style: GoogleFonts.sancreek(
            textStyle:
                const TextStyle(color: Color.fromARGB(255, 184, 162, 135))),
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
              borderColor: const Color.fromARGB(255, 184, 162, 135),
              color: const Color.fromARGB(255, 184, 162, 135),
              size: 50.0,
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
          child: Text(
            "Cancel",
            style: GoogleFonts.rakkas(
                textStyle: TextStyle(
                    color: Color.fromARGB(255, 184, 162, 135), fontSize: 20.0)),
          ),
        ),
        //submit button, will send rating data to database (eventually)
        TextButton(
          onPressed: () {
            //updateRating(userRating)
            Navigator.of(context).pop(userRating);
          },
          child: Text(
            "Submit",
            style: GoogleFonts.rakkas(
                textStyle: TextStyle(
                    color: Color.fromARGB(255, 184, 162, 135), fontSize: 20.0)),
          ),
        ),
      ],
    );
  }
}
