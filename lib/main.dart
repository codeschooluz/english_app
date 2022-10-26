import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_app/check.dart';
import 'package:http/http.dart' as http;

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
  Future<Map> func()async{
    http.Response response = await http.get(Uri.parse('https://englishapi.pythonanywhere.com/'));
    Map data=jsonDecode(response.body);
    return data;
  }
  // Map data = {
  //   'data': [
  //     {'question': 'name (plural) ?', 'answer': 'plurals'},
  //     {'question': 'name (plura) ?', 'answer': 'pluras'},
  //     {'question': 'name (plur) ?', 'answer': 'plurs'}
  //   ]
  // };
  TextEditingController controller = TextEditingController(text: '');
  bool correct = false;
  int idx = 0;
  bool change = false;
  List<Widget> checklist = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: func(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!['data'][2]['question'].toString()),
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
                            correct = text == snapshot.data!['data'][2]['answer'];
                            checklist.add(Card(
                              child: Text("${snapshot.data!['data'][idx]['answer']}: $correct"),
                            ));
                             idx = idx <= snapshot.data!['data'].length ? idx + 1 : 0;
                            idx++;
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
                              checklist: checklist,
                            ),
                          ));
                    },
                    child: Text('next'),
                  )
                ],
              ),
            );}else if(snapshot.hasError){
              return Text('${snapshot.error}');
            }else{
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}
