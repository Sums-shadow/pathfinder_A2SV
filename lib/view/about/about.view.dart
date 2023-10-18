import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("About PathFinder", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
            const Divider(),
            const Text("PathFinder is an app that helps visually impaired people to navigate through the world. It uses object detection to detect objects in the environment and then uses text to speech to tell the user what is in front of them. It also uses a camera to detect the user's surroundings and then uses text to speech to tell the user what is in front of them. It also uses a camera to detect the user's surroundings and then uses text to speech to tell the user what is in front of them."),
            const Divider(),
            const Text("Some useful command"),
            const Divider(),
            const Text("Some command you can use in pathfinder:"),
            const Text("1. what's in front of me"),
            const Text("2. what's write"),
            const Text("3. Hello: voice assistant will tell you what he detect"),
            const Divider(),
            const Text("Thanks to"),
            Image.asset("assets/a2sv.jpeg"),
            Lottie.asset("assets/africa.json", width: 130)
          ],
        ),
      ),
    );
  }
}