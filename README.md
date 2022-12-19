# sample_flutter_app

Sample Flutter application with VdoCipher flutter plugin integration.

This app demonstrates how to embed and play videos from your VdoCipher dashboard into your flutter app.

__Note:__ The VdoCipher flutter plugin currently only supports android. iOS is not supported.

## Try

This sample application can be run as it is without any configuration. Just clone this repository to your local machine and run it on an android device.

1. Make sure you have flutter development set up on your local machine.
2. Clone this repository to your local machine.
3. Open the project in Android Studio.
4. Open `pubspec.yaml`, click on "Pub get" in the top right. Alternatively, run `flutter pub get` in your app's root directory.
5. Run the app on an android device or emulator.

## Integrate the VdoCipher plugin in your own flutter application

__[Link to publication on pub dev](https://pub.dev/packages/vdocipher_flutter)__

### Install the plugin

Add the VdoCipher plugin as a dependency to your flutter app:

```
$ flutter pub add vdocipher_flutter
```

This will add a line like this to your package's `pubspec.yaml` (and run an implicit `dart pub get`):

```
dependencies:
  vdocipher_flutter: ^2.0.0
```

Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```
import 'package:vdocipher_flutter/vdocipher_flutter.dart';
```

__Note:__ If you run into an error like this during android build:

`minSdkVersion 17 cannot be smaller than version 18 declared in library [:vdocipher_flutter]`

you will need to change the `minSdkVersion` value to a minimum of 18 in your app's `build.gradle` file.

In your `app_project/android/app/build.gradle` file:

```
android {
    // ..

    defaultConfig {
        // other properties...
        minSdkVersion 18 // this must be 18 or higher
```

### Example

Simply drop a `VdoPlayer` widget into your layout with `embedInfo` specifying the video to play alongside 
any playback options.

```dart
import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

const EmbedInfo _embedInfo = EmbedInfo.streaming(
    otp: '20160313versASE313BlEe9YKEaDuju5J0XcX2Z03Hrvm5rzKScvuyojMSBZBxfZ',
    playbackInfo: 'eyJ2aWRlb0lkIjoiM2YyOWI1NDM0YTVjNjE1Y2RhMThiMTZhNjIzMmZkNzUifQ==',
    embedInfoOptions: EmbedInfoOptions(
        autoplay: true
    )
);

class VdoPlaybackView extends StatefulWidget {
  @override
  _VdoPlaybackViewState createState() => _VdoPlaybackViewState();
}

class _VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(child: Container(
                child: VdoPlayer(
                    embedInfo: _embedInfo,
                    onPlayerCreated: (controller) => _onPlayerCreated(controller)),
                width: MediaQuery.of(context).size.width,
                height: 200,
              )),
            ])
    );
  }

  _onPlayerCreated(VdoPlayerController controller) {
    setState(() {
      _controller = controller;
    });
  }
}
```

Explore this repository for code samples demonstrating fullscreen handling and other details.

See the complete API Reference and plugin details at the [pub dev website](https://pub.dev/packages/vdocipher_flutter).
