import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets.dart';

class ListItem extends StatelessWidget {
  ListItem({required this.siteInfo});
  HistSite siteInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(97, 216, 150, 89),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                siteInfo.name,
                style: GoogleFonts.ultra(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 124, 54, 16))),
              ),
              const SizedBox(width: 4, height: 10),
              Text(
                siteInfo.description,
                style: GoogleFonts.rakkas(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 175, 92, 48))),
              ),
              IconButton(
                  onPressed: () {
                    AppRouter.navigateTo(context, "/hist",
                        arguments: {"info": siteInfo});
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined))
            ],
          )),
    );
  }
}
