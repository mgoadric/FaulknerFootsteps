import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';


class MapDisplay extends StatelessWidget {
  const MapDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79),
        title: const Text(
          "Conway Map",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 243, 228),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(35.0918, -92.4367),
          initialZoom: 12,
          cameraConstraint: CameraConstraint.contain(
            bounds: LatLngBounds(
              const LatLng(-90, -180),
              const LatLng(90, 180),
            ),
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
        ],
      ),
    );
  }
}
