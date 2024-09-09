import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_flutter_app/utils/playlist_holder.dart';
import 'package:sample_flutter_app/utils/playlist_manager.dart';
import 'package:sample_flutter_app/utils/utils.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VdoPlaylistView extends StatefulWidget {
  const VdoPlaylistView({Key? key}) : super(key: key);

  @override
  State<VdoPlaylistView> createState() => _VdoPlaylistViewState();
}

class _VdoPlaylistViewState extends State<VdoPlaylistView> {
  VdoPlayerController? _controller; // Controller for VdoPlayer
  final double aspectRatio = 16 / 9; // Aspect ratio for video player
  VdoPlayerValue? vdoPlayerValue; // Current value of the VdoPlayer
  late PlaylistManager playlistManager; // Manages the playlist

  @override
  void initState() {
    super.initState();
    // Initialize PlaylistManager with PlaylistHolder and loopPlaylist enabled
    playlistManager = PlaylistManager(PlaylistHolder(), loopPlaylist: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video player widget
            Flexible(
              child: SizedBox(
                width: _getPlayerWidth(),
                height: _getPlayerHeight(),
                child: VdoPlayer(
                    embedInfo:
                    playlistManager.getCurrentMediaItem().getEmbedInfo(),
                    onPlayerCreated: _onPlayerCreated,
                    onError: _onVdoError),
              ),
            ),
            // Playlist of media items
            Flexible(
              child: ListView.builder(
                itemCount: playlistManager.getPlaylistLength(),
                itemBuilder: (context, index) {
                  final mediaItem =
                  playlistManager.playlistHolder.mediaItems[index];
                  bool isPlaying = index == playlistManager.currentIndex;

                  return GestureDetector(
                    onTap: () {
                      playMedia(index); // Play media when tapped
                    },
                    child: ListTile(
                      leading: Image.network(mediaItem.thumbnailUrl,
                          width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(mediaItem.title),
                      subtitle: Text(
                          "Duration: ${formatDuration(mediaItem.duration)}"),
                      trailing: isPlaying
                          ? const Icon(Icons.play_arrow, color: Colors.green) // Highlight playing media
                          : null,
                      selected: isPlaying,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get the width for the video player
  _getPlayerWidth() {
    return kIsWeb ? 800 : MediaQuery.of(context).size.width;
  }

  // Get the height for the video player based on the width
  _getPlayerHeight() {
    return kIsWeb ? 550 : _getHeightForWidth(MediaQuery.of(context).size.width);
  }

  // Calculate height based on width and aspect ratio
  double _getHeightForWidth(double width) {
    return width / aspectRatio;
  }

  // Handle errors from the VdoPlayer
  _onVdoError(VdoError vdoError) {
    print("Oops, the system encountered a problem: ${vdoError.message}");
  }

  // Callback when the VdoPlayer is created
  _onPlayerCreated(VdoPlayerController? controller) {
    setState(() {
      _controller = controller;
      _onEventChange(_controller);
    });
  }

  // Listen for events from the VdoPlayer
  _onEventChange(VdoPlayerController? controller) {
    controller!.addListener(() {
      VdoPlayerValue value = controller.value;
      setState(() {
        vdoPlayerValue = value;
      });

      // Play the next media if the current media has ended
      if (value.isEnded) {
        playNextMedia();
      }
    });
  }

  // Play media at a given index in the playlist
  void playMedia(int index) {
    MediaItem mediaItem = playlistManager.playMediaAtIndex(index);
    _controller?.load(mediaItem.getEmbedInfo());
  }

  // Play the next media in the playlist
  void playNextMedia() {
    MediaItem mediaItem = playlistManager.playNext();
    _controller?.load(mediaItem.getEmbedInfo());
  }
}