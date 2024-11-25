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

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor(); // Full stars
    bool halfStar = (rating - fullStars) >= 0.5; // Check if it's a half star

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 24);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 24);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 24);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79), 
        title: Text(
          "Back to list",
          style: GoogleFonts.ultra(
              textStyle: const TextStyle(color: Color.fromARGB(255, 255, 243, 228))),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the site name as the main header at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), 
              child: Text(
                widget.histSite.name,
                style: GoogleFonts.ultra(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 72, 52, 52), 
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Display images in a horizontal list
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                          image: AssetImage(
                              'assets/images/placeholder.png')) // PLACEHOLDER IMAGE
                      );
                },
              ),
            ),

            const SizedBox(height: 16.0), 

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  ElevatedButton.icon(
                    onPressed: showRatingDialog,
                    icon: const Icon(Icons.star, color: Color.fromARGB(255, 255, 243, 228), size: 24),
                    label: const Text("Rate This Site"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 72, 52, 52),
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16.0),

                  buildRatingStars(widget.histSite.avgRating),

                  const SizedBox(width: 16.0),
                  // Display the average rating
                  Text(
                    "${widget.histSite.avgRating.toStringAsFixed(1)} / 5",
                    style: GoogleFonts.rakkas(
                      textStyle: const TextStyle(
                          color: Color.fromARGB(255, 72, 52, 52), fontSize: 16),
                    ),
                  ),

              
                ],
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
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(infoText.title,
                            style: GoogleFonts.ultra(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 72, 52, 52), fontSize: 16, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 6),
                        Text(infoText.value,
                            style: GoogleFonts.rakkas(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 107, 79, 79), fontSize: 14))),
                        if (infoText.date != "")
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Date: ${infoText.date}",
                              style: GoogleFonts.acme(
                                  textStyle: const TextStyle(
                                      color: Color.fromARGB(255, 72, 52, 52), fontSize: 12)),
                            ),
                          ),
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
