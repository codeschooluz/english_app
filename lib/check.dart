import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  List<Widget> checklist;
  Test({required this.checklist, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: checklist,
    ));
  }
}
