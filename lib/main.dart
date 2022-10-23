// import 'package:english_app/check.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map data = {
    'data': [
      {'question': 'name (plural) ?', 'answer': 'plurals'},
      {'question': 'name (plura) ?', 'answer': 'pluras'},
      {'question': 'name (plur) ?', 'answer': 'plurs'}
    ]
  };
  TextEditingController controller = TextEditingController(text: '');
  bool correct = false;
  int idx = 0;
  bool change = false;
  List<Widget> Checklist = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text(data['data'][idx]['question']),
            Card(
              child: TextField(
                controller: controller,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      String text = controller.text;
                      correct = text == data['data'][idx]['answer'];
                      Checklist.add(Card(
                        child: Text("${data['data'][idx]['answer']}: $correct"),
                      ));
                      idx = idx <= data['data'].length ? idx + 1 : 0;
                      // idx++;
                      controller.text = '';
                    });
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            correct ? Text('good') : Text(''),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Test(
                        checklist: Checklist,
                      ),
                    ));
              },
              child: Text('next'),
            )
          ],
        ),
      ),
    );
  }
}

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
