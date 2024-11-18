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
    final double? userRating = await showDialog<double>(
      context: context,
      builder: (BuildContext context) => const RatingDialog(),
    );
    if (userRating != null) {
      setState(() {
        widget.histSite.updateRating(userRating);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 192, 158),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 162, 135),
        title: Text(
          widget.histSite.name,
          style: GoogleFonts.ultra(
              textStyle:
                  const TextStyle(color: Color.fromARGB(255, 49, 29, 21))),
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
                      child: Image(
                          image: AssetImage(
                              'assets/images/placeholder.png')) //PLACEHOLDER IMAGE
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

            const SizedBox(height: 8.0),
            // Display average rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  "Average Rating: ${widget.histSite.avgRating.toStringAsFixed(1)} (${widget.histSite.ratingAmount} ratings)",
                  style: GoogleFonts.ultra(
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 49, 29, 21),
                          fontSize: 12.0)),
                ),
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
                                    color: Color.fromARGB(255, 49, 29, 21)))),
                        Text(infoText.value,
                            style: GoogleFonts.rakkas(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 92, 54, 40)))),
                        if (infoText.date != "")
                          Text(
                            "Date: ${infoText.date}",
                            style: GoogleFonts.acme(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 49, 29, 21))),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10.0,
              offset: const Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 49, 29, 21),
          onPressed: showRatingDialog,
          child: const Icon(
            Icons.star,
            color: Color.fromARGB(255, 218, 180, 130),
            size: 30,
          ),
        ),
      ),
    );
  }
}
