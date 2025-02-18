import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:faulkner_footsteps/pages/hist_site_page.dart';
import 'package:flutter/material.dart';

class PinDialog extends StatelessWidget {
  final String siteName;
  final ApplicationState appState;

  const PinDialog({
    super.key,
    required this.siteName,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    // Search and find the historical site by name
    HistSite? selectedSite = appState.historicalSites.firstWhere(
      (site) => site.name == siteName,
      // if not found, it will say the following
      orElse: () => HistSite(
        name: siteName,
        description: "No description available",
        blurbs: [],
        images: [],
        imageUrls: [],
        lat: 0,
        lng: 0,
        avgRating: 0.0,
        ratingAmount: 0,
      ),
    );

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 247, 222, 231),
      title: Text(selectedSite.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(selectedSite.description),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate User to the HistSitePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistSitePage(
                    histSite: selectedSite,
                    app_state: appState,
                  ),
                ),
              );
            },
            child: const Text(
              "More Info",
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 2, 26, 77),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
