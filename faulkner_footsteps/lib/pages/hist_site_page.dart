import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../hist_site.dart';

class HistSitePage extends StatefulWidget {
  final HistSite histSite;

  const HistSitePage({super.key, required this.histSite});

  @override
  State<StatefulWidget> createState() => _HistSitePage();
}

class _HistSitePage extends State<HistSitePage> {
  Future<void> showRatingDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) => const RatingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.histSite.name,
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
                itemCount: widget.histSite.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(image: widget.histSite.images[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Display blurbs (title, value, and date)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.histSite.blurbs.map((infoText) {
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 124, 54, 16),
          onPressed: showRatingDialog,
          child: const Icon(
            Icons.star,
            color: Color.fromARGB(198, 246, 174, 5),
          )),
    );
  }
}
