import 'package:flutter/material.dart';

import 'package:faulkner_footsteps/objects/info_text.dart';
import 'package:latlong2/latlong.dart';

class HistSite {
  HistSite({
    required this.name,
    required this.blurbs,
    required this.description,
    required this.imageUrls,
    required this.avgRating,
    required this.ratingAmount, required List images,
    required this.lat,
    required this.lng
  });

  String divider = "{ListDiv}";
  String name;
  String description;
  List<InfoText> blurbs;
  List<String> imageUrls;
  double avgRating;
  int ratingAmount;
  double lat;
  double lng;


  String listifyBlurbs() {
    String fin = "";
    for (var blurb in blurbs) {
      fin = '$fin$blurb$divider';
    }
    return fin.substring(0, fin.length - divider.length);
  }

  void updateRating(double newRating) {
    avgRating = ((avgRating * ratingAmount) + newRating) / (ratingAmount + 1);
    ratingAmount++;
  }
  LatLng getLocation(){
    return LatLng(lat, lng);
  }
}
