import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:google_fonts/google_fonts.dart';

enum siteFilter { Monument, Park }

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key, required this.displaySites});

  final List<HistSite> displaySites;
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<siteFilter> filters = [];
  double userRating = 0.0;

  @override
  Widget build(BuildContext build) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 168, 124, 124),
      title: Text(
        'Select your filters',
        style: GoogleFonts.rakkas(
            textStyle: const TextStyle(
                color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
      ),
      content: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                child: Wrap(
              children: siteFilter.values.map((siteFilter site) {
                return FilterChip(
                  label: Text(site.name),
                  selected: filters.contains(site),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        filters.add(site);
                      } else {
                        filters.remove(site);
                      }
                    });
                  },
                );
              }).toList(),
            ))
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: GoogleFonts.rakkas(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Submit",
            style: GoogleFonts.rakkas(
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 62, 50, 50), fontSize: 20.0)),
          ),
        ),
      ],
    );
  }
}
