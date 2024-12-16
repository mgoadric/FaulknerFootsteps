import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faulkner_footsteps/app_router.dart';
import 'package:audioplayers/audioplayers.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    
    // plays audio when starting the app
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSourceAsset('audio/GuitarStrumFF.mp3');
      await player.resume();

      Future.delayed(Duration(seconds: 3), () {
        fadeOutAudio();
      });
    });
  }

  // Handles the fade out of the Guitar strum
  void fadeOutAudio() {
  const steps = 20;
  const stepDuration = Duration(milliseconds: 100);
  double volume = 1.0;

  Timer.periodic(stepDuration, (timer) {
    volume -= 1 / steps;
    if (volume <= 0) {
      player.stop();
      timer.cancel();
    } else {
      player.setVolume(volume);
    }
  });
}



  void _handleContinue() async {
  player.stop(); // Stop the audio
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    AppRouter.navigateTo(context, AppRouter.list);
  } else {
    AppRouter.navigateTo(context, AppRouter.loginPage);
  }
}


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
    opacity: _animation,
    child: AnimatedContainer(
      duration: Duration(seconds: 5),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 12,
          colors: [
          Color.fromARGB(255, 72, 52, 52),
          Color.fromARGB(255, 184, 141, 106),
          ]
        )
      ),
    
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(175.0),
                  child: Image.asset(
                    'assets/images/FFSplash.png',
                    width: 350, // Adjust the size as needed
                    height: 350,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _handleContinue,
                child: const Text('Continue'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  // Adjust button size as needed
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleContinue,
                child: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ],
          ),
        ),
      )
    )
  );
}
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}


