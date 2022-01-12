import 'dart:async';
import 'package:a_reader/screens/get_started_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.black;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.greenAccent);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashDelay = 4;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => GetStartedPage()));
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.deepOrange,
                                backgroundImage: AssetImage('assets/images/Icon-76.png'),
                                radius: 80.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Spacer(),
                                Spacer(
                                  flex: 6,
                                ),
                                Text('',
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),),
                                Spacer(),
                              ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}