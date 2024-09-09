import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_flutter_app/samples.dart';
import 'package:sample_flutter_app/views/vdo_download_view.dart';
import 'package:sample_flutter_app/views/vdo_playlist_view.dart';
import 'package:sample_flutter_app/views/vdoplayback_view.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade700, // status bar color
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHome(),
      navigatorObservers: [
        VdoPlayerController.navigatorObserver('/player/(.*)')
      ],
      theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 14.0))),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16, top: 24, bottom: 16),
                    child: Text(
                      'Online Playback',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToVideoUiPlayback,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.play_circle,
                            size: 48,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('Play with inbuilt ui'.toUpperCase(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (kIsWeb) {
                        _goToVideoPlaybackNaiveUi();
                      } else {
                        _goToVideoPlayback();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.play_circle,
                            size: 48,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              kIsWeb
                                  ? 'Play with native ui'.toUpperCase()
                                  : 'Play with custom ui'.toUpperCase(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: _goToVideoPlaylist,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.playlist_play,
                            size: 48,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('Open Playlist'.toUpperCase(),
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  if (!kIsWeb)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16, top: 48, bottom: 16),
                      child: Text(
                        'Offline Playback',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (!kIsWeb)
                    ElevatedButton(
                      onPressed: _goToVdoDownloadView,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, right: 32.0, top: 12, bottom: 12),
                        child: Text('Download'.toUpperCase(),
                            style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                ]),
          ),
        ));
  }

  void _goToVideoPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/player/sample/video'),
        builder: (BuildContext context) {
          return const VdoPlaybackView(
            controls: false,
            embedInfo: sample_1,
          );
        },
      ),
    );
  }

  /// Illustrate web playback utilizing native user interface.
  void _goToVideoPlaybackNaiveUi() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/player-native/sample/video'),
        builder: (BuildContext context) {
          return const VdoPlaybackView(
            embedInfo: sample_2,
            controls: true,
          );
        },
      ),
    );
  }

  void _goToVideoUiPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/player-ui/sample/video'),
        builder: (BuildContext context) {
          return const VdoPlaybackView(
            embedInfo: sample_1,
            controls: true,
          );
        },
      ),
    );
  }

  void _goToVideoPlaylist() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/player-ui/sample/playlist'),
        builder: (BuildContext context) {
          return const VdoPlaylistView();
        },
      ),
    );
  }

  void _goToVdoDownloadView() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/offline/download'),
        builder: (BuildContext context) {
          return const VdoDownloadView();
        },
      ),
    );
  }
}
