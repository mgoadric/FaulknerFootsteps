import 'package:flutter/material.dart';

class MapDisplay extends StatelessWidget {
  final AssetImage image;

  const MapDisplay({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map Display"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image(image: image),
        ),
      ),
    );
  }
}
