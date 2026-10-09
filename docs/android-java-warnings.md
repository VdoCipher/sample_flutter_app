# Android Java compiler warnings in vdocipher_flutter 2.8.6

A clean Android release compilation reports deprecated API and unchecked-operation notes from vdocipher_flutter 2.8.6. Enabling Java compiler diagnostics identifies 32 warnings: 7 deprecation warnings and 25 unchecked casts. Compilation succeeds, but these notes remain on clean builds.

## Reproduction

This report concerns the published plugin, not the sample application's Kotlin entry point. The plugin implementation is not included in this repository.

In an existing Flutter application that resolves `vdocipher_flutter` to 2.8.6, run from its `android` directory:

```sh
./gradlew :vdocipher_flutter:compileReleaseJavaWithJavac --rerun-tasks \
  --init-script /absolute/path/to/sample_flutter_app/tools/vdocipher-java-lint.gradle \
  --console=plain
```

The init script enables deprecation and unchecked diagnostics only for the plugin's Java compilation. It does not suppress warnings. `--rerun-tasks` ensures an incremental build does not skip the affected compiler task.

The command above was verified in a consuming application using plugin 2.8.6: the plugin compilation completed successfully and reported all 32 warnings. An earlier diagnostic run through `:app:compileReleaseJavaWithJavac` produced the same findings.

The sample application's current `pubspec.yaml` constrains Dart to `<3.0.0`, while plugin 2.8.6 requires Dart >=3.3.0. Reproduction with that plugin version therefore requires a compatible consuming application; this PR does not migrate the sample's toolchain.

## Findings

- Deprecated VdoCipher methods: setOtp, setPlaybackInfo, and downloadOptionsWithOtp. Any migration must preserve existing OTP/playbackInfo consumers.
- Deprecated Android AudioManager methods: requestAudioFocus and abandonAudioFocus. A replacement must retain support for Android versions below API 26.
- Unchecked generic casts at platform-channel boundaries: nested maps, lists of media IDs, statuses, and tech overrides.

## Requested changes

Validate and convert channel values into typed collections, update supported native APIs, and add focused regression coverage for OTP/token/offline playback, downloads, and audio-focus cleanup. Avoid globally suppressing compiler diagnostics.

## Captured compiler locations

```text
android/src/main/java/com/vdocipher/flutter/vdoplayer/EmbedInfoToVdoInitParams.java:28: warning: [deprecation] setOtp(String) in Builder has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/EmbedInfoToVdoInitParams.java:29: warning: [deprecation] setPlaybackInfo(String) in Builder has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/EmbedInfoToVdoInitParams.java:41: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/EmbedInfoToVdoInitParams.java:67: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/EmbedInfoToVdoInitParams.java:71: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerPlatformViewFactory.java:31: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerPlatformView.java:112: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerPlatformView.java:127: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:122: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:145: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:207: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:212: warning: [deprecation] downloadOptionsWithOtp(String,String,String,Callback) in OptionsDownloader has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:216: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:287: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:288: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:289: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:290: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:301: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:314: warning: [deprecation] downloadOptionsWithOtp(String,String,String,Callback) in OptionsDownloader has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:336: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:337: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdocipherFlutterPlugin.java:338: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformViewFactory.java:34: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/MessageUtils.java:144: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/MessageUtils.java:172: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/MessageUtils.java:173: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/MessageUtils.java:174: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformView.java:260: warning: [deprecation] abandonAudioFocus(OnAudioFocusChangeListener) in AudioManager has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformView.java:279: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformView.java:284: warning: [unchecked] unchecked cast
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformView.java:403: warning: [deprecation] abandonAudioFocus(OnAudioFocusChangeListener) in AudioManager has been deprecated
android/src/main/java/com/vdocipher/flutter/vdoplayer/VdoPlayerUiPlatformView.java:613: warning: [deprecation] requestAudioFocus(OnAudioFocusChangeListener,int,int) in AudioManager has been deprecated
```
