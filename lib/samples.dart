import 'package:vdocipher_flutter/vdocipher_flutter.dart';

/// Replace media id, otp, playback info with one of your account.
const EmbedInfo sample_1 = EmbedInfo.streaming(
  otp: '20160313versASE323howNpEouFa2uyTA9AYmLy7lhD8aTYhUlO2cOC3NnTzsf8s',
  playbackInfo:
      'eyJ2aWRlb0lkIjoiYjQwZTNmYWFhYmQ4NDFhYzg2ZGJlZWE5MDczZjM4YzMifQ==',
  embedInfoOptions: EmbedInfoOptions(autoplay: true),
);

const EmbedInfo sample_2 = EmbedInfo.streaming(
  otp: '20160313versASE323kuKgoD2DRMbH7rNrEb3ZpitNasF6FESTBdYe1NwL2Ooo0x',
  playbackInfo:
      'eyJ2aWRlb0lkIjoiNzgxMWM0OGIzYTBmNDBmNWFiZWZmYWU3MWNlNGQzZTAifQ==',
  embedInfoOptions: EmbedInfoOptions(
    nativeControls: true,
  ),
);
