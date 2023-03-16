import 'package:flutter/material.dart';
import 'package:sample_flutter_app/controllers/vdo_custom_controller.dart';
import 'package:sample_flutter_app/samples.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VdoPlaybackView extends StatefulWidget {
  final bool controls;

  VdoPlaybackView({this.controls = true});

  @override
  _VdoPlaybackViewState createState() => _VdoPlaybackViewState();
}

class _VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController? _controller;
  final double aspectRatio = 16 / 9;
  VdoPlayerValue? vdoPlayerValue;
  ValueNotifier<bool> _isFullScreen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    String? mediaId = ModalRoute.of(context)?.settings.arguments as String?;
    EmbedInfo embedInfo = SAMPLE_2;
    if (mediaId != null && mediaId.isNotEmpty) {
      embedInfo = EmbedInfo.offline(mediaId: mediaId);
    }
    return Scaffold(
        body: SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Flexible(
            child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: VdoPlayer(
                embedInfo: embedInfo,
                aspectRatio: aspectRatio,
                onError: _onVdoError,
                onFullscreenChange: _onFullscreenChange,
                onPlayerCreated: _onPlayerCreated,
                controls: widget.controls,
              ),
              width: MediaQuery.of(context).size.width,
              height: _isFullScreen.value
                  ? MediaQuery.of(context).size.height
                  : _getHeightForWidth(MediaQuery.of(context).size.width),
            ),
            if (_controller == null || widget.controls)
              SizedBox.shrink()
            else
              Container(
                child: VdoCustomControllerView(
                  controller: _controller,
                  onError: _onVdoError,
                  onFullscreenChange: _onFullscreenChange,
                ),
                width: MediaQuery.of(context).size.width,
                height: _isFullScreen.value
                    ? MediaQuery.of(context).size.height
                    : _getHeightForWidth(MediaQuery.of(context).size.width),
              )
          ],
        )),
        ValueListenableBuilder(
            valueListenable: _isFullScreen,
            builder: (context, dynamic value, child) {
              return value ? SizedBox.shrink() : _nonFullScreenContent();
            }),
      ]),
    ));
  }

  _onVdoError(VdoError vdoError) {
    print("Oops, the system encountered a problem: " + vdoError.message);
  }

  _onPlayerCreated(VdoPlayerController? controller) {
    setState(() {
      _controller = controller;
      _onEventChange(_controller);
    });
  }

  _onEventChange(VdoPlayerController? controller) {
    controller!.addListener(() {
      VdoPlayerValue value = controller.value;
      setState(() {
        this.vdoPlayerValue = value;
      });
      print("VdoControllerListner"
          "\nloading: ${value.isLoading} "
          "\nplaying: ${value.isPlaying} "
          "\nbuffering: ${value.isBuffering} "
          "\nended: ${value.isEnded}");
      _printProperties(controller);
    });
  }

  _printProperties(VdoPlayerController? controller) async {
    int? totalPlayed =
        await controller?.getPlaybackProperty("totalPlayed") as int?;
    int? totalCovered =
        await controller?.getPlaybackProperty("totalCovered") as int?;
    print("VdoControllerListener"
        "\ntotalPlayed: ${totalPlayed} "
        "\ntotalCovered: ${totalCovered} ");
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _nonFullScreenContent() {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      Text(
        'Sample Playback',
        style: TextStyle(fontSize: 20.0),
      ),
    ]);
  }

  double _getHeightForWidth(double width) {
    return width / aspectRatio;
  }
}
