
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:faulkner_footsteps/objects/info_text.dart';
import 'package:flutter/material.dart';

typedef siteAddedCallback = Function(HistSite newSite);

class SiteDialogue extends StatefulWidget{
  const SiteDialogue({
    super.key,
    required this.siteAdded
  });

  final siteAddedCallback siteAdded;

  @override
  State<StatefulWidget> createState() => _siteDialogueState();
}

class _siteDialogueState extends State<SiteDialogue> {

  final TextEditingController nameInput = TextEditingController();

  String nameText = "";

    final TextEditingController descInput = TextEditingController();

  String descText = "";

  int blurbCount = 0;
  List<TextEditingController> blurbTitleControllers = [];
  List<String> blurbTitles = [];
  List<TextEditingController> blurbTextControllers = [];
  List<String> blurbVals = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adding an Army'),
      content: Column(
          children: [
          TextField(
            onChanged: (value) { 
              setState(() {
                nameText = value;
              });
            },
            controller: nameInput,
            decoration: const InputDecoration(hintText: "New Site Name"),
          ),
          TextField(
            onChanged: (value) {
              setState((){
                descText = value;
              });
            },
            controller: descInput,
            decoration: const InputDecoration(hintText: "New Site Description"),
          ),
          for(int i = 0; i < blurbCount; i++)
            Column(children: [
              TextField(
                controller: blurbTitleControllers[i],
                onChanged: (value) {
                  blurbTitles[i] = value;
                },
              ),
              TextField(
                controller: blurbTextControllers[i],
                onChanged: (value) {
                  blurbVals[i] = value;
                },
              )
            ],),
            FloatingActionButton(onPressed: () {
              setState(() {
                blurbCount += 1;
                blurbTitleControllers.add(TextEditingController());
                blurbTitles.add("");
                blurbTextControllers.add(TextEditingController());
                blurbVals.add("");
              });
            })
          ]
      ),
      actions: <Widget>[
        ElevatedButton(
          key: const Key("CancelButton"),
          //style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),

        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameInput,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              //style: yesStyle,
              onPressed: (descInput.text.isNotEmpty && nameInput.text.isNotEmpty)
                  ? () {
                      setState(() {
                        List<InfoText> newBlurbs = [];
                        for(int i = 0; i < blurbCount; i++) {
                          newBlurbs.add(InfoText(title: blurbTitles[i], value: blurbVals[i]));
                        }
                        List<String> newImages = [];
                        HistSite newSite = HistSite(name: nameText, blurbs: newBlurbs, description: descText, images: [], ratingAmount: 0, avgRating: 0.0);
                        widget.siteAdded(newSite);
                        Navigator.pop(context);
                      });
                    }
                  : null,
              child: const Text('Ok'),
            );
          },
        ),
      ],
    );
  }
}