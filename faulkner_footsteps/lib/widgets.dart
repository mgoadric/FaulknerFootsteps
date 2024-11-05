import 'package:flutter/material.dart';

class TextBlurb extends StatelessWidget {
  const TextBlurb(this.title, this.value, this.date, {super.key});
  final String title;
  final String value;
  final String date;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Text(date),
        const SizedBox(height: 10),
        Text(value)
      ],
    );
  }
}