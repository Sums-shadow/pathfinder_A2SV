import 'package:flutter/material.dart';


class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text("How to Use PathFinder"),
          Divider(),
          
        ],
      ),
    );
  }
}