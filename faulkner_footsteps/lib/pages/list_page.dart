import 'dart:async';

import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/list_item.dart';

class ListPage extends StatefulWidget{
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
    setState(() {
      
    });
  }
  late Timer updateTimer;
  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(Duration(milliseconds: 500), _update);
    setState(() {
      
    });
  }

  @override
  void dispose() {
    super.dispose();
    updateTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("This is a display page for historical sites in faulkner county"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: widget.app_state.historicalSites.length,
                itemBuilder: (BuildContext context, int index) {
                  print("${widget.app_state.historicalSites.length} eldritch");
                  HistSite site = widget.app_state.historicalSites[index];
                  return ListItem(siteInfo: site);
                }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

}