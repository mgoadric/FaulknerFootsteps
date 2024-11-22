 // https://stackoverflow.com/questions/63869555/shadows-in-a-rounded-rectangle-in-flutter
 // -> To add a shadow effect for the listItem, mapDisplay, rating... etc
import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItem extends StatelessWidget {
  ListItem({super.key, required this.siteInfo, required this.app_state});
  final HistSite siteInfo;
  final ApplicationState app_state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          border: Border.all(
            color: const Color.fromARGB(255, 153, 125, 98),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(3, 4), // Shadow offset
            ),
          ],
        ),
        child: Card(
          color: const Color.fromARGB(96, 235, 180, 127),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  siteInfo.name,
                  style: GoogleFonts.ultra(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 124, 54, 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  siteInfo.description,
                  style: GoogleFonts.rakkas(
                    textStyle: const TextStyle(
                      color: Color.fromARGB(255, 175, 92, 48),
                      fontSize: 17,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      AppRouter.navigateTo(context, "/hist",
                          arguments: {"info": siteInfo, "app_state": app_state});
                    },
                    icon: const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Color.fromARGB(255, 76, 32, 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

