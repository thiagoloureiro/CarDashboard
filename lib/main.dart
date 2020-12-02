import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)

void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'MyApp';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  Pushy.notify(notificationTitle, notificationText, data);

  // Clear iOS app badge number
  Pushy.clearBadge();
}

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
    Pushy.listen();

    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);

    // Register the user for push notifications
    pushyRegister();
    super.initState();
    new Future.delayed(
        const Duration(milliseconds: 500),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            ));
  }

  Future pushyRegister() async {
    try {
      // Register the user for push notifications
      String deviceToken = await Pushy.register();

      // Print token to console/logcat
      print('Device token: $deviceToken');

      // Display an alert with the device token
      /*  showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Pushy'),
                content: Text('Pushy device token: $deviceToken'),
                actions: [
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      })
                ]);
          });
*/
      // Optionally send the token to your backend server via an HTTP GET request
      // ...
    } on PlatformException catch (error) {
      // Display an alert with the error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Error'),
                content: Text(error.message),
                actions: [
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      })
                ]);
          });
    }
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
