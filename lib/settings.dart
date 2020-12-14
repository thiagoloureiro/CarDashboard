import 'dart:developer';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apps.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Settings> {
  var appsList = new List<Apps>();
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
                    title: Text("Installed Apps"),
                    actions: [
                      /*  Text("Weather: Rain, +2°",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),*/
                      IconButton(
                          iconSize: 30.0,
                          icon: Icon(Icons.save
                              //  color: Colors.black,
                              ),
                          onPressed: () {
                            _save();
                          })
                    ]),
                body: ListView(
                  children: List.generate(appsList.length, (index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          appsList[index].selected = !appsList[index].selected;
                          log(appsList[index].selected.toString());
                        });
                      },
                      selected: appsList[index].selected,
                      leading: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: CircleAvatar(
                              radius: 44.0,
                              backgroundImage:
                                  MemoryImage(appsList[index].icon),
                              backgroundColor: Colors.white,
                            ),

                            //Image.asset('images/spotify.png'),
                            onPressed: () {},
                            //iconSize: 50, // MediaQuery.of(context).size.width
                          ),
                        ),
                      ),
                      title: Text(appsList[index].appName),
                      //    subtitle: Text(appsList.[index].category.toString()),
                      // Text(paints[index].title),

                      trailing: (appsList[index].selected)
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                    );
                  }),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<List<Application>> getApps() async {
    // appsList.clear();
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: false,
        onlyAppsWithLaunchIntent: true);
    apps.sort((a, b) => a.toString().compareTo(b.toString()));

    var selectedApps = await _read();

    if (appsList.isEmpty)
      for (var app in apps) {
        if (app is ApplicationWithIcon)
          appsList.add(new Apps(1, app.appName, app.icon, app.packageName));
      }

    for (var selectedApp in selectedApps) {
      for (var app in appsList) {
        if (app.appName == selectedApp) app.selected = true;
      }
    }

/*
    for (var app in apps) {
      if (app is ApplicationWithIcon) {
        if (selectedApps.contains(app.appName)) {
          var appToAdd = new Apps(1, app.appName, app.icon, app.packageName);
          appToAdd.selected = true;
          appsList.add(appToAdd);
        } else {
          var appToAdd = new Apps(1, app.appName, app.icon, app.packageName);
          appToAdd.selected = false;
          appsList.add(appToAdd);
        }
      }
    }*/
    // print(apps.length);
    return apps;
  }

  Future<List<String>> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'app_list';
    final value = prefs.getStringList(key) ?? "";
    return value;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'app_list';

    var selectedApps = new List<String>();

    for (var app in appsList) {
      if (app.selected) selectedApps.add(app.appName);
    }

    prefs.setStringList(key, selectedApps);
  }
}
