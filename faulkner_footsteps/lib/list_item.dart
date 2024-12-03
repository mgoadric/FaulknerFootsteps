// https://stackoverflow.com/questions/63869555/shadows-in-a-rounded-rectangle-in-flutter
// -> To add a shadow effect for the listItem, mapDisplay, rating... etc
import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';

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
        elevation: 5,
        shadowColor: const Color.fromRGBO(107, 79, 79, 0.5), // Soft shadow color
        child: InkWell(
          onTap: () {
            AppRouter.navigateTo(context, "/hist", arguments: {"info": siteInfo});
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              // Full-width thumbnail image at the top
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/placeholder.png', // Replace with your actual image path
                  height: 150, // Adjust height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Row with text and icon inline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Site name
                    Text(
                      siteInfo.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 72, 52, 52), // Text color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // add star rating icons here
                Text("Rating: ${siteInfo.avgRating.toStringAsFixed(1)}",
                    style: GoogleFonts.ultra(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 124, 54, 16),
                      ),
                    )),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
