import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'check.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<Map> func() async {
  http.Response response =
      await http.get(Uri.parse('https://englishapi.pythonanywhere.com/'));
  Map data = jsonDecode(response.body);
  return data;
}

TextEditingController task = TextEditingController();
int index = 0;
int birnima = 0;
bool checker = false;
List<Widget> checklist = [];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('English questions'),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: FutureBuilder(
          future: func(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          snapshot.data!['data'][index]['question'].toString(),
                          style: GoogleFonts.alice(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder()),
                          //maxLines: 6,
                          style: TextStyle(fontSize: 21),
                          controller: task,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                            onLongPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Results(checklist: checklist),
                                  ));
                            },
                            onPressed: () {
                              print(snapshot);
                              setState(() {
                                checker = snapshot.data!['data'][index]
                                            ['answer']
                                        .toString() ==
                                    task.text;
                                checklist.add(Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    tileColor: checker
                                        ? Color.fromARGB(234, 205, 231, 190)
                                        : Color.fromARGB(255, 230, 190, 190),
                                    trailing: checker ? Text('✅') : Text('❌'),
                                    title: Text(
                                        "${snapshot.data!['data'][index]['question']}",
                                        style: TextStyle(
                                          fontSize: 18
                                        ),
                                        ),
                                    //isThreeLine: true,
                                    subtitle: checker
                                        ? Text(
                                            'Correct ',
                                            style:
                                                GoogleFonts.offside(color: Colors.green,fontWeight: FontWeight.w600,fontSize: 15),
                                          )
                                        : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Your answer: ${task.text}'),
                                              
                                                   RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(text: 'Correct answer:',style: GoogleFonts.offside(color: Color.fromARGB(255, 185, 66, 36),fontWeight: FontWeight.w600,fontSize: 15)),
                                                      TextSpan(text: ' ${snapshot.data!['data'][index]['answer']}',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 14))
                                                    ]
                                                   ))
                                            ],
                                          ),
                                  ),
                                ));
                                index++;
                                if (index == snapshot.data!['data'].length) {
                                  index = 0;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Results(checklist: checklist),
                                      ));
                                }
                                task.text = '';
                              });
                            },
                            child: Text(
                              'Check',
                              style: TextStyle(fontSize: 30),
                            )),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
