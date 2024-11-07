import 'package:faulkner_footsteps/app_router.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class ListItem extends StatelessWidget {
  ListItem({required this.siteInfo});
  HistSite siteInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(99, 193, 117, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(siteInfo.name),
              const SizedBox(width: 4, height: 10),
              Text(siteInfo.description),
              IconButton(
                  onPressed: () {
                    AppRouter.navigateTo(context, "/hist",
                        arguments: {"info": siteInfo});
                  },
                  icon: const Icon(Icons.arrow_circle_right_outlined))
            ],
          )),
    );
  }
}
