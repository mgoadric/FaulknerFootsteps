// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faulkner_footsteps/main.dart';

import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:faulkner_footsteps/app_state.dart';

void main() {
  test('Blurbs are converted into readable strings', () async {
    HistSite testSite = HistSite(name: "TestName", description: "test description", blurbs: [InfoText(title: "Test1", value: "A value test", date: "10/6/1995"), InfoText(title: "Test2", value: "Finding another value")], images: []);
    // Build our app and trigger a frame.
    String container = testSite.listifyBlurbs();
    List<String> blurbStrings = container.split(",");
    print(blurbStrings);
    List<InfoText> blurbs = [];
    for (var blurb in blurbStrings) {
      List<String> values = blurb.split(".");
      String? Date;
      if(values[2] == "null") {
        Date = null;
      } else {
        Date = values[2];
      }
      blurbs.add(InfoText(title: values[0], value: values[1], date: "something"));
    }
    print(blurbs);
  });

  testWidgets("Testing firebase pushing and pulling historical sites", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    HistSite testSite = HistSite
      (
        name: "TestName", 
        description: "Test description",
        blurbs: 
          [
            InfoText(title: "Test1", value: "A value test", date: "10/6/1995"), 
            InfoText(title: "Test2", value: "Finding another value")
          ],
        images: []
      );
    ApplicationState appState = ApplicationState();
    Firebase.initializeApp();
    appState.addSite(testSite);
  });
}
