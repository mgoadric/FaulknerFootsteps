import 'package:flutter/material.dart';

import 'info_text.dart';

class HistSite {
  HistSite({
    required this.name,
    required this.blurbs,
    required this.description,
    required this.images,
    required this.avgRating,
    required this.ratingAmount,
  });

  String divider = "{ListDiv}";
  String name;
  String description;
  List<InfoText> blurbs;
  List<AssetImage> images;
  double avgRating;
  int ratingAmount;

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
}
