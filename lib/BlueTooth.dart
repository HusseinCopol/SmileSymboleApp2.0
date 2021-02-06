// For performing some operations asynchronously
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:share/share.dart';

import"package:path_provider/path_provider.dart";

import 'package:flutter/material.dart';

import 'package:wifi_info_flutter/wifi_info_flutter.dart';

import 'package:http/http.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController customControllerSsid = TextEditingController();
TextEditingController customController = TextEditingController();

TextEditingController customControllerCapture = TextEditingController();


String ip ;

class BlueToothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smile Symbol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {

  List<String> lst = ["test"];

  //Creat Alert Dialog
  CreatAlertDialog(BuildContext context,String ssid)
  {
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        shape:new RoundedRectangleBorder(
            side: new BorderSide(color: Colors.orange[400], width: 1.0),
            borderRadius: BorderRadius.circular(15.0)) ,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            Text(
              "ssid",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 14,color: Colors.white70),
            ),
            Text(
              "password",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 14,color: Colors.white70),
            ),


          ],
        ),

        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: TextField(

                style: new TextStyle(color: Colors.white),
                // keyboardType: TextInputType.number,
                controller:customControllerSsid ,
                decoration:new InputDecoration(
                  hintText: "Ssid",
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.white30),
                ) ,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Flexible(
              child: TextField(
                style: new TextStyle(color: Colors.white),
                // keyboardType: TextInputType.number,
                controller:customController ,
                decoration:new InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(fontSize: 15.0, color: Colors.white30),
                ) ,
              ),
            ),

          ],
        ),
        actions: <Widget>[
          MaterialButton(

            color: Colors.orange,
            elevation: 5.0,
            child: Text("send"
              ,style: TextStyle(color: Colors.white70),),
            onPressed: (){
              Navigator.of(context).pop();
              String password= customController.text.toString();
              String ssid1 = customControllerSsid.text.toString();
              ShareJson(ssid1,password,'1');




              customController.clear();


            },
          ),

        ],
      );
    });
  }







  //end
















  //Wifi Information







  @override
  void initState() {
    super.initState();

  }












  //UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Smile Symbol"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[


              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          elevation: 2,
                          child: Text("Send Json"),
                          onPressed: () async {

                            var wifiName = await WifiInfo().getWifiName();
                            print(wifiName);
                            customControllerSsid = new TextEditingController(text: wifiName);
                            CreatAlertDialog(context,wifiName);






                          },
                        ),

                        Flexible(
                          child: TextField(
                            style: new TextStyle(color: Colors.black),
                            keyboardType: TextInputType.number,
                            controller:customController ,

                          ),
                        ),
                        MaterialButton(

                          color: Colors.orange,
                          elevation: 5.0,
                          child: Text("capture"
                            ,style: TextStyle(color: Colors.white70),),
                          onPressed: (){
                            String capture=customControllerCapture.text.toString();
                            PostCommand(capture,ip);

                          },
                        ),
                        new StreamBuilder(
                            stream: Firestore.instance.collection('raspi_user').snapshots(),
                            builder: (context,snapshot){
                              if (!snapshot.hasData) return new Text("loading");
                              return new ListView.builder(itemBuilder: (context,index)
                              {
                                DocumentSnapshot ds = snapshot.data.documents[index];
                                ip=ds["system"];
                                return Text(ds["system"]);
                              }
                              );

                            }
                        ),




                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }














  //Save Json File*****************************
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/wifi_info');
  }
  Future<File> writeJson(String counter) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$counter');
  }
  //end


  // Share JSON
  void ShareJson (String ssid,String password,String user_id) async
  {

    String wifi_info = "network={\n ssid=\"$ssid\" \n psk=\"$password\"\n}";
    //end
    writeJson(wifi_info);


    var temp =await _localPath;

    // Share.share('{SSid:HusseinCopol,pasword:1234,user_id:1}');
    Share.shareFiles(['$temp/wifi_info'], text: 'Great picture');
  }


  void PostCommand(String capture,String ip) async
  {
    //for the order list

   // String url ="https://72.68.100.221/"+capture;
    String url ="https://" + ip+  "/"+capture;
    Response response =await get(url);
    setState(() {

    });



  }





}

