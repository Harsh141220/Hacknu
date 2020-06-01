import 'package:delhimetro/stations.dart';
import 'package:flutter/material.dart';
import './providers/content.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'slots.dart';

class Home extends StatelessWidget {
  static const routename = '/home';

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Content>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/METRO-ALIND-CHAUHAN.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  color: Colors.black54,
                  height: h * 0.35,
                  width: w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print('start');
                            prov.point = 0;
                            Navigator.of(context)
                                .pushReplacementNamed(Stations.routeName);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              width: w,
                              child: Text(
                                prov.start == null
                                    ? 'Select Start Station'
                                    : prov.start,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.swap_vert,
                          color: Colors.white,
                          size: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('End');
                            prov.point = 1;
                            Navigator.of(context)
                                .pushReplacementNamed(Stations.routeName);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              width: w,
                              child: Text(
                                prov.end == null
                                    ? 'Select End Station'
                                    : prov.end,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: RaisedButton(
                  hoverElevation: 20,
                  color: Colors.black87,
                  onPressed: () {
                    print('pressed');
                    if (prov.start != null && prov.end != null)
                      Navigator.of(context)
                          .pushReplacementNamed(Slots.routeName);
                    else
                      showAlertDialog(context);
                  },
                  child: Container(
                    width: w,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'SEARCH',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        Provider.of<Content>(context).start == null
            ? 'Start point not defined'
            : 'End point not defined',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
