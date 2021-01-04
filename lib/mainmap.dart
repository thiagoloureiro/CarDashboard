import 'dart:async';
import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'SplitWidget.dart';
import 'apps.dart';
import 'widgets/sized_icon_button.dart';
import 'package:logger/logger.dart';

void main() => runApp(MainMap());

class MainMap extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainMap> {
  final Logger _logger = Logger();
  bool _loading = false;
  bool _connected = false;
  String status = "test";
  var appsList = <Apps>[];
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    getApps();
    getAuthenticationToken();
    connectToSpotifyRemote();
    _read();
    _getCurrentLocation();
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
              home: StreamBuilder<ConnectionStatus>(
                stream: SpotifySdk.subscribeConnectionStatus(),
                builder: (context, snapshot1) {
                  _connected = true;
                  if (snapshot1.data != null) {
                    _connected = snapshot1.data.connected;
                  }
                  return Scaffold(
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
                          childFirst: ListView(
                              // Important: Remove any padding from the ListView.
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                SizedBox(
                                  height: 210,
                                  child: GridView.builder(
                                      itemCount: appsList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemBuilder: (context, position) {
                                        return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Column(children: [
                                                Center(
                                                  child: IconButton(
                                                    icon: Image.memory(
                                                        appsList[position]
                                                            .icon),
                                                    iconSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            15,
                                                    onPressed: () async {
                                                      DeviceApps.openApp(
                                                          appsList[position]
                                                              .appPackage);
                                                    },
                                                  ),
                                                ),
                                              ]),
                                            ));
                                      }),
                                ),
                                Text('Current Song:',
                                    style: TextStyle(fontSize: 16)),
                                _connected
                                    ? playerStateWidget()
                                    : const Center(
                                        child: Text('Not connected'),
                                      ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      SizedIconButton(
                                        width: 50,
                                        icon: Icons.skip_previous,
                                        onPressed: skipPrevious,
                                      ),
                                      SizedIconButton(
                                        width: 50,
                                        icon: Icons.play_arrow,
                                        onPressed: resume,
                                      ),
                                      SizedIconButton(
                                        width: 50,
                                        icon: Icons.pause,
                                        onPressed: pause,
                                      ),
                                      SizedIconButton(
                                        width: 50,
                                        icon: Icons.skip_next,
                                        onPressed: skipNext,
                                      ),
                                    ])
                              ]),
                          childSecond: _webView("https://mobile.here.com/")
                          /* GoogleMap(
                                                      mapType: MapType.normal,
                                                      initialCameraPosition: _kGooglePlex,
                                                      onMapCreated: (GoogleMapController controller) {
                                                        _controller.complete(controller);
                                                      },
                                                    ),*/
                          ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // _webView(final String url) => WebView(
  //     initialUrl: url,
  //   javascriptMode: JavascriptMode.unrestricted,
  // );

  _webView(final String url) => WebviewScaffold(
        url: url,
        withZoom: false,
        invalidUrlRegex: '^intent:',
        // hidden: true,
        geolocationEnabled: true,
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

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: 'c35f7ae801e4423bb8ba2d30e441202c',
          redirectUrl: 'com.cardashboard://callback');
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: 'c35f7ae801e4423bb8ba2d30e441202c',
          redirectUrl: 'com.cardashboard://callback',
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String message = ''}) {
    var text = message.isEmpty ? '' : ' : $message';
    _logger.d('$code$text');
    if (text != "")
      status = text;
    else
      status = code;
  }

  _getAddressFromLatLng(Position _currentPosition) async {
    try {
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('HH:mm:ss');
      String formatted = formatter.format(now);

      var speed = (_currentPosition.speed) * (60 * 60) ~/ 1000;
      print(speed);
      print(_currentPosition.latitude);
      print(_currentPosition.longitude);
    } catch (e) {
      print(e);
    }
  }

  Widget playerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      initialData: PlayerState(
        null,
        1,
        1,
        null,
        null,
        isPaused: false,
      ),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        if (snapshot.data != null && snapshot.data.track != null) {
          var playerState = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('''
                    ${playerState.track.name} 
                    by ${playerState.track.artist.name} 
                    from the album ${playerState.track.album.name} '''),
              spotifyImageWidget(playerState.track.imageUri.raw),
              //      Text('Image URI: ${playerState.track.imageUri.raw}'),
            ],
          );
        } else {
          return const Center(
            child: Text('Not connected'),
          );
        }
      },
    );
  }

  Widget spotifyImageWidget(String uri) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: ImageUri(uri),
          dimension: ImageDimension.small,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data);
          } else if (snapshot.hasError) {
            setStatus(snapshot.error.toString());
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.large.value.toDouble(),
              height: ImageDimension.large.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }
}
