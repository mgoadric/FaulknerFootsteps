import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class ListItem extends StatelessWidget{
  ListItem({required this.siteInfo});
  HistSite siteInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(siteInfo.name),
      title: Text(siteInfo.description)
    );
  }
}