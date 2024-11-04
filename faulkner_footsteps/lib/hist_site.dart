
import 'package:flutter/material.dart';

import 'info_text.dart';

class HistSite {
  HistSite({required this.name, required this.blurbs, required this.images});

  String name;
  List<InfoText> blurbs;
  List<AssetImage> images;
}