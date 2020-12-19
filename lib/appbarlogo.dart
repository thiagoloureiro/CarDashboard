import 'package:flutter/material.dart';

class BaseAppBarLogo extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;
  static String city = "CarDashboard";

  /// you can add more fields that meet your needs

  BaseAppBarLogo({Key key, this.title, this.appBar, this.widgets, city})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(city,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
        automaticallyImplyLeading: false,
        actions: [
          /*  Text("Weather: Rain, +2°",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),*/

          Builder(
              builder: (context) => IconButton(
                    iconSize: 36.0,
                    icon: Icon(
                      Icons.menu,
                      //      color: Colors.black,
                    ),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  )),
        ]);
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
