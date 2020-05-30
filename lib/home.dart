import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'package:progress_dialog/progress_dialog.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

  const String URI = "http://192.168.1.1:8080/";

class _MyHomePageState extends State<MyHomePage> {
  
  String response;
  var body;

  @override
  void initState() {
    super.initState();
    response= "No respose yet";
    body = "y01,y05,0945";
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal, 
      isDismissible: false, 
      showLogs: true);
      pr.style(
        message: 'Please wait...',
        borderRadius: 8.0,
        backgroundColor: const Color(0x80000000),
        progressWidget: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red[800]),
          backgroundColor: Colors.white,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600)
  );
    
    return Scaffold(
      body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Starting Station : Huda City Center"),
            Text("Ending Station : Guru Dronacharya"),
            Text("Time : 09:45"),
            RaisedButton(
              onPressed: () async{
                print("Button Clicked");
                getConnection(context,pr);
              },
              child: Text("Book Ticket"),
              ),
          ], 
          ),
      ),
      );
  }
  Future getConnection(context,pr)async{
    String s;

    // Show please wait dialog
    pr.show();

    Socket.connect("192.168.1.102", 8080).then((socket) {
    print('Connected to: '
      '${socket.remoteAddress.address}:${socket.remotePort}');
    print("body data:\n"+body.toString()+"\n");
    //Send the request
    socket.write(body);

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      s = utf8.decode(data);
      print("Response:\n"+s.toString());
      pr.hide();
      // Close Please wait dialog
      showResult(context,s);
    },
    onDone: () {
      print("Done");
      socket.destroy();
    });
  
    });
  }

//  Future showResult(context, result) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Response"),
//           content: result=="yes" ? Text("Ticket Booked"):Text("Ticket unavailable"),
//         );
//       },
//     );
//   }
  Future showResult(BuildContext context,String result) {
    var alert = AlertDialog(
                  title: result=="yes" ? Text("Ticket Booked"):Text("Ticket unavailable"),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                          child: Text("Okay",style: TextStyle(color: Colors.blue),),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
      
                );
  return showDialog(context: context, builder: (BuildContext context) => alert);
  }
}