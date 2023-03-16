import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sample_flutter_app/utils/utils.dart';
import 'package:sample_flutter_app/views/vdoplayback_view.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class Sample {
  String mediaId;
  String mediaTitle;
  String otp;
  String playbackInfo;
  String customPlayerId;

  Sample(this.mediaId, this.mediaTitle, this.otp, this.playbackInfo,
      this.customPlayerId);
}

class VdoDownloadView extends StatefulWidget {
  VdoDownloadView({Key? key}) : super(key: key);

  @override
  State<VdoDownloadView> createState() => _VdoDownloadViewState();
}

class _VdoDownloadViewState extends State<VdoDownloadView>
    implements EventListener {
  DownloadOptions? downloadOptions;
  VdoDownloadManager vdoDownloadManager = VdoDownloadManager.getInstance();

  List<DownloadStatus> _downloadStatues = List.empty(growable: true);

  @override
  void onChanged(String mediaId, DownloadStatus downloadStatus) {
    for (int index = 0; index < _downloadStatues.length; index++) {
      if (_downloadStatues.elementAt(index).mediaInfo.mediaId ==
          downloadStatus.mediaInfo.mediaId) {
        setState(() {
          _downloadStatues[index] = downloadStatus;
        });
        break;
      }
    }
  }

  @override
  void onCompleted(String mediaId, DownloadStatus downloadStatus) {
    for (int index = 0; index < _downloadStatues.length; index++) {
      if (_downloadStatues.elementAt(index).mediaInfo.mediaId ==
          downloadStatus.mediaInfo.mediaId) {
        setState(() {
          _downloadStatues[index] = downloadStatus;
        });
        break;
      }
    }
  }

  @override
  void onDeleted(String mediaId) {
    for (int index = 0; index < _downloadStatues.length; index++) {
      if (_downloadStatues.elementAt(index).mediaInfo.mediaId == mediaId) {
        setState(() {
          _downloadStatues.removeAt(index);
        });
        break;
      }
    }
  }

  @override
  void onFailed(String mediaId, DownloadStatus downloadStatus) {
    for (int index = 0; index < _downloadStatues.length; index++) {
      if (_downloadStatues.elementAt(index).mediaInfo.mediaId ==
          downloadStatus.mediaInfo.mediaId) {
        setState(() {
          _downloadStatues[index] = downloadStatus;
        });
        break;
      }
    }
  }

  @override
  void onQueued(String mediaId, DownloadStatus downloadStatus) {
    setState(() {
      _downloadStatues.add(downloadStatus);
    });
  }

  @override
  void initState() {
    super.initState();
    vdoDownloadManager.addDownloadEventListener(this);
    _getDownloadList();
  }

  _getDownloadList() async {
    Query query = new Query();
    List<DownloadStatus> downloadStatusList =
        await vdoDownloadManager.query(query);
    for (DownloadStatus downloadStatus in downloadStatusList) {
      setState(() {
        _downloadStatues.add(downloadStatus);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Sample sample1 = Sample(
        "7811c48b3a0f40f5abeffae71ce4d3e0",
        "Elephant Dream",
        "20160313versASE3237s0dsh3BLe1blSsdhRUHIEkvnHjqvP0DlCU1SF45Rb42sq",
        "eyJ2aWRlb0lkIjoiNzgxMWM0OGIzYTBmNDBmNWFiZWZmYWU3MWNlNGQzZTAifQ==",
        "");

    Sample sample2 = Sample(
      "b40e3faaabd841ac86dbeea9073f38c3",
      "Big Buck Bunny",
      "20160313versASE323kp60ptZkUUEtxpHqRbIwCDCmWc4QPuZO7mQ9bJ5vZGxeIJ",
      "eyJ2aWRlb0lkIjoiYjQwZTNmYWFhYmQ4NDFhYzg2ZGJlZWE5MDczZjM4YzMifQ==",
      "",
    );

    List<Sample> sampleMediaItems = List.from([sample1, sample2]);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          'Download',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: sampleMediaItems.length,
                itemBuilder: (context, index) {
                  return Container(
                      child: _getMediaDetailWidget(
                          sampleMediaItems.elementAt(index)));
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              'Downloads',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _downloadStatues.length,
                  itemBuilder: (context, index) {
                    return _buildItem(_downloadStatues.elementAt(index));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(DownloadStatus downloadStatus) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: Colors.white38,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: RouteSettings(
                      name: '/playerui/sample/video',
                      arguments: downloadStatus.mediaInfo.mediaId),
                  builder: (BuildContext context) {
                    return VdoPlaybackView();
                  },
                ),
              );
            },
            child: Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 60,
                        height: 60,
                        child: (downloadStatus.poster != null)
                            ? Image.file(
                                File.fromUri(Uri.file(downloadStatus.poster!)))
                            : SizedBox.shrink()),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(downloadStatus.mediaInfo.title!),
                          Text(
                              "${downloadStatus.mediaInfo.duration.inSeconds.toString()} s")
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(_statusName(downloadStatus)),
                        Text("${downloadStatus.downloadPercent.toString()}%")
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    vdoDownloadManager
                        .resumeDownload(downloadStatus.mediaInfo.mediaId);
                  },
                  child: Text('Resume'.toUpperCase())),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    vdoDownloadManager
                        .stopDownload(downloadStatus.mediaInfo.mediaId);
                  },
                  child: Text('Stop'.toUpperCase())),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    vdoDownloadManager.remove(downloadStatus.mediaInfo.mediaId);
                  },
                  child: Text('Delete'.toUpperCase())),
            ],
          )
        ],
      ),
    );
  }

  _downloadMedia(Sample sample) {
    _showDownloadOptions(context, sample, (downloadSelections) {
      DownloadRequest downloadRequest = new DownloadRequest(downloadSelections);
      vdoDownloadManager.enqueue(downloadRequest);
    });
  }

  _getMediaDetailWidget(Sample sample) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sample.mediaTitle.toUpperCase(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          IconButton(
              onPressed: () {
                _downloadMedia(sample);
              },
              icon: Icon(Icons.download_for_offline)),
        ],
      ),
    );
  }

  _showDownloadOptions(BuildContext context, Sample sample,
      Function(DownloadSelections) onTrackSelection) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          DownloadOptions? downloadOptions;
          int selectedIndex = -1;
          return StatefulBuilder(builder: (context, setState) {
            if (downloadOptions == null) {
              new OptionsDownloader().downloadOptionsWithOtp(
                  sample.otp, sample.playbackInfo, sample.customPlayerId,
                  (options) {
                setState(() {
                  downloadOptions = options;
                });
              }, (vdoError) {});
            }
            return downloadOptions == null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Available tracks',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            'Select any one to download',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: downloadOptions!.allVideo.length,
                              itemBuilder: (_, index) {
                                int totalBitrate =
                                    downloadOptions!.allVideo[index].bitrate! +
                                        downloadOptions!.allAudio[0].bitrate!;
                                String mediaSize = Utils.mediaSize(
                                    totalBitrate,
                                    downloadOptions!
                                        .mediaInfo.duration.inMilliseconds);
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: CheckboxListTile(
                                    title: Text(
                                        'Bitrate: ${totalBitrate ~/ 1024} kbps, ${mediaSize}'),
                                    value: (index == selectedIndex),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value != null && value == true) {
                                          selectedIndex = index;
                                        }
                                      });
                                    },
                                    secondary: const Icon(Icons.video_file),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  if (selectedIndex == -1) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Select a track first"),
                                    ));
                                    return;
                                  }
                                  DownloadSelections downloadSelections =
                                      new DownloadSelections(
                                          downloadOptions!, selectedIndex, 0);
                                  onTrackSelection(downloadSelections);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Download')),
                          ),
                        ],
                      ),
                    ),
                  );
          });
        });
  }

  String _statusName(DownloadStatus status) {
    switch (status.status) {
      case VdoDownloadManager.STATUS_COMPLETED:
        return "COMPLETED";
      case VdoDownloadManager.STATUS_DOWNLOADING:
        return "DOWNLOADING";
      case VdoDownloadManager.STATUS_FAILED:
        return "FAILED";
      case VdoDownloadManager.STATUS_NOT_FOUND:
        return "NOT FOUND";
      case VdoDownloadManager.STATUS_PAUSED:
        return "PAUSED";
      case VdoDownloadManager.STATUS_PENDING:
        return "PENDING";
      case VdoDownloadManager.STATUS_REMOVING:
        return "REMOVING";
      case VdoDownloadManager.STATUS_RESTARTING:
        return "RESTARTING";
      default:
        throw Exception("invalid download status");
    }
  }

  @override
  void dispose() {
    super.dispose();
    vdoDownloadManager.removeDownloadEventListener(this);
  }
}
