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

enum Attending { yes, no, unknown }

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
      if (user != null) {
        _loggedIn = true;
        _siteSubscription = FirebaseFirestore.instance
            .collection('sites')
            .snapshots()
            .listen((snapshot) {
          _historicalSites = [];
          for (final document in snapshot.docs) {
              var blurbs = document.data()["blurbs"];
              print("Blurbs : ${blurbs}");
              _historicalSites.add(
                HistSite(
                  name: document.data()["name"] as String,
                  blurbs: [],
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
    if(!_loggedIn) {
      throw Exception("Must be logged in");
    }
    int blurbcount = newSite.blurbs.length;
    int imageCount = newSite.images.length;
    var data = {
      "name" : newSite.name,
      "blurbCount" : blurbcount,
      "imageCount" : imageCount
    };
    FirebaseFirestore.instance
          .collection("sites")
          .doc(newSite.name)
          .set(data);
    if(blurbcount > 0) {
      for (var blurb in newSite.blurbs) {
              FirebaseFirestore.instance
        .collection("sites")
        .doc(newSite.name)
        .collection("blurbs")
        .doc()
        .set(
          {
            "title" : blurb.title,
            "value" : blurb.value,
            "time" : blurb.date == null ? blurb.date : 0
          }
        );
      }
    }

  }
}