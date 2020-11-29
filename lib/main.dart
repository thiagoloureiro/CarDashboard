import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() {
  runApp(new MaterialApp(
    themeMode: ThemeMode.system, // Change it as you want
    theme: ThemeData(
        primaryColor: Colors.white,
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        canvasColor: Colors.white,
        // next line is important!
        appBarTheme: AppBarTheme(brightness: Brightness.light)),
    darkTheme: ThemeData(
        //   primaryColor: Colors.black,
        primaryColorBrightness: Brightness.dark,
        //   primaryColorLight: Colors.black,
        brightness: Brightness.dark,
        //   primaryColorDark: Colors.black,
        //   indicatorColor: Colors.white,
        //   canvasColor: Colors.black,
        // next line is important!
        appBarTheme: AppBarTheme(brightness: Brightness.dark)),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(milliseconds: 500),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors,
      body: Container(
          child: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'images/apps.png',
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                width: 170.0,
              ),
            ]),
      )),
    );
  }
}
