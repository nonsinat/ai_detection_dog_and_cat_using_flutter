import 'dart:async';

import 'package:detection_dog_and_cat_using_flutter/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 12),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                child: Lottie.asset("assets/gifts/dog.json"),
              ),
              Expanded(
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.bottomCenter,
                  child: Lottie.asset("assets/gifts/timer.json"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
