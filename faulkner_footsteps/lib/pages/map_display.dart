import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapDisplay extends StatelessWidget {
  final AssetImage image;

  const MapDisplay({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 180, 130),
        title: Text(
          "Map Display",
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 12.0, right: 12.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  border: Border.all(
                    color: const Color.fromARGB(255, 153, 125, 98),
                    width: 4.0, 
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Image(image: image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Additional Information/ or List of the Categories?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

