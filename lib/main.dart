import 'dart:async';
import 'package:cardashboard/settings.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appbarlogo.dart';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'apps.dart';

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

@override
void activate() {
  print('activated');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var appsList = new List<Apps>();
  @override
  void initState() {
    getApps();

    _read();

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

      try {
        // Make sure the user is registered
        if (await Pushy.isRegistered()) {
          // Subscribe the user to a topic
          await Pushy.subscribe('cardashboard');

          // Subscribe successful
          print('Subscribed to topic successfully');
        }
      } on PlatformException catch (error) {
        // Subscribe failed, notify the user
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text('Subscribe failed'),
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
                          TextSpan(text: 'Select Apps'),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Route route =
                          MaterialPageRoute(builder: (context) => Settings());
                      Navigator.push(context, route).then(onGoBack);

                      // Navigator.push(context,
                      //   MaterialPageRoute(builder: (context) => Settings()));
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
        body: Padding(
            padding: const EdgeInsets.all(2.0),
            child: GridView.builder(
                itemCount: appsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, position) {
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Column(children: [
                        Center(
                          child: IconButton(
                            icon: Image.memory(appsList[position].icon),
                            iconSize: MediaQuery.of(context).size.width / 10,
                            onPressed: () async {
                              DeviceApps.openApp(appsList[position].appPackage);
                            },
                          ),
                        ),
                        Text(
                          appsList[position].appName,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        )
                      ])));
                })));
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

  Future<List<Application>> getApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);
    apps.sort((a, b) => a.toString().compareTo(b.toString()));

    var selectedApps = await _read();

    for (var app in apps) {
      if (app is ApplicationWithIcon) {
        if (selectedApps.contains(app.appName))
          appsList.add(new Apps(1, app.appName, app.icon, app.packageName));
      }
    }

    return apps;
  }

  Future<FutureOr> onGoBack(dynamic value) async {
    appsList.clear();
    await getApps();

    setState(() {});
  }

  Future<List<String>> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'app_list';
    var value = prefs.getStringList(key) ?? null;

    if (value == null) {
      value = ['Youtube', 'Chrome'];
    }
    return value;
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
    //  positionStream.cancel();

    //print(position.speed);
  }

  Widget buildPartsRow(Apps appsList) {
    return new Row(children: <Widget>[
      new IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            //rowMap.remove(key);
            setState(() {});
          })
    ]);
  }
}
