import 'package:delhimetro/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/content.dart';

class Stations extends StatelessWidget {
  static const routeName = '/stations';
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Content>(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(color: Colors.black12),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              child: Container(
                color: Colors.black87,
                width: w,
                height: h * 0.43,
              ),
            ),
            Positioned(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  height: h,
                  width: w * 0.3,
                  child: ListView.builder(
                      itemCount: prov.Y.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                                onTap: () {
                                  prov.point == 0
                                      ? prov.start = prov.Y[i]
                                      : prov.end = prov.Y[i];
                                  Navigator.of(context)
                                      .pushReplacementNamed(Home.routename);
                                },
                                title: Text(
                                  prov.Y[i],
                                  textAlign: TextAlign.center,
                                )));
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  height: h,
                  width: w * 0.3,
                  child: ListView.builder(
                      itemCount: prov.M.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                                onTap: () {
                                  prov.point == 0
                                      ? prov.start = prov.M[i]
                                      : prov.end = prov.M[i];
                                  Navigator.of(context)
                                      .pushReplacementNamed(Home.routename);
                                },
                                title: Text(
                                  prov.M[i],
                                  textAlign: TextAlign.center,
                                )));
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  height: h,
                  width: w * 0.3,
                  child: ListView.builder(
                      itemCount: prov.B.length,
                      itemBuilder: (ctx, i) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                                onTap: () {
                                  prov.point == 0
                                      ? prov.start = prov.B[i]
                                      : prov.end = prov.B[i];
                                  Navigator.of(context)
                                      .pushReplacementNamed(Home.routename);
                                },
                                title: Text(
                                  prov.B[i],
                                  textAlign: TextAlign.center,
                                )));
                      }),
                ),
              ],
            ))
          ],
          overflow: Overflow.visible,
        ),
      ),
    );
  }
}
