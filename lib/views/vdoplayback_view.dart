import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_app/controllers/vdo_custom_controller.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VdoPlaybackView extends StatefulWidget {
  final bool controls;
  final EmbedInfo? embedInfo;

  const VdoPlaybackView({Key? key, this.embedInfo, this.controls = true})
      : super(key: key);

  @override
  VdoPlaybackViewState createState() => VdoPlaybackViewState();
}

class VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController? _controller;
  final double aspectRatio = 16 / 9;
  VdoPlayerValue? vdoPlayerValue;
  final ValueNotifier<bool> _isFullScreen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    String? mediaId = ModalRoute.of(context)?.settings.arguments as String?;
    EmbedInfo? embedInfo = widget.embedInfo;
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
                    SizedBox(
                      width: _getPlayerWidth(),
                      height: _getPlayerHeight(),
                      child: VdoPlayer(
                        embedInfo: embedInfo!,
                        aspectRatio: aspectRatio,
                        onError: _onVdoError,
                        onFullscreenChange: _onFullscreenChange,
                        onPlayerCreated: _onPlayerCreated,
                        controls: widget.controls,
                      ),
                    ),
                    if (_controller == null ||
                        widget.controls ||
                        MediaQuery.of(context).size.width < 300 ||
                        kIsWeb)
                      const SizedBox.shrink()
                    else
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: _isFullScreen.value
                            ? MediaQuery.of(context).size.height
                            : _getHeightForWidth(MediaQuery.of(context).size.width),
                        child: VdoCustomControllerView(
                          controller: _controller,
                          onError: _onVdoError,
                          onFullscreenChange: _onFullscreenChange,
                        ),
                      ),
                  ],
                )),
            ValueListenableBuilder(
                valueListenable: _isFullScreen,
                builder: (context, dynamic value, child) {
                  return value ? const SizedBox.shrink() : _nonFullScreenContent();
                }),
          ]),
        ));
  }

  _onVdoError(VdoError vdoError) {
    if (kDebugMode) {
      print("Oops, the system encountered a problem: ${vdoError.message}");
    }
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
        vdoPlayerValue = value;
      });
      if (kDebugMode) {
        print("VdoControllerListner"
            "\nloading: ${value.isLoading} "
            "\nplaying: ${value.isPlaying} "
            "\nbuffering: ${value.isBuffering} "
            "\nended: ${value.isEnded}");
      }
      _printProperties(controller);
    });
  }

  _printProperties(VdoPlayerController? controller) async {
    int? totalPlayed =
        await controller?.getPlaybackProperty("totalPlayed") as int?;
    int? totalCovered =
        await controller?.getPlaybackProperty("totalCovered") as int?;
    if (kDebugMode) {
      print("VdoControllerListener"
          "\ntotalPlayed: $totalPlayed "
          "\ntotalCovered: $totalCovered ");
    }
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _nonFullScreenContent() {
    return Column(children: const [
      SizedBox(
        height: 10,
      ),
      Text(
        'Sample Playback',
        style: TextStyle(fontSize: 20.0),
      ),
    ]);
  }

  _getPlayerWidth() {
    return kIsWeb ? 800 : MediaQuery.of(context).size.width;
  }

  _getPlayerHeight() {
    return kIsWeb
        ? 550
        : _isFullScreen.value
        ? MediaQuery.of(context).size.height
        : _getHeightForWidth(MediaQuery.of(context).size.width);
  }

  double _getHeightForWidth(double width) {
    return width / aspectRatio;
  }
}
