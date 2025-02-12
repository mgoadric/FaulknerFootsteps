// https://stackoverflow.com/questions/63869555/shadows-in-a-rounded-rectangle-in-flutter
// -> To add a shadow effect for the listItem, mapDisplay, rating... etc
import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.siteInfo, required this.app_state});
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
            color: const Color.fromARGB(255, 176, 133, 133),
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
        child: InkWell(
          onTap: () {
            AppRouter.navigateTo(context, "/hist",
                arguments: {"info": siteInfo, "app_state": app_state});
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              // Full-width thumbnail image at the top
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  // 'assets/images/faulkner_thumbnail.png',
                  // 'assets/images/faulkner_thumbnail.png', <- this is for the original thumbnail the classroom group was using
                  siteInfo.imageUrls.first,
                  height:
                      400, // Adjust height as needed. 400 seems to work best with the images. This was originally at 150
                  width: double.infinity,
                  fit: BoxFit.cover,

                  //TODO: understand exactly how this works
                  // https://stackoverflow.com/questions/46629758/how-to-show-an-local-image-till-the-networkimage-loads-up-in-flutter
                  frameBuilder: (context, child, frame, _) {
                    if (frame == null) {
                      //fallback to placeholder
                      return Image.asset(
                          'assets/images/faulkner_thumbnail.png');
                    }
                    return child;
                  },
                ),
              ),
              // Row with text and icon inline
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Site name with fading overflow
                    Flexible(
                      child: Text(
                        siteInfo.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 72, 52, 52), // Text color
                        ),
                        overflow:
                            TextOverflow.fade, // Fades text when it overflows
                        softWrap:
                            false, // Prevents text from wrapping to a new line
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Add star rating icons here
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          AppRouter.navigateTo(context, "/hist", arguments: {
                            "info": siteInfo,
                            "app_state": app_state
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Color.fromARGB(255, 62, 50, 50),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
