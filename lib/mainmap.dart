import 'dart:async';
import 'dart:developer';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'SplitWidget.dart';
import 'apps.dart';

void main() => runApp(MainMap());

class MainMap extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainMap> {
  var appsList = new List<Apps>();
  @override
  void initState() {
    getApps();

    _read();
  }

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  double padValue = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
        future: getApps(),
        builder: (context, AsyncSnapshot<List<Application>> snapshot) {
          if (snapshot.hasData) {
            //appsList.clear();
            if (appsList.isEmpty)
              for (var app in snapshot.data) {
                if (app is ApplicationWithIcon) {
                  // appsList.add(new Apps(1, app.appName, app.icon, app.packageName));
                }
              }

            //return Text(snapshot.data);
            return MaterialApp(
              themeMode: ThemeMode.system,
              theme: ThemeData(
                  //  primaryColor: Colors.white,
                  //primaryColorBrightness: Brightness.light,
                  //brightness: Brightness.light,
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
              home: Scaffold(
                appBar: AppBar(
                    leading: IconButton(
                      iconSize: 30.0,
                      icon: Icon(
                        Icons.arrow_back,
                        //  color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text("Dashboard"),
                    actions: [
                      /*  Text("Weather: Rain, +2°",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),*/
                    ]),
                body: Container(
                  child: SplitWidget(
                    childFirst: GridView.builder(
                        itemCount: appsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, position) {
                          return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                  child: Column(children: [
                                Center(
                                  child: IconButton(
                                    icon: Image.memory(appsList[position].icon),
                                    iconSize:
                                        MediaQuery.of(context).size.width / 15,
                                    onPressed: () async {
                                      DeviceApps.openApp(
                                          appsList[position].appPackage);
                                    },
                                  ),
                                ),
                              ])));
                        }),
                    childSecond: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _webView(final String url) => WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );

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

    final appNames = appsList.map((e) => e.appName).toSet();
    appsList.retainWhere((x) => appNames.remove(x.appName));

    return apps;
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
}
