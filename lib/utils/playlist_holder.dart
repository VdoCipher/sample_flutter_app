import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class MediaItem {
  final String videoId; // Unique identifier for the video
  final String title; // Title of the video
  final String thumbnailUrl; // URL for the video's thumbnail image
  final int duration; // Duration of the video in seconds
  final String otp; // One-Time Password for accessing the video
  final String playbackInfo; // Playback information for the video

  // Constructor for MediaItem class
  MediaItem({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.otp,
    required this.playbackInfo
  });

  // Returns EmbedInfo object for VdoPlayer
  EmbedInfo getEmbedInfo() {
    return EmbedInfo.streaming(
        otp: this.otp,
        playbackInfo: this.playbackInfo,
        embedInfoOptions: EmbedInfoOptions(preferredCaptionsLanguage: 'en')); // Default captions language is set to English
  }
}

class PlaylistHolder {
  List<MediaItem> mediaItems = []; // List to hold media items

  // Constructor initializes media items
  PlaylistHolder() {
    prepareMediaItems();
  }

  // Returns the list of media items
  List<MediaItem> getMediaItems() {
    return mediaItems;
  }

  // Populates the mediaItems list with sample MediaItem objects
  void prepareMediaItems() {
    // Sample media item 1
    MediaItem mediaItem1 = MediaItem(
        videoId: "df18b398c85a48b2827ec694d96e0967",
        title: "Big Buck Bunny",
        thumbnailUrl:
        "https://d1z78r8i505acl.cloudfront.net/poster/w5wTtBSuo2Mv3.480.jpeg",
        duration: 596,
        otp: "20160313versASE323yV19xZdf8ir7Bg2fO4YUxMJB7eVi0ag2eU4XLJg0rpCcq2",
        playbackInfo:
        "eyJ2aWRlb0lkIjoiZGYxOGIzOThjODVhNDhiMjgyN2VjNjk0ZDk2ZTA5NjcifQ=="
    );

    // Sample media item 2
    MediaItem mediaItem2 = MediaItem(
        videoId: "786673d2ff8f4790a5b79f107c3e567f",
        title: "Tears of Steel",
        thumbnailUrl:
        "https://d1z78r8i505acl.cloudfront.net/poster/ev5iTFAwmGoCL.480.jpeg",
        duration: 734,
        otp: "20160313versASE323JN6ECwfzS1s9NSSVEYVObAc34FoHMHgyQoBgraBa5xEK5K",
        playbackInfo:
        "eyJ2aWRlb0lkIjoiNzg2NjczZDJmZjhmNDc5MGE1Yjc5ZjEwN2MzZTU2N2YifQ=="
    );

    // Sample media item 3
    MediaItem mediaItem3 = MediaItem(
        videoId: "48f744dd24494b7d82a77cdea045b61f",
        title: "Elephant Dream",
        thumbnailUrl:
        "https://d1z78r8i505acl.cloudfront.net/poster/FRFTAbZDfXk8f.480.jpeg",
        duration: 654,
        otp: "20160313versASE323YZWe4AC1Mm1Agz4BsRzCKJSuOIYKR21q2iVVCVL78vRpiv",
        playbackInfo:
        "eyJ2aWRlb0lkIjoiNDhmNzQ0ZGQyNDQ5NGI3ZDgyYTc3Y2RlYTA0NWI2MWYifQ=="
    );

    // Sample media item 4
    MediaItem mediaItem4 = MediaItem(
        videoId: "ca9bc81eb44348dd94ef9d6b6164a711",
        title: "Sintel",
        thumbnailUrl:
        "https://d1z78r8i505acl.cloudfront.net/poster/FmDaw6i6JVSvr.480.jpeg",
        duration: 888,
        otp: "20160313versASE3234ou3rA1Bb3uX7uNX5vK6obwFC7DL4FkwLBl6kLIaJGtLH3",
        playbackInfo:
        "eyJ2aWRlb0lkIjoiY2E5YmM4MWViNDQzNDhkZDk0ZWY5ZDZiNjE2NGE3MTEifQ=="
    );

    // Add the sample media items to the list
    mediaItems.add(mediaItem1);
    mediaItems.add(mediaItem2);
    mediaItems.add(mediaItem3);
    mediaItems.add(mediaItem4);
  }
}
