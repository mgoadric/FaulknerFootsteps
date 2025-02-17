import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:faulkner_footsteps/app_state.dart';

class AchievementsPage extends StatefulWidget {

  const AchievementsPage({super.key});

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  // To track visited places
  void visitPlace(BuildContext context, String place) async {
    // If the place is visited for the first time, a popup will appear and update the state
    final appState = Provider.of<ApplicationState>(context, listen: false);

    if (!appState.hasVisited(place)) {
      await appState.saveAchievement(place);

      if (!mounted) return;

      // Show achievement popup dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          title: const Text(
            "Achievement Unlocked!",
            style: TextStyle(
              color: Color.fromARGB(255, 72, 52, 52),
            ),
          ),
          content: Text(
            "You have visited $place.",
            style: const TextStyle(
              color: Color.fromARGB(255, 72, 52, 52),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color.fromARGB(255, 72, 52, 52),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 238, 214, 196),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: appState.historicalSites.length,
              itemBuilder: (context, index) {
                final place = appState.historicalSites[index];
                final isVisited = appState.hasVisited(place.name);

                return GestureDetector(
                  onTap: () => visitPlace(context, place.name),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isVisited
                          ? Colors.green[100]
                          : const Color.fromARGB(255, 255, 243, 228),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isVisited
                            ? Colors.green
                            : const Color.fromARGB(255, 107, 79, 79),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVisited ? Icons.emoji_events : Icons.place,
                            size: 40,
                            color: isVisited
                                ? Colors.green
                                : const Color.fromARGB(255, 143, 6, 6),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            place.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 72, 52, 52),
                            ),
                          ),
                          if (isVisited)
                            const Text(
                              "Done!",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
