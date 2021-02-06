

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';




class MainPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {





    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPageState(),
    );
  }
}



///////////////////////////////////////////


class MainPageState extends StatefulWidget {

  @override
  _MainPageStateState createState() => _MainPageStateState();
}

class _MainPageStateState extends State<MainPageState> {
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState()  {
    // TODO: implement initState

    super.initState();




    //print(d);

  }



  @override
  Widget build(BuildContext context) {
    return

      Scaffold(

        backgroundColor: Colors.transparent,

        appBar: AppBar(
          title: Text("Smile Symbol"),
        ),

        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RaisedButton(
                child: Text('View Record'),
                onPressed: () {
                  getData();
                },
              )

            ],

          ),
        ),


      );



  }
  void getData(){
    print("SSS");
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
    print("SSS");
  }


}





