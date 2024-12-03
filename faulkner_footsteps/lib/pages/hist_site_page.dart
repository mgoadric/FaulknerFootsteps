import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
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

  final urls = [
    'https://live.staticflickr.com/2872/9142834823_503dee0d1c_b.jpg',
    'https://live.staticflickr.com/3861/14459662112_505397428a_z.jpg',
    'https://live.staticflickr.com/5479/14464952611_f462b97d7e_z.jpg',
    'https://live.staticflickr.com/5158/14461036375_1892f0c69b.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79),
        title: Text(
          "Back to list",
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(
                color: Color.fromARGB(255, 255, 243, 228)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 235, 215),
                borderRadius: BorderRadius.circular(12.0),),
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                    onTap: () {
                      SwipeImageGallery(
                        context: context,
                        itemBuilder: (context, galleryIndex) {
                          return Image.network(urls[galleryIndex]);
                        },
                        itemCount: urls.length,
                      ).show();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(urls[index], fit: BoxFit.cover),
                    ),
                  );
                },
              ),
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
  foregroundColor: const Color.fromARGB(255, 250, 235, 215),
  backgroundColor: const Color.fromARGB(255, 72, 52, 52),
  elevation: 6,
  shadowColor: Colors.black45,
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  ),
),
                  ),
                  const SizedBox(width: 16.0),
                  buildRatingStars(widget.histSite.avgRating),
                  const SizedBox(width: 16.0),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.histSite.blurbs.map((infoText) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  color: const Color.fromARGB(255, 250, 235, 215),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(infoText.title,
                            style: GoogleFonts.ultra(
                                textStyle: const TextStyle(
                                    color: Color.fromARGB(255, 72, 52, 52),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
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
