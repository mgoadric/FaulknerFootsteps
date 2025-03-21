import 'dart:collection';
import 'dart:convert';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/dialogs/pin_Dialog.dart';
import 'package:faulkner_footsteps/pages/achievement.dart';
import 'package:faulkner_footsteps/pages/hist_site_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:provider/provider.dart';

class MapDisplay extends StatefulWidget {
  final LatLng currentPosition;
  final ApplicationState appState;
  const MapDisplay(
      {super.key,
      required this.currentPosition,
      required this.appState,
      required LatLng initialPosition});

  @override
  _MapDisplayState createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  bool visited = false;
  final Distance distance = new Distance();
  late Map<String, LatLng> siteLocations = widget.appState.getLocations();
  late Map<String, double> siteDistances = getDistances(siteLocations);
  late var sorted = Map.fromEntries(siteDistances.entries.toList()
    ..sort((e1, e2) => e1.value.compareTo(e2.value)));
  late var sortedlist = sorted.values.toList();
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => locationDialog(context));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void locationDialog(context) {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    HistSite? selectedSite = widget.appState.historicalSites.firstWhere(
      (site) => site.name == sorted.keys.first.toString(),
      // if not found, it will say the following
      orElse: () => HistSite(
        name: sorted.keys.first,
        description: "No description available",
        blurbs: [],
        imageUrls: [],
        filters: [],
        lat: 0,
        lng: 0,
        avgRating: 0.0,
        ratingAmount: 0,
      ),
    );

    if ((sorted.values.first < 30000.0) &
        (!widget.appState.hasVisited(sorted.keys.first))) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              backgroundColor: const Color.fromARGB(
                  255, 238, 214, 196), // Cream color to match app theme
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: Color.fromARGB(255, 107, 79, 79),
                  width: 2.0,
                ),
              ),
              title: Text(
                sorted.keys.first,
                style: GoogleFonts.ultra(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 72, 52, 52),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "You are near this historical site!",
                    style: GoogleFonts.rakkas(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 107, 79, 79),
                        fontSize: 16,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (selectedSite.imageUrls.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: MemoryImage(
                            base64Decode(selectedSite.imageUrls.first)),
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRoundedButton(
                        context: context,
                        text: "Get Info",
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate User to the HistSitePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistSitePage(
                                histSite: selectedSite,
                                app_state: widget.appState,
                                currentPosition: widget.currentPosition,
                              ),
                            ),
                          );
                        },
                      ),
                      _buildRoundedButton(
                        context: context,
                        text: "Mark as visited",
                        onPressed: () {
                          Navigator.of(context).pop();
                          var AchievementState = AchievementsPageState();
                          // Navigate User to the HistSitePage
                          AchievementState.visitPlace(
                              context, sorted.keys.first);
                          visited = true;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRoundedButton(
                    context: context,
                    text: "Close",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // Helper method to create consistent rounded buttons
  Widget _buildRoundedButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 107, 79, 79),
        side: BorderSide(
          color: Color.fromARGB(255, 107, 79, 79),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        text,
        style: GoogleFonts.rakkas(
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 107, 79, 79),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        // Red colored pins for each historical site
        List<Marker> markers = siteLocations.entries.map((entry) {
          return Marker(
            point: entry.value,
            child: IconButton(
              icon: const Icon(Icons.location_pin,
                  color: Color.fromARGB(255, 255, 70, 57), size: 30),
              onPressed: () {
                // Show PinDialog when a pin is clicked
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PinDialog(
                      siteName: entry.key,
                      appState: appState,
                      currentPosition: widget.currentPosition,
                    );
                  },
                );
              },
            ),
          );
        }).toList();
        markers.add(Marker(
            point: widget.currentPosition,
            child: Icon(
              Icons.circle,
              color: Colors.blue,
            )));
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: widget.currentPosition,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, double> getDistances(Map<String, LatLng> locations) {
    Map<String, double> distances = {};
    for (int i = 0; i < locations.length; i++) {
      distances[locations.keys.elementAt(i)] = distance.as(LengthUnit.Meter,
          locations.values.elementAt(i), widget.currentPosition);
    }
    return distances;
  }
}
