import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/hist_site.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.siteInfo});
  final HistSite siteInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Card(
        color: const Color.fromARGB(255, 255, 243, 228), // Card background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
                    // Clickable indicator
                    const Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 107, 79, 79), // Icon color
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
