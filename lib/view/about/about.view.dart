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
            const Text("About the Developers"),
            const Divider(),
            const Text("This app was developed by a team of 3 students from the University of Kinshasa. The team members are:"),
            const Text("1. Ezechiel Ngbowa"),
            const Text("2. Mardochée Luviki"),
            const Text("3. Gogo Sokombe"),
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