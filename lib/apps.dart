import 'dart:typed_data';

class Apps {
  final int id;
  final String appName;
  final Uint8List icon;
  final String appPackage;
  bool selected = false;

  Apps(this.id, this.appName, this.icon, this.appPackage);
}
