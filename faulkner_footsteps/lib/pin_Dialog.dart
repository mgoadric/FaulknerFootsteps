import 'package:flutter/material.dart';

class PinDialog extends StatefulWidget {
  const PinDialog({
    super.key,
  });

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  @override
  Widget build(BuildContext build) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 247, 222, 231),
      // name of site from pin
      title: Text("Site Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            //direct to hist site page
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "More Info",
              style: TextStyle(
                  fontSize: 20.0, color: Color.fromARGB(255, 2, 26, 77)),
            ),
          ),
        ],
      ),
    );
  }
}
