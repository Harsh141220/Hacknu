import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './providers/content.dart';
import 'server_connect.dart';

class Slots extends StatelessWidget {
  static const routeName = '/time';
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
                  height: h * 0.45,
                  padding: EdgeInsets.all(45),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            prov.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.swap_horiz,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            prov.end,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('E, d MMM')
                            .format(DateTime.now())
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: h * 0.15,
              left: w * 0.05,
              child: Container(
                height: h * 0.8,
                width: w * 0.9,
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: prov.slots.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        onTap: () {
                          prov.slot = prov.slots[i];
                          Navigator.of(context).pushNamed(MyHomePage.routeName);
                        },
                        title: Text(
                          prov.slots[i],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: w / 3,
                      childAspectRatio: 5 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                ),
              ),
            ),
          ],
          overflow: Overflow.visible,
        ),
      ),
    );
  }
}
