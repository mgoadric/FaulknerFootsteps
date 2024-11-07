import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../hist_site.dart';
import '../info_text.dart';

class HistSitePage extends StatelessWidget {
  final HistSite histSite;

  HistSitePage({Key? key, required this.histSite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          histSite.name,
          style: GoogleFonts.ultra(
              textStyle:
                  const TextStyle(color: Color.fromARGB(255, 124, 54, 16))),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display images in a horizontal list
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(image: AssetImage('assets/images/placeholder.png')),  //PLACEHOLDER IMAGE
                  );
                },
              ),
              // child: ListView.builder(
              //   scrollDirection: Axis.horizontal,
              //   itemCount: histSite.images.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Image(image: histSite.images[index]),
              //     );
              //   },
              // ),
            ),
            SizedBox(height: 16.0),
            // Display blurbs (title, value, and date)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: histSite.blurbs.map((infoText) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(infoText.title,
                            style: GoogleFonts.ultra(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 124, 54, 16)))),
                        Text(infoText.value,
                            style: GoogleFonts.rakkas(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 175, 92, 48)))),
                        if (infoText.date != "")
                          Text(
                            "Date: ${infoText.date}",
                            style: GoogleFonts.acme(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 124, 54, 16))),
                          ),
                        const Padding(padding: EdgeInsets.only(bottom: 25.0)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
