import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//List of top 5 rated sites
class RatingLeaderBoard extends StatelessWidget {
  const RatingLeaderBoard({super.key, required this.topHistSites});

  final List<HistSite> topHistSites;

  @override
  Widget build(BuildContext context) {
    //sort out which are top sites here later, will eventually be in descending order
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 180, 130),
        title: Text(
          "Top Rated Historical Sites",
          style: GoogleFonts.sancreek(
              textStyle:
                  const TextStyle(color: Color.fromARGB(255, 124, 54, 16))),
        ),
      ),
      body: ListView.builder(
        itemCount: topHistSites.length,
        itemBuilder: (context, index) {
          HistSite site = topHistSites[index];
          return ListTile(
            //displays icon next to info
            leading: const Icon(
              Icons.location_city_outlined,
              color: Color.fromARGB(255, 124, 54, 16),
            ),
            title: Text(site.name),
            //insert rating here (eventually)
            subtitle: const Text('Rating: '),
          );
        },
      ),
    );
  }
}
