import 'package:flutter/material.dart';

import 'vdoplayback_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VdoCipher Sample Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'VdoCipher Sample Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Column(
        children: <Widget>[
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _goToVideoPlayback,
                  child: const Text('Online Playback',
                    style: TextStyle(fontSize: 20)),
                )
              ]
          )),
        ],
      ))
    );
  }

  void _goToVideoPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return VdoPlaybackView();
        },
      ),
    );
  }
}
