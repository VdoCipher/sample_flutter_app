import 'package:sample_flutter_app/utils/playlist_holder.dart';

class PlaylistManager {
  PlaylistHolder playlistHolder;
  int currentIndex = 0;
  bool loopPlaylist;

  PlaylistManager(this.playlistHolder, {this.loopPlaylist = false});

  // Get the current media item
  MediaItem getCurrentMediaItem() {
    return playlistHolder.mediaItems[currentIndex];
  }

  // Play the next media item with loop back if enabled
  MediaItem playNext() {
    if (currentIndex < playlistHolder.mediaItems.length - 1) {
      currentIndex++;
    } else if (loopPlaylist) {
      currentIndex = 0; // Loop back to the first item
    } else {
      // If looping is disabled, return the last item
      currentIndex = playlistHolder.mediaItems.length - 1;
    }
    return getCurrentMediaItem();
  }

  // Play the previous media item with loop back if enabled
  MediaItem playPrevious() {
    if (currentIndex > 0) {
      currentIndex--;
    } else if (loopPlaylist) {
      currentIndex = playlistHolder.mediaItems.length - 1; // Loop back to the last item
    } else {
      // If looping is disabled, return the first item
      currentIndex = 0;
    }
    return getCurrentMediaItem();
  }

  // Play a specific media item by index (safeguarded against out-of-bounds indices)
  MediaItem playMediaAtIndex(int index) {
    if (index >= 0 && index < playlistHolder.mediaItems.length) {
      currentIndex = index;
    } else {
      // If the index is out of bounds, return the first item
      currentIndex = 0;
    }
    return getCurrentMediaItem();
  }

  // Get the total number of media items
  int getPlaylistLength() {
    return playlistHolder.mediaItems.length;
  }
}