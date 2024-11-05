import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'info_text.dart';
import 'hist_site.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _siteSubscription;

  List<HistSite> _historicalSites = [];
    List<HistSite> get historicalSites => _historicalSites;


  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (true) { //user == null, changed for debugging
        _loggedIn = true;
        _siteSubscription = FirebaseFirestore.instance
            .collection('sites')
            .snapshots()
            .listen((snapshot) {
          _historicalSites = [];
          for (final document in snapshot.docs) {
              var blurbCont = document.data()["blurbs"];
              List<String> blurbStrings = blurbCont.split(",");
              List<InfoText> newBlurbs = [];
              for (var blurb in blurbStrings) {
                List<String> values = blurb.split(".");
                newBlurbs.add(InfoText(title: values[0], value: values[1], date: values[2]));
              }
              _historicalSites.add(
                HistSite(
                  name: document.data()["name"] as String,
                  blurbs: newBlurbs,
                  images: []
                )
              );
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _historicalSites = [];
        _siteSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  void addSite(HistSite newSite) { //using the variable to contain information for sake of readability. May refactor later
    // if(!_loggedIn) { UNCOMMENT THIS LATER. COMMENTED OUT FOR TESTING PURPOSES
    //   throw Exception("Must be logged in");
    // }

    var data = {
      "name" : newSite.name,
      "blurbs" : newSite.listifyBlurbs(),
      "images" : "testValue"
    };

    print('Adding site with $data');
    FirebaseFirestore.instance
      .collection("sites")
      .doc(newSite.name)
      .set(data);
          
  }
}