import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

/// VdoPlayer controls created with [VdoPlayerController] to control playback and returns [onFullscreenChange] callback function
class VdoCustomControllerView extends StatefulWidget {
  final VdoPlayerController? controller;
  final Function(bool)? onFullscreenChange;
  final Function(VdoError vdoError) onError;

  const VdoCustomControllerView(
      {Key? key,
      required this.controller,
      this.onFullscreenChange,
      required this.onError})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VdoCustomControllerViewState();
}

class _VdoCustomControllerViewState extends State<VdoCustomControllerView>
    with WidgetsBindingObserver {
  late VdoPlayerValue _playerValue;
  late Size _windowSize;
  bool _isVisibleControls = true;
  final double _iconSize = 40.0;
  final double _smallIconSize = 30.0;
  bool _isFullScreenMode = false;
  double _currentPlaybackTime = 0;
  bool _isScrubbing = false;
  bool _currentLoadingState = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.controller!.addListener(_updatePlayerState);
    _updatePlayerState();

    // If time not started and video is not in loading state then start timer
    if (_hideTimer == null && !_playerValue.isLoading) {
      _cancelAndRestartTimer();
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    widget.controller!.removeListener(_updatePlayerState);
    _portraitScreen();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When App Goes to background
    if (state == AppLifecycleState.paused) {
      widget.controller!.removeListener(_updatePlayerState);

      // If Full screen mode then exit to normal
      if (_isFullScreenMode) {
        _toggleFullScreenMode();
      }

      // When App comes to foreground
    } else if (state == AppLifecycleState.resumed) {
      widget.controller!.addListener(_updatePlayerState);
      _updatePlayerState();
    }
  }

  _updatePlayerState() {
    setState(() {
      _playerValue = widget.controller!.value;
      if (!_isScrubbing && !_playerValue.isBuffering) {
        double playerPosition = _playerValue.position.inMilliseconds.toDouble();
        double playbackDuration =
            _playerValue.duration.inMilliseconds.toDouble();
        if (0 <= playerPosition && playerPosition <= playbackDuration) {
          _currentPlaybackTime = playerPosition;
        }
      }
      if (_currentLoadingState != _playerValue.isLoading &&
          _playerValue.isLoading == false) {
        _cancelAndRestartTimer();
      }
      _currentLoadingState = _playerValue.isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    _windowSize = MediaQuery.of(context).size;

    return Platform.isIOS
        ? _vdoControlArea()
        : WillPopScope(
            onWillPop: () async {
              if (_isFullScreenMode) {
                _toggleFullScreenMode();
                return false;
              }

              return true;
            },
            child: _vdoControlArea());
  }

  _vdoControlArea() {
    bool showProgressIndicator =
        _playerValue.isLoading || _playerValue.isBuffering;
    bool showError = _playerValue.vdoError != null;
    showProgressIndicator = showProgressIndicator && !showError;
    bool showOverlayControls = _isVisibleControls && !showError;
    bool showBackgroundTint = showError || _isVisibleControls;

    return MouseRegion(
        onHover: (_) {
          _cancelAndRestartTimer();
        },
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _cancelAndRestartTimer(),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                        child: (_playerValue.isLoading || showError)
                            ? Container(
                                color: Colors.black,
                                child: const Text(''),
                              )
                            : const SizedBox.shrink()),
                    // Background tint when controls are visible
                    Positioned(
                        child: !showBackgroundTint
                            ? const SizedBox.shrink()
                            : Container(
                                width: _windowSize.width,
                                color: Colors.black.withOpacity(0.25))),

                    // Progress indicator
                    Positioned.fill(
                        child: !showProgressIndicator
                            ? const SizedBox.shrink()
                            : const Center(
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      color: Colors.white,
                                    )))),

                    // Error view
                    Positioned.fill(
                        child: !showError
                            ? const SizedBox.shrink()
                            : Center(child: _errorInfo())),

                    // Video Overlay controllers
                    showOverlayControls
                        ? _vdoOverlayController()
                        : const SizedBox.shrink(),

                    // Video seek bar
                    Positioned(
                      child: showOverlayControls
                          ? _vdoProgress()
                          : const SizedBox.shrink(),
                      bottom: 30.0,
                      left: 0,
                      right: 0,
                    ),

                    // Video bottom controllers
                    Positioned(
                        child: showOverlayControls
                            ? _bottomControlPanel()
                            : const SizedBox.shrink(),
                        bottom: 6.0,
                        left: 0,
                        right: 0),
                  ]),
            )));
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();

    if (!mounted) {
      return;
    }

    // Visible controls on tap
    setState(() {
      _isVisibleControls = true;
    });

    // Hide controls after 3 seconds
    _hideTimer = Timer(const Duration(seconds: 3), () {
      // if video not playing then don't hide controls
      if (!widget.controller!.isPlaying) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isVisibleControls = false;
      });
    });
  }

  /// Video Overlay controllers
  _vdoOverlayController() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              child: Icon(
                Icons.replay,
                color: Colors.white,
                size: _iconSize,
              ),
              onTap: () => _seekTo(-_playerValue.skipDuration)),
          InkWell(
              child: _playPauseRewind(), onTap: () => _playPauseRewindToggle()),
          InkWell(
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: _iconSize,
                  )),
              onTap: () => _seekTo(_playerValue.skipDuration)),
        ],
      ),
    );
  }

  _errorInfo() {
    widget.onError(_playerValue.vdoError!); // VdoError callback

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.error, size: _smallIconSize, color: Colors.white),
      Text('Error code: ${_playerValue.vdoError!.code}',
          style: const TextStyle(fontSize: 16, color: Colors.white)),
      Text(_playerValue.vdoError!.message,
          style: const TextStyle(fontSize: 16, color: Colors.white))
    ]);
  }

  _playPauseRewind() {
    IconData icon = _playerValue.isEnded
        ? Icons.replay
        : _playerValue.isPlaying
            ? Icons.pause
            : Icons.play_arrow;
    return Icon(
      icon,
      color: Colors.white,
      size: _iconSize,
    );
  }

  /// Video Progress seekbar
  _vdoProgress() {
    return Container(
        margin: const EdgeInsets.only(left: 1, right: 1.0),
        child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              // trackHeight: 2.0
            ),
            child: Slider(
              value: _currentPlaybackTime,
              min: 0,
              max: _playerValue.duration.inMilliseconds.toDouble(),
              activeColor: Colors.redAccent,
              inactiveColor: Colors.grey,
              onChangeStart: (val) {
                _isScrubbing = true;
                _hideTimer?.cancel();
              },
              onChanged: (val) {
                setState(() {
                  _currentPlaybackTime = val;
                });
              },
              onChangeEnd: (val) {
                widget.controller!
                    .seek(Duration(milliseconds: val.round()))
                    .then((value) => {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              _isScrubbing = false;
                            });
                          }),
                          _cancelAndRestartTimer()
                        });
              },
            )));
  }

  /// Video bottom controllers
  _bottomControlPanel() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
            margin: const EdgeInsets.only(left: 14.0, right: 14.0),
            child: Text(
                '${vdoTimeFormatter(_playerValue.position.inSeconds)} / ${vdoTimeFormatter(_playerValue.duration.inSeconds)}',
                style: const TextStyle(fontSize: 20, color: Colors.white)))
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _navItem(
            onClick: () => _showSubtitleOptions(),
            iconData: Icons.closed_caption),
        _navItem(
            onClick: () => _showPlaybackSpeedOptions(),
            iconData: Icons.speed_sharp),
        Platform.isIOS
            ? const SizedBox.shrink()
            : _navItem(
                onClick: () => _showQualityOptions(), iconData: Icons.hd),
        _navItem(
            onClick: () => _toggleFullScreenMode(),
            iconData:
                _isFullScreenMode ? Icons.fullscreen_exit : Icons.fullscreen),
      ]),
    ]);
  }

  _showPlaybackSpeedOptions() {
    final double playbackSpeed = _playerValue.playbackSpeed;
    final List<double> playbackSpeedOptions =
        _playerValue.playbackSpeedOptions.isEmpty
            ? defaultPlaybackSpeedOptions
            : _playerValue.playbackSpeedOptions;

    final List<Widget> items = [];

    for (var i in playbackSpeedOptions) {
      bool isSelected = i == playbackSpeed;
      String label =
          "${(i == 1 ? "Normal" : "${i.toString()}x")} ${isSelected ? " ✔️" : ""}";
      items.add(_buildTrackModalItem(label, () {
        Navigator.pop(context);
        if (!isSelected) {
          widget.controller!.setPlaybackSpeed(i);
        }
      }));
    }

    _showModalBottomSheet(items);
  }

  _showSubtitleOptions() {
    final List<SubtitleTrack> subtitleTracks = _playerValue.subtitleTracks;
    final SubtitleTrack? selectedSubtitleTrack = _playerValue.subtitleTrack;
    final List<Widget> items = [];

    for (SubtitleTrack track in subtitleTracks) {
      final bool isSelected = track == selectedSubtitleTrack;

      final String? language = track.language;
      final String isSelectedMsg = isSelected ? ("✔️") : "";
      final String itemName = "$language $isSelectedMsg";
      items.add(_buildTrackModalItem(itemName, () {
        Navigator.pop(context);
        if (!isSelected) {
          widget.controller!.setSubtitleLanguage(track.language);
        }
      }));
    }

    if (items.isNotEmpty) {
      final bool isSelected = selectedSubtitleTrack == null;
      final String isSelectedMsg = isSelected ? ("✔️") : "";
      // Add widget to set track selection back to adaptive mode
      items.insert(
          0,
          _buildTrackModalItem("Off $isSelectedMsg", () {
            Navigator.pop(context);
            widget.controller!.setSubtitleLanguage(null);
          }));
    } else if (items.isEmpty) {
      items.add(_buildTrackModalItem("Off", () {
        Navigator.pop(context);
      }));
    }

    _showModalBottomSheet(items);
  }

  _showQualityOptions() {
    final List<VideoTrack> videoTracks = _playerValue.videoTracks;
    final VideoTrack? selectedVideo = _playerValue.videoTrack;
    final bool isAdaptive = _playerValue.isAdaptive;
    final List<Widget> items = [];

    for (VideoTrack track in videoTracks) {
      final bool isSelected = track == selectedVideo;

      final int totalBitrateKbps = track.bitrate! ~/ 1024;
      final String isAdaptiveMsg = isAdaptive ? " (Auto)" : "";
      final String isSelectedMsg = isSelected ? ("$isAdaptiveMsg  ✔️") : "";
      final String itemName =
          "$totalBitrateKbps kbps (${_combinedDataExpenditurePerHour(track, null)})$isSelectedMsg";
      items.add(_buildTrackModalItem(itemName, () {
        Navigator.pop(context);
        if (!isSelected) {
          widget.controller!.setVideoTrack(track);
        }
      }));
    }

    if (items.isNotEmpty && !isAdaptive) {
      // Add widget to set track selection back to adaptive mode
      items.insert(
          0,
          _buildTrackModalItem("Auto", () {
            Navigator.pop(context);
            widget.controller!.setAdaptive();
          }));
    } else if (items.isEmpty) {
      items.add(_buildTrackModalItem("Auto", () {
        Navigator.pop(context);
      }));
    }

    _showModalBottomSheet(items);
  }

  _buildTrackModalItem(String text, Function onTap) {
    return InkWell(
        onTap: onTap as void Function()?,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text(text)));
  }

  _showModalBottomSheet(List<Widget> items) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: items,
            ),
          );
        });
  }

  /// On Play/Pause button click handler for both overlay and bottom controller
  _playPauseRewindToggle() {
    if (widget.controller == null) {
      return;
    }

    if (_playerValue.isEnded) {
      widget.controller!.seek(Duration.zero);
      widget.controller!.play();
    } else if (_playerValue.isPlaying) {
      widget.controller!.pause();
    } else {
      widget.controller!.play();
    }
  }

  _seekTo(Duration interval) async {
    Duration currentPosition = await widget.controller!.getPosition();
    widget.controller!.seek(currentPosition + interval);
  }

  Container _navItem({Function? onClick, IconData? iconData}) {
    return Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onClick as void Function()?,
          child: Icon(
            iconData,
            size: _smallIconSize,
            color: Colors.white,
          ),
        ));
  }

  _toggleFullScreenMode() {
    setState(() {
      _isFullScreenMode = !_isFullScreenMode;
    });

    if (widget.onFullscreenChange != null) {
      widget.onFullscreenChange!(_isFullScreenMode);
    }

    if (_isFullScreenMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      _portraitScreen();
    }
  }

  void _portraitScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  /// Combined data expenditure in MB/hr or GB/hr
  String _combinedDataExpenditurePerHour(VideoTrack video, AudioTrack? audio) {
    int videoBitrate = video.bitrate ?? 0;
    int audioBitrate = audio != null ? (audio.bitrate ?? 0) : 0;
    return _dataExpenditurePerHour(videoBitrate + audioBitrate);
  }

  /// Data expenditure in MB/hr or GB/hr
  String _dataExpenditurePerHour(int bitsPerSecond) {
    if (bitsPerSecond == 0) {
      return "-";
    }
    final double bytesPerHour = (bitsPerSecond * 3600) / 8;
    final double megaBytesPerHour = bytesPerHour / (1024 * 1024);

    if (megaBytesPerHour < 1) {
      return "1 MB per hour";
    } else if (megaBytesPerHour < 1024) {
      return "${megaBytesPerHour.toInt()} MB per hour";
    } else {
      double gigaBytesPerHour = megaBytesPerHour / 1024;
      return "${gigaBytesPerHour.toStringAsFixed(2)} GB per hour";
    }
  }
}
