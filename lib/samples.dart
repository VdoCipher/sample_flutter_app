import 'package:vdocipher_flutter/vdocipher_flutter.dart';

const EmbedInfo SAMPLE_1 = EmbedInfo.streaming(
    otp: '20160313versASE313BlEe9YKEaDuju5J0XcX2Z03Hrvm5rzKScvuyojMSBZBxfZ',
    playbackInfo:
        'eyJ2aWRlb0lkIjoiM2YyOWI1NDM0YTVjNjE1Y2RhMThiMTZhNjIzMmZkNzUifQ==');

const EmbedInfo SAMPLE_2 = EmbedInfo.streaming(
    otp: '20160313versASE323gks3zap5vOsyQXbEf6IgQ5j3jEFtAOn3uWQaCpLXKgnRif',
    playbackInfo:
        'eyJ2aWRlb0lkIjoiMjY0ZDUxMWM1NDJhNGQyM2IwY2M3MzE3ODY3YWM0ODMifQ==',
    embedInfoOptions: EmbedInfoOptions(enablePip: true));
