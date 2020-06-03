import 'package:delhimetro/TicketConfirmed.dart';
import 'package:delhimetro/content.dart';
import 'package:delhimetro/global.dart';
import 'package:delhimetro/model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';

class ConfirmationPage extends StatefulWidget {
  final String start;
  final String end;
  ConfirmationPage({Key key,this.start,this.end}) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

const String HOST = "192.168.1.105";
const int PORT = 8080;

class _ConfirmationPageState extends State<ConfirmationPage> {

  String response;
  var body;
  TicketDetails model;
  @override
  void initState() {
    super.initState();
    response = "No respose yet";
    body = "";
    model = new TicketDetails();
  }

  @override
  Widget build(BuildContext context) {

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
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
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));


    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[

              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height,
                  color: Color(0xFF283992),
                  child: Container(
                  margin: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        IconButton(
                          icon: Icon(Icons.arrow_back,color: Colors.white,), 
                          onPressed: (){
                            Navigator.pop(context);
                          }),

                        Expanded(
                          child: Text("From: \n\n${widget.start}",style:selectedTimeText)
                        ),

                        // Icon(Icons.train,color:Colors.white,size:28.0),

                        Expanded(
                          child: Text("To: \n\n${widget.end}",style: selectedTimeText,)
                        ),
                    ],),
                  ),
                ),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: _buildBottomCard(context,pr)
                ),
            ],
          ),
        ),
      ),
      );
  }
    Widget _buildBottomCard(context,pr){
    return Container(
                padding: EdgeInsets.only(left: 20, bottom: 20, right: 20, top: 20),
                margin: EdgeInsets.only(top: 100),
                constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height - 100),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), 
                    topRight: Radius.circular(30)
                  ),
                ),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 80.0),
                      child: Text("Book Tickets", style: textTitle)),
                    
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.only(top:16.0),
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2.7,
                          mainAxisSpacing: 14.0,
                          crossAxisSpacing: 14.0,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: Content().slots.length,
                          itemBuilder: (context,index){
                            return builldSlotTile(Content().slots[index].toString(),context,pr);
                          },
                          ),
                    ),
                  ],
                )
              );
  }
  Widget builldSlotTile(String time,BuildContext context, pr){
    return Container(
      margin: EdgeInsets.only(left:5.0,right:5.0),
      child: RaisedButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          
                borderRadius: BorderRadius.circular(8.0),
              ),
        child: Text(time,style: unselectedTimeText ),
        color: Colors.green,
        onPressed: () async{
          await getConnection(context,pr,time);
        }),
    );
  }

  
  Future getConnection(context,pr,t) async {
    String s;

    // Show please wait dialog
    pr.show();

    String startCode;
    (Content().mapAllStations[widget.start] is List) ? startCode = Content().mapAllStations[widget.start][0] : startCode = Content().mapAllStations[widget.start];
    String endCode;
    (Content().mapAllStations[widget.end] is List) ? endCode = Content().mapAllStations[widget.end][0] : endCode = Content().mapAllStations[widget.end];
    String time = t;
    String body = "$startCode,$endCode,$time";

/*Enter your pi address and port*/

    Socket.connect("192.168.1.105", 8080).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      print("body data:\n" + body.toString() + "\n");
      //Send the request
      socket.write(body);
      //Establish the onData, and onDone callbacks
      socket.listen((data) {
        s = utf8.decode(data);
        print("Response:\n" + s.toString());
        pr.hide();
        // Close Please wait dialog
        showResult(context, s,time);
      }, onDone: () {
        print("Done");
        socket.destroy();
      });
    });
  }


  Future showResult(BuildContext context, String result,String t) {


    // result = "yes,y13,m01";
    // result = "yes,y13";
    // result = "yes";

    var array = result.split(',');

    // result.codeUnits.map((e){
    //   return new String.fromCharCode(e);
    // }).toList();

    int responseInt = array.length;

    print("ResultList: \n"+array.toString());

    print("\nVAlid: \n"+array[0]);

    if(responseInt == 1){

      model = new TicketDetails(
        valid: array[0],
        start: widget.start,
        end: widget.end,
        intermediate1: null,
        intermediate2: null,
        time: t,
      );

    }else if(responseInt == 2){
      
      model = new TicketDetails(
        valid: array[0],
        start: widget.start,
        end: widget.end,
        intermediate1: array[1],
        intermediate2: null,
        time: t,
      );
      

    }else if(responseInt == 3){
      model = new TicketDetails(
        valid: array[0],
        start: widget.start,
        end: widget.end,
        intermediate1: array[1],
        intermediate2: array[2],
        time: t,
      );
    }

      // print("Valid or not\n"+model.valid.toString());

    var alert = AlertDialog(
      title:
          model.valid == "yes" ? Text("Ticket Booked") : Text("Ticket unavailable"),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                model.valid == "yes" ? Navigator.push(context, new MaterialPageRoute(builder: (_) => new TicketConfirmed(ticket : model,))) : 
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      ],
    );
    return showDialog(context: context, builder: (context) => alert);
  }


}