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
      HistSite newSite = HistSite(name: "A smaller church", description: "This is a slightly smaller church",blurbs: [InfoText(title: "Historical Significance", value: "This smaller church informs us about the flimsy state of our humanity. Our existence as beings seems so large to ourselves, however we are ultimately worthless within the multiverse.", date: "10/2/34"), InfoText(title: "This is a second blurb because I need one", value: "GibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirishGibbirish")], images: []);
      widget.app_state.addSite(newSite);
    });
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