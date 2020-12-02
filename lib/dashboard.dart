import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'appbarlogo.dart';
import 'package:device_apps/device_apps.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String appBarTitle = "Title1";
  String _currentAddress;
  int get helloAlarmID => null;
  @override
  Future<void> initState() {
    super.initState();
    _getCurrentLocation();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //  return new Future(() => false);
        },
        child: Scaffold(
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
                            child:
                                Text('', style: TextStyle(color: Colors.white)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                                iconSize: 100,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('images/waze.png'),
                                iconSize: 100,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('images/google-maps.png'),
                                iconSize: 100,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('images/youtube.png'),
                                iconSize: 100,
                                onPressed: () {
                                  DeviceApps.openApp(
                                      'com.google.android.youtube');
                                },
                              ),
                              SizedBox(height: 25),
                              Text(
                                'Youtube',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('images/whatsapp.png'),
                                iconSize: 100,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Image.asset('images/chrome.png'),
                                iconSize: 100,
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
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ))));
  }

  _getAddressFromLatLng(Position _currentPosition) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        //BaseAppBarLogo.city = _currentAddress;
        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
        String formatted = formatter.format(now);
        var speed = ((_currentPosition.speed) * (60 * 60) / 1000).toInt();

        BaseAppBarLogo.city = "Speed: " +
            speed.toString() +
            " km/h - " +
            _currentAddress +
            " - " +
            formatted;
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.speed);
    await _getAddressFromLatLng(position);
  }
}
