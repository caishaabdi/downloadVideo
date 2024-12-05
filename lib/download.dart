import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodwnload_video/downloadVideo.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<String> downloadedVideos = [];

  bool isDownloading = false;
  String progress = "";

  @override
  void initState() {
    super.initState();
    loadDownloadedVideos();
  }

  Future<void> loadDownloadedVideos() async {
    List<String> videos = await getDownloadedVideos();
    setState(() {
      downloadedVideos = videos;
    });
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.videos.request().isGranted) {
        print("Video permission granted for Android 13+");
      } else if (await Permission.storage.request().isGranted) {
        print("Storage permission granted");
      } else if (await Permission.storage.isPermanentlyDenied) {
        print("Permission permanently denied. Opening settings...");
        await openAppSettings();
      } else {
        print("Storage permission denied");
      }
    }
  }

  Future<void> saveDownloadedVideos(List<String> videos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('downloadedVideos', videos);
  }

  Future<List<String>> getDownloadedVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('downloadedVideos') ?? [];
  }

  Future<void> downloadVideo(String url, String fileName) async {
    await requestPermissions(); // Request permissions before downloading

    Dio dio = Dio();

    if (await Permission.storage.isGranted ||
        await Permission.videos.isGranted) {
      try {
        setState(() {
          isDownloading = true;
          progress = "0%";
        });

        Directory? directory = await getExternalStorageDirectory();
        String downloadPath = "${directory?.path}/$fileName";

        await dio.download(
          url,
          downloadPath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                progress = "${((received / total) * 100).toStringAsFixed(0)}%";
              });
            }
          },
        );

        setState(() {
          isDownloading = false;
          progress = "Download Completed";
          downloadedVideos.add(downloadPath);
        });

        await saveDownloadedVideos(downloadedVideos);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Video downloaded to $downloadPath")),
        );
      } catch (e) {
        setState(() {
          isDownloading = false;
          progress = "Download Failed";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission is denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Downloader"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DownloadsScreen(videos: downloadedVideos),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isDownloading
                  ? null
                  : () {
                      String videoUrl =
                          "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
                      String fileName = "sample_video.mp4";
                      downloadVideo(videoUrl, fileName);
                    },
              child: Text(isDownloading ? "Downloading..." : "Download Video"),
            ),
            SizedBox(height: 20),
            Column(children: [
              // Icon(Icons.done),
              Text(progress),
            ])
          ],
        ),
      ),
    );
  }
}

// class DownloadsScreen extends StatelessWidget {
//   final List<String> videos;

//   DownloadsScreen({required this.videos});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Downloaded Videos"),
//       ),
//       body: videos.isEmpty
//           ? Center(
//               child: Text("No videos downloaded yet"),
//             )
//           : ListView.builder(
//               itemCount: videos.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text("Video ${index + 1}"),
//                   subtitle: Text(videos[index]),
//                   trailing: Icon(Icons.play_arrow),
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("Play Video: ${videos[index]}")),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
