import 'dart:async';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/pages/achievement.dart';
import 'package:faulkner_footsteps/dialogs/rating_Dialog.dart';
import 'package:faulkner_footsteps/pages/map_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faulkner_footsteps/list_item.dart';
import 'package:faulkner_footsteps/dialogs/create_site_dialogue.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  ApplicationState app_state = ApplicationState();

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void _update(Timer timer) {
    setState(() {});
  }

  // Future<void> showRatingDialog() async {
  //   await showDialog<double>(
  //     context: context,
  //     builder: (BuildContext context) => RatingDialog(widget.app_state, ),
  //   );
  // }

  late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(const Duration(milliseconds: 500), _update);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapDisplay(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    updateTimer.cancel();
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.app_state.historicalSites.length,
            itemBuilder: (BuildContext context, int index) {
              HistSite site = widget.app_state.historicalSites[index];
              return ListItem(app_state: widget.app_state, siteInfo: site);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 214, 196),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 52, 52),
        elevation: 5.0,
        title: Text(
          _selectedIndex == 0
              ? "Faulkner Footsteps"
              : _selectedIndex == 1
                  ? "Map"
                  : "Achievements",
          style: GoogleFonts.ultra(
            textStyle:
                const TextStyle(color: Color.fromARGB(255, 255, 243, 228)),
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : _selectedIndex == 1
              ? const MapDisplay()
              : const AchievementsPage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 107, 79, 79),
        selectedItemColor: const Color.fromARGB(255, 238, 214, 196),
        unselectedItemColor: const Color.fromARGB(200, 238, 214, 196),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),

      // Uncomment to add sites
      /*
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return SiteDialogue(siteAdded: widget.app_state.addSite);
            });
      }),
      */
    );
  }
}
