import 'dart:async';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:faulkner_footsteps/pages/map_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:faulkner_footsteps/list_item.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  ApplicationState app_state = ApplicationState();

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  void _incrementCounter() {
    setState(() {
      //HistSite newSite = HistSite(name: "Example piece 3", description: "This is an example piece for this presentation we are making. This is a description of the universe within our feeble mortal minds.",blurbs: [InfoText(title: "This is a tittle for this section of the thing", value: "This is a short description blurb.", date: "The dates can be any string for the sake of flexibility."), InfoText(title: "This is a very long section to show possibilities", value: "GibbirishGibbirishGibbirishGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbiririshGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirish")], images: []);
      //widget.app_state.addSite(newSite);
    });
  }

  void _update(Timer timer) {
    setState(() {});
  }

  Future<void> showRatingDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) => const RatingDialog(),
    );
  }

  late Timer updateTimer;
  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(const Duration(milliseconds: 500), _update);
    setState(() {});
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) { // Index 1 for the "Map" tab so Index 2 -> for another...
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapDisplay(
            image: AssetImage('assets/images/FaulknerCounty.png'),
          ),
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
        SizedBox(
          height: 500,
          child: ListView.builder(
            itemCount: widget.app_state.historicalSites.length,
            itemBuilder: (BuildContext context, int index) {
              HistSite site = widget.app_state.historicalSites[index];
              return ListItem(siteInfo: site);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Display page for hist sites" : "Map Display",
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(color: Color.fromARGB(255, 124, 54, 16)),
          ),
        ),
      ),
      body: _selectedIndex == 0 
          ? _buildHomeContent() 
          : const MapDisplay(
              image: AssetImage('assets/images/FaulknerCounty.png'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}