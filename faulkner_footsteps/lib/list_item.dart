import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class ListItem extends StatelessWidget{
  ListItem({required this.siteInfo});
  HistSite siteInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Text(siteInfo.name),
          const SizedBox(width: 4, height: 10),
          Text(siteInfo.description),
          IconButton(
            onPressed: () {
              AppRouter.navigateTo(context, AppRouter.generateRoute())
            },
            icon: const Icon(Icons.arrow_circle_right_outlined)
          )
        ],)
      ,
    );
  }
}