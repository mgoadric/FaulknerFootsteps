import 'dart:collection';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/dialogs/pin_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';


class MapDisplay extends StatefulWidget {
  final LatLng currentPosition;
  const MapDisplay({super.key, required this.currentPosition});

  @override
  _MapDisplayState createState() => _MapDisplayState();
}


class _MapDisplayState extends State<MapDisplay> {
  final Distance distance = new Distance();
  final Map<String, LatLng> siteLocations = {
    "Buhler Hall": LatLng(35.0991, -92.4422), //done
    "Cardon Blockhouse": LatLng(35.104633, -92.544917),//maybe done? :')
    "Church of Christ": LatLng(35.0925, -92.4378), //done
    "Conway Confederate Monument": LatLng(35.088571, -92.442956), //done
    "Faulkner County Museum": LatLng(35.0892, -92.4436), //done
    "Hendrix Bell at Altus": LatLng(35.1, -92.441025), //done
    "Simon Park": LatLng(35.089967, -92.44085), //done
  };
  late Map<String, double> siteDistances = {
    "Buhler Hall": distance.as(LengthUnit.Meter, LatLng(35.0991, -92.4422),widget.currentPosition),//done
    "Cardon Blockhouse": distance.as(LengthUnit.Meter, LatLng(35.104633, -92.544917),widget.currentPosition),//maybe done? :')
    "Church of Christ": distance.as(LengthUnit.Meter, LatLng(35.0925, -92.4378),widget.currentPosition), //done
    "Conway Confederate Monument": distance.as(LengthUnit.Meter, LatLng(35.088571, -92.442956),widget.currentPosition), //done
    "Faulkner County Museum": distance.as(LengthUnit.Meter,  LatLng(35.0892, -92.4436),widget.currentPosition), //done
    "Hendrix Bell at Altus": distance.as(LengthUnit.Meter, LatLng(35.1, -92.441025),widget.currentPosition), //done
    "Simon Park": distance.as(LengthUnit.Meter,LatLng(35.089967, -92.44085),widget.currentPosition), //done
  };
  late var sorted = Map.fromEntries(siteDistances.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
  late var sortedlist = sorted.values.toList();
 @override
    void initState() {
    super.initState();
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
              icon: const Icon(Icons.location_pin, color: Color.fromARGB(255, 255, 70, 57), size: 30),
              onPressed: () {
                // Show PinDialog when a pin is clicked
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PinDialog(
                      siteName: entry.key,
                      appState: appState,
                    );
                  },
                );
              },
            ),
          );
        }).toList();
          return Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 107, 79, 79),
            title: Text(
              "Faulkner County Map",
              style: GoogleFonts.ultra(
                textStyle:
                    const TextStyle(color: Color.fromARGB(255, 255, 243, 228)),
              ),
            ),
          ),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: widget.currentPosition,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),
      );},
      );
  }
}

