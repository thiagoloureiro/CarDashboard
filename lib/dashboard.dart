import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'appbarlogo.dart';
import 'package:device_apps/device_apps.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int get helloAlarmID => null;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
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
                                  child: Icon(Icons.search),
                                ),
                              ),
                              TextSpan(text: 'Offering'),
                            ],
                          ),
                        ),
                        onTap: () {},
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
                                  child: Icon(Icons.house_siding_rounded),
                                ),
                              ),
                              TextSpan(text: 'Industries'),
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
                                  child: Icon(Icons.wallet_giftcard),
                                ),
                              ),
                              TextSpan(text: 'Business'),
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
                                  child: Icon(Icons.access_alarm),
                                ),
                              ),
                              TextSpan(text: 'Services'),
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
                                  child: Icon(Icons.square_foot),
                                ),
                              ),
                              TextSpan(text: 'My selection'),
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
                                  child: Icon(Icons.calendar_today),
                                ),
                              ),
                              TextSpan(text: 'Events'),
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
                                  child: Icon(Icons.alarm),
                                ),
                              ),
                              TextSpan(text: 'Notifications'),
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
                                  child: Icon(Icons.settings_applications),
                                ),
                              ),
                              TextSpan(text: 'Tools'),
                            ],
                          ),
                        ),
                        onTap: () {
                          //  Navigator.push(
                          //    context,
                          // MaterialPageRoute(
                          //   builder: (context) => Settings()));
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
                                  child: Icon(Icons.qr_code),
                                ),
                              ),
                              TextSpan(text: 'Scan code'),
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
                                  child: Icon(Icons.update),
                                ),
                              ),
                              TextSpan(text: 'Update'),
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
                        onTap: () {},
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
                                  child: Icon(Icons.download_rounded),
                                ),
                              ),
                              TextSpan(text: 'Offline D. Manager'),
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
                                  child: Icon(Icons.folder_special),
                                ),
                              ),
                              TextSpan(text: 'Documentation'),
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
                                  child: Icon(Icons.search),
                                ),
                              ),
                              TextSpan(text: 'Search'),
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
                                  child: Icon(Icons.info),
                                ),
                              ),
                              TextSpan(text: 'Info'),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
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
                                onPressed: () {},
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
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high);

                                  Timer.periodic(Duration(seconds: 2), (timer) {
                                    print(DateTime.now().second);
                                  });
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
                                  DeviceApps.openApp('com.frandroid.app');
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
                                icon: Image.asset('images/youtube.png'),
                                iconSize: 100,
                                onPressed: () {
                                  DeviceApps.openApp('com.frandroid.app');
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
                                icon: Image.asset('images/youtube.png'),
                                iconSize: 100,
                                onPressed: () {
                                  DeviceApps.openApp('com.frandroid.app');
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
                      ],
                    ),
                  ]),
                ))));
  }
}
