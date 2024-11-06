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
      HistSite newSite = HistSite(name: "The Big Church", description: "This is a large church",blurbs: [InfoText(title: "Historical Significance", value: "The big church is a large church with a long history of doing stuff and things beyond the current eternity of existence.", date: "10/2/34"), InfoText(title: "Secondary Elist", value: "This does not have a date but we still exist beyond the current state of human understanding and everything is something to another ellos")], images: []);
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