import 'dart:developer';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Settings());

class Settings extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Settings> {
  double padValue = 0;

  List<Paint> paints = <Paint>[
    Paint(1, 'Red', Colors.red),
    Paint(2, 'Blue', Colors.blue),
    Paint(3, 'Green', Colors.green),
    Paint(4, 'Lime', Colors.lime),
    Paint(5, 'Indigo', Colors.indigo),
    Paint(6, 'Yellow', Colors.yellow)
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
        future: getApps(),
        builder: (context, AsyncSnapshot<List<Application>> snapshot) {
          if (snapshot.hasData) {
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
                            _save(['test', 'test']);
                          })
                    ]),
                body: ListView(
                  children: List.generate(paints.length, (index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          paints[index].selected = !paints[index].selected;
                          log(paints[index].selected.toString());
                        });
                      },
                      selected: paints[index].selected,
                      leading: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {},
                        child: Container(
                          width: 48,
                          height: 48,
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: snapshot.data[index] is ApplicationWithIcon
                                ? CircleAvatar(
                                    radius: 44.0,
                                    backgroundImage: MemoryImage((snapshot
                                            .data[index] as ApplicationWithIcon)
                                        .icon),
                                    backgroundColor: Colors.white,
                                  )
                                : null,
                            //Image.asset('images/spotify.png'),
                            onPressed: () {},
                            //iconSize: 50, // MediaQuery.of(context).size.width
                          ),
                        ),
                      ),
                      title: Text(snapshot.data[index].appName),
                      subtitle: Text(snapshot.data[index].category.toString()),
                      // Text(paints[index].title),

                      trailing: (paints[index].selected)
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
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: false,
        onlyAppsWithLaunchIntent: true);
    apps.sort((a, b) => a.toString().compareTo(b.toString()));

    return apps;
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'app_list';
    final value = prefs.getStringList(key) ?? "";
    print('read: $value');
  }

  _save(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'app_list';
    final value = ['spotify', 'waze', 'maps'];
    list = value;
    prefs.setStringList(key, value);
    print('saved $value');
  }
}

class Paint {
  final int id;
  final String title;
  final Color colorpicture;
  bool selected = false;

  Paint(this.id, this.title, this.colorpicture);
}
