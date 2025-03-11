import 'dart:async';
import 'dart:io';
import 'package:faulkner_footsteps/app_state.dart';
import 'package:faulkner_footsteps/objects/hist_site.dart';
import 'package:faulkner_footsteps/objects/info_text.dart';
import 'package:faulkner_footsteps/pages/map_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminListPage extends StatefulWidget {
  AdminListPage({super.key});
  final ApplicationState app_state = ApplicationState();

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  late Timer updateTimer;
  int _selectedIndex = 0;
  File? image;

  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(const Duration(milliseconds: 500), _update);
  }

  void _update(Timer timer) {
    setState(() {});
    if (widget.app_state.historicalSites.isNotEmpty) {
      updateTimer.cancel();
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource
              .gallery); //could be camera so user can just take picture
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapDisplay(
            currentPosition: const LatLng(2, 2),
            initialPosition: const LatLng(2, 2),
            appState: widget.app_state,
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _showAddSiteDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final latController = TextEditingController(text: "0.0");
    final lngController = TextEditingController(text: "0.0");
    List<InfoText> blurbs = [];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 238, 214, 196),
              title: Text(
                'Add New Historical Site',
                style: GoogleFonts.ultra(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 76, 32, 8),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Site Name',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 32, 8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: lngController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 32, 8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 186, 130),
                      ),
                      onPressed: () async {
                        await _showAddBlurbDialog(blurbs);
                        setState(
                            () {}); // Refresh the dialog to show new blurbs
                      },
                      child: const Text('Add Blurb'),
                    ),
                    if (blurbs.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      const Text('Current Blurbs:'),
                      ...blurbs
                          .map((blurb) => ListTile(
                                title: Text(blurb.title),
                                subtitle: Text(blurb.value),
                              ))
                          .toList(),
                    ],
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 186, 130),
                      ),
                      onPressed: () async {
                        await pickImage();
                      },
                      child: const Text('Add Image'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 186, 130),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      final newSite = HistSite(
                        name: nameController.text,
                        description: descriptionController.text,
                        blurbs: blurbs,
                        images: [],
                        imageUrls: [],
                        avgRating: 0.0,
                        ratingAmount: 0,
                        filters: [],
                        lat: double.tryParse(latController.text) ?? 0.0,
                        lng: double.tryParse(lngController.text) ?? 0.0,
                      );
                      widget.app_state.addSite(newSite);
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  child: const Text('Save Site'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddBlurbDialog(List<InfoText> blurbs) async {
    final titleController = TextEditingController();
    final valueController = TextEditingController();
    final dateController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          title: Text(
            'Add Blurb',
            style: GoogleFonts.ultra(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 76, 32, 8),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
              TextField(
                controller: valueController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 218, 186, 130),
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    valueController.text.isNotEmpty) {
                  blurbs.add(InfoText(
                    title: titleController.text,
                    value: valueController.text,
                    date: dateController.text,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Blurb'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditSiteDialog(HistSite site) async {
    final nameController = TextEditingController(text: site.name);
    final descriptionController = TextEditingController(text: site.description);
    final latController = TextEditingController(text: site.lat.toString());
    final lngController = TextEditingController(text: site.lng.toString());
    List<InfoText> blurbs = List.from(site.blurbs);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 238, 214, 196),
              title: Text(
                'Edit Historical Site',
                style: GoogleFonts.ultra(
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 76, 32, 8),
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Site Name',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: latController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 32, 8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: lngController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 76, 32, 8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Blurbs:',
                      style: GoogleFonts.ultra(
                        textStyle: const TextStyle(
                          color: Color.fromARGB(255, 76, 32, 8),
                        ),
                      ),
                    ),
                    ...blurbs.asMap().entries.map((entry) {
                      int idx = entry.key;
                      InfoText blurb = entry.value;
                      return ListTile(
                        title: Text(blurb.title),
                        subtitle: Text(blurb.value),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await _showEditBlurbDialog(blurbs, idx);
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  blurbs.removeAt(idx);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 218, 186, 130),
                      ),
                      onPressed: () async {
                        await _showAddBlurbDialog(blurbs);
                        setState(() {});
                      },
                      child: const Text('Add Blurb'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 218, 186, 130),
                  ),
                  onPressed: () {
                    // Get the original site name for updating or deleting the document
                    final originalName = site.name;
                    final oldDocRef = FirebaseFirestore.instance
                        .collection('sites')
                        .doc(originalName);

                    final updatedSite = HistSite(
                      name: nameController.text,
                      description: descriptionController.text,
                      blurbs: blurbs,
                      images: [], // Using empty list since we're working with imageUrls
                      imageUrls: site.imageUrls,
                      avgRating: site.avgRating,
                      ratingAmount: site.ratingAmount,
                      filters: [],
                      lat: double.tryParse(latController.text) ?? site.lat,
                      lng: double.tryParse(lngController.text) ?? site.lng,
                    );

                    // If name changed, delete old document and create new one
                    if (originalName != nameController.text) {
                      oldDocRef.delete().then((_) {
                        widget.app_state.addSite(updatedSite);
                      });
                    } else {
                      // Just update existing document
                      widget.app_state.addSite(updatedSite);
                    }

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditBlurbDialog(List<InfoText> blurbs, int index) async {
    final titleController = TextEditingController(text: blurbs[index].title);
    final valueController = TextEditingController(text: blurbs[index].value);
    final dateController = TextEditingController(text: blurbs[index].date);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          title: Text(
            'Edit Blurb',
            style: GoogleFonts.ultra(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 76, 32, 8),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
              TextField(
                controller: valueController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 218, 186, 130),
              ),
              onPressed: () {
                blurbs[index] = InfoText(
                  title: titleController.text,
                  value: valueController.text,
                  date: dateController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdminContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 218, 186, 130),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: _showAddSiteDialog,
            child: Text(
              'Add New Historical Site',
              style: GoogleFonts.ultra(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 76, 32, 8),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.app_state.historicalSites.length,
            itemBuilder: (BuildContext context, int index) {
              final site = widget.app_state.historicalSites[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color.fromARGB(255, 238, 214, 196),
                child: ExpansionTile(
                  title: Text(
                    site.name,
                    style: GoogleFonts.ultra(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 76, 32, 8),
                      ),
                    ),
                  ),
                  subtitle: Text(site.description),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location: ${site.lat}, ${site.lng}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 76, 32, 8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rating: ${site.avgRating.toStringAsFixed(1)} (${site.ratingAmount} ratings)',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 76, 32, 8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Blurbs:',
                            style: GoogleFonts.ultra(
                              textStyle: const TextStyle(
                                color: Color.fromARGB(255, 76, 32, 8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...site.blurbs
                              .map((blurb) => ListTile(
                                    title: Text(blurb.title),
                                    subtitle: Text(blurb.value),
                                    trailing: blurb.date.isNotEmpty
                                        ? Text('Date: ${blurb.date}')
                                        : null,
                                  ))
                              .toList(),
                          ButtonBar(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Site'),
                                onPressed: () => _showEditSiteDialog(site),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete Site'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 238, 214, 196),
                                        title: Text(
                                          'Confirm Delete',
                                          style: GoogleFonts.ultra(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 76, 32, 8),
                                            ),
                                          ),
                                        ),
                                        content: Text(
                                            'Are you sure you want to delete ${site.name}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 218, 186, 130),
                                            ),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('sites')
                                                  .doc(site.name)
                                                  .delete();
                                              setState(() {
                                                widget.app_state.historicalSites
                                                    .removeWhere((s) =>
                                                        s.name == site.name);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 196, 166),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 186, 130),
        elevation: 12.0,
        shadowColor: const Color.fromARGB(135, 255, 255, 255),
        title: Text(
          _selectedIndex == 0 ? "Admin Dashboard" : "Map Display",
          style: GoogleFonts.ultra(
            textStyle: const TextStyle(color: Color.fromARGB(255, 76, 32, 8)),
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? _buildAdminContent()
          : MapDisplay(
              currentPosition: const LatLng(2, 2),
              initialPosition: const LatLng(2, 2),
              appState: widget.app_state,
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 218, 180, 130),
        selectedItemColor: const Color.fromARGB(255, 124, 54, 16),
        unselectedItemColor: const Color.fromARGB(255, 124, 54, 16),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
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

  @override
  void dispose() {
    updateTimer.cancel();
    super.dispose();
  }
}
