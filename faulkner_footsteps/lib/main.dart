import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/hist_site.dart';
import 'package:faulkner_footsteps/pages/hist_site_page.dart';
import 'package:faulkner_footsteps/info_text.dart';
import 'package:faulkner_footsteps/ratingDialog.dart';
import 'package:faulkner_footsteps/widgets.dart';
import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'firebase_options.dart';
// IMPORT RELATED TO MAP
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  
  // RELATED WITH MAP
  // // Require Hybrid Composition mode on Android.
  // final GoogleMapsFlutterPlatform mapsImplementation =
  //     GoogleMapsFlutterPlatform.instance;
  // if (mapsImplementation is GoogleMapsFlutterAndroid) {
  //   // Force Hybrid Composition mode.
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
  // // ···

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*
  //Test for ratingLeaderBoard
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Historical Sites Leaderboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 119, 52, 16)),
        useMaterial3: true,
      ),
      home: RatingLeaderBoard(topHistSites: _createTempData()),
    );
  }

  //temp testing historical sites data
  List<HistSite> _createTempData() {
    return [
      HistSite(
        name: 'Historical Museum',
        blurbs: [InfoText(title: 'Location', value: 'Museum, Conway')],
        images: [AssetImage('museum image')],
      ),
      HistSite(
        name: 'Memorial',
        blurbs: [InfoText(title: 'Location', value: 'Memorial, Conway')],
        images: [AssetImage('memorial image')],
      ),
      HistSite(
        name: 'Historical Marker',
        blurbs: [InfoText(title: 'Location', value: 'Marker, Conway')],
        images: [AssetImage('marker image')],
      ),
      HistSite(
        name: 'Cemetary',
        blurbs: [InfoText(title: 'Location', value: 'Cemetary, Conway')],
        images: [AssetImage('cemetary image')],
      ),
      HistSite(
        name: 'Church',
        blurbs: [InfoText(title: 'Location', value: 'Church, Conway')],
        images: [AssetImage('church image')],
      ),
    ];
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faulkner Footsteps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRouter.loginPage,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApplicationState app_state = ApplicationState();
  List<HistSite> historical_sites = [];
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      FirebaseFirestore.instance
        .collection('rooms')
        .doc('mainroom')
        .collection('players');
      HistSite newSite = HistSite(name: "The Big Church", description: "This is a large church",blurbs: [InfoText(title: "Historical Significance", value: "The big church is a large church with a long history of doing stuff and things beyond the current eternity of existence.", date: "10/2/34"), InfoText(title: "Secondary Elist", value: "This does not have a date but we still exist beyond the current state of human understanding and everything is something to another ellos")], images: []);
      app_state.addSite(newSite);
      print(historical_sites);
    });
  }

  //launches Rating Dialog
  Future<void> showRatingDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) => const RatingDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample HistSite object
    HistSite sampleSite = HistSite(
      name: "Sample Site",
      description: "A simple same site for debugging.",
      blurbs: [
        InfoText(title: "Introduction", value: "This is a sample historical site.", date: "01/01/2024"),
        InfoText(title: "Significance", value: "It played a major role in local history."),
      ],
      images: [
          // const AssetImage('assets/images/AutobotLogo.png'),
          // const AssetImage('assets/images/AutobotLogo2.png'),
          // const AssetImage('assets/images/AutobotLogo.png'),
          ], // Add images if available
    );
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
            onPressed: () {
              // Navigate to HistSitePage with sampleSite
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistSitePage(histSite: sampleSite),
                ),
              );
            },
            child: const Text("View Sample Site"),
          ),
            const SizedBox(height: 20),
            // Button for launching rating dialog
            ElevatedButton(
              onPressed: showRatingDialog,
              child: const Text("Rate this spot"),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: app_state.historicalSites.length,
                itemBuilder: (BuildContext context, int index) {
                  print("${app_state.historicalSites.length} eldritch");
                  HistSite site = app_state.historicalSites[index];
                  return TextBlurb(
                    site.name, 
                    site.blurbs.toString(), 
                    "",
                  );
                }
              )
            )
          ],
        ),
      ),
    );
  }
}
