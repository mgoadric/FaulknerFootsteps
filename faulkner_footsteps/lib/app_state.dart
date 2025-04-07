import 'dart:async';
import 'dart:typed_data';
import 'package:faulkner_footsteps/dialogs/filter_Dialog.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:faulkner_footsteps/objects/info_text.dart';
import 'package:faulkner_footsteps/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _siteSubscription;
  Set<String> _visitedPlaces = {};
  Set<String> get visitedPlaces => _visitedPlaces;

  List<HistSite> _historicalSites = [];
  List<HistSite> get historicalSites => _historicalSites;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;

        // Check if user is admin and update status
        await checkAdminStatus(user);

        // Load achievements when user logs in
        await loadAchievements();

        _siteSubscription = FirebaseFirestore.instance
            .collection('sites')
            .snapshots()
            .listen((snapshot) async {
          _historicalSites = [];
          for (final document in snapshot.docs) {
            var blurbCont = document.data()["blurbs"];
            List<String> blurbStrings = blurbCont.split("{ListDiv}");
            List<InfoText> newBlurbs = [];
            for (var blurb in blurbStrings) {
              List<String> values = blurb.split("{IFDIV}");
              newBlurbs.add(InfoText(
                  title: values[0], value: values[1], date: values[2]));
            }
            //convert firebase filters to siteFilters
            //TODO: ensure that all sitefilters have a if statement here

            List<siteFilter> filters = [];
            // print("reached!");
            for (String filter
                in List<String>.from(document.data()["filters"])) {
              // print("Filter: $filter");
              if (filter.toLowerCase() == "monument")
                filters.add(siteFilter.Monument);
              else if (filter.toLowerCase() == "park") {
                filters.add(siteFilter.Park);
              } else if (filter.toLowerCase() == "hall") {
                filters.add(siteFilter.Hall);
              } else if (filter.toLowerCase() == "other") {
                filters.add(siteFilter.Other);
              } else {
                print(
                    "Filter not found in siteFilter enum list. Filter: $filter");
              }
            }
            HistSite site = HistSite(
              name: document.data()["name"] as String,
              description: document.data()["description"] as String,
              blurbs: newBlurbs,
              imageUrls: List<String>.from(document.data()["images"]),
              lat: document.data()["lat"] as double,
              lng: document.data()["lng"] as double,
              filters: filters,
              //added ratings
              //set as 0.0 for testing, will have to change later to have consistent ratings
              avgRating: document.data()["avgRating"] != null
                  ? (document.data()["avgRating"] as num).toDouble()
                  : 0.0,
              ratingAmount: document.data()["ratingCount"] != null
                  ? document.data()["ratingCount"] as int
                  : 0,
            );
            _historicalSites.add(site);
            loadImageToHistSite(document, site);
          }
          //print(historicalSites);
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _historicalSites = [];
        _visitedPlaces = {};
        _siteSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  // Check if user is an admin and update the static flag
  Future<void> checkAdminStatus(User user) async {
    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      // Store the admin status in the LoginPage static variable
      LoginPage.isAdmin = adminDoc.exists;
      notifyListeners();
    } catch (e) {
      // If permission denied error occurs, handle it gracefully
      print('Error checking admin status: $e');

      // Set to false by default when permission error occurs
      LoginPage.isAdmin = false;
      notifyListeners();
    }
  }

  final storageRef = FirebaseStorage.instance.ref();

  Future<Uint8List?> getImage(String s) async {
    final imageRef = storageRef.child("$s");
    Uint8List? data;
    try {
      const oneMegabyte = 1024 * 1024 * 1000000;
      data = await imageRef.getData(oneMegabyte).timeout(Duration(minutes: 2));
      // Data for "images/island.jpg" is returned, use this as needed.
    } catch (e) {
      // Handle any errors.
      print(("ERROR!!! This occured when calling getImage(). Error: $e"));
      print("Error is for $s");
    } finally {}
    return data;
  }

  Future<List<Uint8List?>> getImageList(List<String> lst) async {
    List<Uint8List?> rList = [];
    for (String s in lst) {
      Uint8List? item = await getImage(s);
      rList.add(item);
    }
    return rList;
  }

  // load all the images to the hist site
  Future<void> loadImageToHistSite(
      QueryDocumentSnapshot<Map<String, dynamic>> document,
      HistSite site) async {
    List<Uint8List?> imgList =
        await getImageList(List<String>.from(document.data()["images"]));
    site.images = imgList;
  }

  void addSite(HistSite newSite) {
    //using the variable to contain information for sake of readability. May refactor later
    // if(!_loggedIn) { UNCOMMENT THIS LATER. COMMENTED OUT FOR TESTING PURPOSES
    //   throw Exception("Must be logged in");
    // }

    // we need to convert all the filters to strings so they are firestore friendly
    List<String> firebaseFriendlyFilterList = [];

    for (siteFilter filter in newSite.filters) {
      if (filter == siteFilter.Hall) {
        firebaseFriendlyFilterList.add("Hall");
      } else if (filter == siteFilter.Monument) {
        firebaseFriendlyFilterList.add("Monument");
      } else if (filter == siteFilter.Park) {
        firebaseFriendlyFilterList.add("Park");
      } else if (filter == siteFilter.Other) {
        firebaseFriendlyFilterList.add("Other");
      }
      //TODO: add all other filter types as they are added...
    }

    var data = {
      "name": newSite.name,
      "description": newSite.description,
      "blurbs": newSite.listifyBlurbs(),
      "images": newSite.imageUrls,
      //added ratings here
      "avgRating": newSite.avgRating,
      "ratingCount": newSite.ratingAmount,
      "filters": firebaseFriendlyFilterList,
      "lat": 35.1,
      "lng": -92.1,
    };

    print('Adding site with $data');
    FirebaseFirestore.instance.collection("sites").doc(newSite.name).set(data);
    FirebaseFirestore.instance
        .collection("sites")
        .doc(newSite.name)
        .collection("ratings");
  }

  Future<double> getUserRating(String siteName) async {
    if (!_loggedIn) return 0.0;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return 0.0;

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection("sites")
          .doc(siteName)
          .collection("ratings")
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return docSnapshot.get("rating");
        } else {
          return 0.0;
        }
      } else {
        return 0.0;
      }
    } catch (e) {
      print("error");
      return 0.0;
    }
  }

  //update/store rating in firebase
  void updateSiteRating(String siteName, double newRating) async {
    try {
      final site = _historicalSites.firstWhere((s) => s.name == siteName);
      final userId = FirebaseAuth.instance.currentUser!.uid;
      double totalRating = 0;
      int ratingcount = 0;

      // 1. Add the individual rating to the ratings subcollection
      // This should work for all authenticated users based on your current rules
      await FirebaseFirestore.instance
          .collection("sites")
          .doc(siteName)
          .collection("ratings")
          .doc(userId)
          .set({"rating": newRating});

      // 2. Fetch all ratings to calculate the average
      final snapshot = await FirebaseFirestore.instance
          .collection("sites")
          .doc(siteName)
          .collection("ratings")
          .get();

      for (final doc in snapshot.docs) {
        totalRating += doc.data()["rating"];
        ratingcount += 1;
      }

      double finalRating = totalRating / ratingcount;

      // 3. Update the local HistSite object with the new rating data
      // This ensures the UI displays the updated rating even if Firebase update fails
      site.avgRating = finalRating;
      site.ratingAmount = ratingcount;

      // 4. Try to update the site document with the new average
      // This will work for admins but might fail for regular users
      try {
        await FirebaseFirestore.instance
            .collection("sites")
            .doc(siteName)
            .update({"avgRating": finalRating, "ratingCount": ratingcount});
      } catch (e) {
        print(
            "Could not update site with new rating average (user may not have permission): $e");
        // We don't need to handle this error further since we've already updated the local object
      }

      notifyListeners();
    } catch (e) {
      print("Error updating site rating: $e");
    }
  }

  // Achievement Management Methods
  Future<void> loadAchievements() async {
    if (!_loggedIn) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('places')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['visited'] != null) {
          _visitedPlaces = Set<String>.from(data['visited'] as List);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading achievements: $e');
    }
  }

  Future<void> saveAchievement(String place) async {
    if (!_loggedIn) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      _visitedPlaces.add(place);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc('places')
          .set({
        'visited': _visitedPlaces.toList(),
      });

      notifyListeners();
    } catch (e) {
      print('Error saving achievement: $e');
    }
  }

  bool hasVisited(String place) {
    return _visitedPlaces.contains(place);
  }

  Map<String, LatLng> getLocations() {
    int i = 0;
    Map<String, LatLng> sites = {};
    while (i < historicalSites.length) {
      sites[historicalSites[i].name] =
          LatLng(historicalSites[i].lat, historicalSites[i].lng);
      i++;
    }
    return sites;
  }
}
