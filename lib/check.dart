import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  List<Widget> checklist;
   Results({required this.checklist,super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      body:ListView.separated(itemBuilder: (context, index) {
            return checklist[index];
          }, separatorBuilder: (context, index) => Divider(), itemCount:checklist.length ),
        
      
    );
  }
}