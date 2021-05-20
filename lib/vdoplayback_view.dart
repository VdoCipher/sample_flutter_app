import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
import 'samples.dart';

class VdoPlaybackView extends StatefulWidget {

  @override
  _VdoPlaybackViewState createState() => _VdoPlaybackViewState();
}

class _VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController _controller;
  final double aspectRatio = 16/9;
  ValueNotifier<bool> _isFullScreen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(child: Container(
                child: VdoPlayer(
                    embedInfo: SAMPLE_1,
                    onPlayerCreated: (controller) => _onPlayerCreated(controller),
                    onFullscreenChange: _onFullscreenChange),
                width: MediaQuery.of(context).size.width,
                height: _isFullScreen.value ? MediaQuery.of(context).size.height : _getHeightForWidth(MediaQuery.of(context).size.width),
              )),
              ValueListenableBuilder(
                  valueListenable: _isFullScreen,
                  builder: (context, value, child) {
                    return value ? SizedBox.shrink() : _nonFullScreenContent();
                  })
            ])
    );
  }

  _onPlayerCreated(VdoPlayerController controller) {
    setState(() {
      _controller = controller;
    });
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _nonFullScreenContent() {
    return Column(
        children: [
          Text('Sample Playback', style: TextStyle(fontSize: 20.0),)
        ]);
  }

  double _getHeightForWidth(double width) {
    return width / aspectRatio;
  }
}