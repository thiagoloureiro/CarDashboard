import 'package:flutter/material.dart';

class BaseAppBarLogo extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = Colors.red;
  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const BaseAppBarLogo({Key key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(actions: [
      IconButton(
        iconSize: 30.0,
        icon: Icon(
          Icons.settings,
          //  color: Colors.black,
        ),
        onPressed: () {},
      ),
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
