import 'dart:async';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'appbarlogo.dart';
import 'dashboard.dart';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)

void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'CarDashboard';

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
  String _currentAddress;
  @override
  void initState() {
    _getCurrentLocation();
    // Timer.periodic(Duration(seconds: 1), (timer) async {
    //   await _getCurrentLocation();
    // });

    Pushy.listen();

    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);

    // Register the user for push notifications
    pushyRegister();
    super.initState();
    /* new Future.delayed(
        const Duration(milliseconds: 500),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            ));*/
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
        endDrawer: Container(
            width: 250,
            child: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 23.0,
                    child: DrawerHeader(
                        child: Text('', style: TextStyle(color: Colors.white)),
                        //decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0)),
                  ),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.home),
                            ),
                          ),
                          TextSpan(text: 'Dashboard'),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.settings),
                            ),
                          ),
                          TextSpan(text: 'Settings'),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )),
        appBar: BaseAppBarLogo(
          title: Text('Dashboard'),
          appBar: AppBar(),
          widgets: <Widget>[Icon(Icons.more_vert)],
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Container(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/spotify.png'),
                            iconSize: 50, // MediaQuery.of(context).size.width
                            onPressed: () {
                              DeviceApps.openApp('com.spotify.music');
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Spotify',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/waze.png'),
                            iconSize: 50,
                            onPressed: () {
                              DeviceApps.openApp('com.waze');
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Waze',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/google-maps.png'),
                            iconSize: 50,
                            onPressed: () async {
                              DeviceApps.openApp(
                                  'com.google.android.apps.maps');
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Google Maps',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/youtube.png'),
                            iconSize: 50,
                            onPressed: () {
                              DeviceApps.openApp('com.google.android.youtube');
                            },
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Youtube',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/whatsapp.png'),
                            iconSize: 50,
                            onPressed: () {
                              DeviceApps.openApp('com.whatsapp');
                            },
                          ),
                          SizedBox(height: 25),
                          Text(
                            'WhatsApp',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset('images/chrome.png'),
                            iconSize: 50,
                            onPressed: () {
                              DeviceApps.openApp('com.android.chrome');
                            },
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Chrome',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            )));
  }

  _getAddressFromLatLng(Position _currentPosition) async {
    try {
      //   List<Placemark> p = await placemarkFromCoordinates(
      //     _currentPosition.latitude, _currentPosition.longitude);

      //Placemark place = p[0];

      setState(() {
        //  _currentAddress =
        //    "${place.locality}, ${place.postalCode}, ${place.country}";
        //BaseAppBarLogo.city = _currentAddress;
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('HH:mm:ss');
        String formatted = formatter.format(now);

        var speed = ((_currentPosition.speed) * (60 * 60) / 1000).toInt();

        BaseAppBarLogo.city =
            "Speed: " + speed.toString() + " km/h" " - " + formatted;
        /* +
            _currentAddress +
            " - " +
            formatted;*/
        //  print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      await _getAddressFromLatLng(position);
      //   print(position == null
      //       ? 'Unknown'
      //       : position.latitude.toString() +
      //           ', ' +
      //           position.longitude.toString());
    });

    //print(position.speed);
  }
}
