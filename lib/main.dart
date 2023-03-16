import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_flutter_app/views/vdo_download_view.dart';
import 'package:sample_flutter_app/views/vdoplayback_view.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade700, // status bar color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
      navigatorObservers: [
        VdoPlayerController.navigatorObserver('/player/(.*)')
      ],
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: TextTheme(bodyText1: TextStyle(fontSize: 14.0))),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('VdoCipher Sample Application'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 24, bottom: 16),
                    child: Text(
                      'Online Playback',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToVideoUiPlayback,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.play_circle,
                              size: 48,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Play with inbuilt ui'.toUpperCase(),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: _goToVideoPlayback,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.play_circle,
                              size: 48,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text('Play with custom ui'.toUpperCase(),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 48, bottom: 16),
                    child: Text(
                      'Offline Playback',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToVdoDownloadView,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 12, bottom: 12),
                      child: Text('Download'.toUpperCase(),
                          style: TextStyle(fontSize: 16)),
                    ),
                  )
                ]),
          ),
        ));
  }

  void _goToVideoPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/player/sample/video'),
        builder: (BuildContext context) {
          return VdoPlaybackView(
            controls: false,
          );
        },
      ),
    );
  }

  void _goToVideoUiPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/playerui/sample/video'),
        builder: (BuildContext context) {
          return VdoPlaybackView(
            controls: true,
          );
        },
      ),
    );
  }

  void _goToVdoDownloadView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/offline/download'),
        builder: (BuildContext context) {
          return VdoDownloadView();
        },
      ),
    );
  }
}
