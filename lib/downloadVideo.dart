// import 'package:dodwnload_video/model/video.dart';
// import 'package:dodwnload_video/playerScreen.dart';
// import 'package:flutter/material.dart';

// class DownloadsScreen extends StatefulWidget {
//   final List<String> videos;

//   DownloadsScreen({required this.videos});

//   @override
//   State<DownloadsScreen> createState() => _DownloadsScreenState();
// }

// class _DownloadsScreenState extends State<DownloadsScreen> {
//   late List<String> video;
//   @override
//   void initState() {
//     video = widget.videos;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Downloaded Videos"),
//       ),
//       body: widget.videos.isEmpty
//           ? Center(
//               child: Text("No videos downloaded yet"),
//             )
//           : ListView.builder(
//               itemCount: widget.videos.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => VideoPlayerScreen(
//                           fullscreen: true,
//                           videoPath: widget.videos[index],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Dismissible(
//                     key: key(widget.videos[index]),
//                     direction: DismissDirection.endToStart,
//                     confirmDismiss: (direction) {
//                       return showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text("Confirm Deletion"),
//                               content: Text("are  sure to delete "),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(false);
//                                     },
//                                     child: Text("cancel")),
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(true);
//                                     },
//                                     child: Text("delete")),
//                               ],
//                             );
//                           });
//                     },
//                     onDismissed: (direction) {
//                       widget.videos.removeAt(index);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("deleted vedio")));
//                     },
//                     child: Card(
//                       child: ListTile(
//                         // title: Text("Video ${index + 1}"),
//                         title: Text("Video ${index + 1}"),
//                         subtitle: Text(widget.videos[index]),
//                         trailing: Column(
//                           children: [
//                             Icon(Icons.play_arrow),
//                           ],
//                         ),
//                         onTap: () {
//                           // Halkan waxaad ku dari kartaa video player-kaaga.
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => VideoPlayerScreen(
//                                 fullscreen: true,
//                                 videoPath: widget.videos[index],
//                               ),
//                             ),
//                           );

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Play Video Success")),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:dodwnload_video/model/video.dart';
import 'package:dodwnload_video/playerScreen.dart';
import 'package:flutter/material.dart';

class DownloadsScreen extends StatefulWidget {
  final List<String> videos;

  DownloadsScreen({required this.videos});

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  // late List<String> videos;

  // @override
  // void initState() {
  //   super.initState();
  //   videos = widget.videos; // Initialize the local videos list
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloaded Videos"),
      ),
      body: widget.videos.isEmpty
          ? Center(
              child: Text("No videos downloaded yet"),
            )
          : ListView.builder(
              itemCount: widget.videos.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(widget.videos[index]), // Unique key for each video
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirm Deletion"),
                          content: Text(
                              "Are you sure you want to delete this video?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(false); // Cancel deletion
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true); // Confirm deletion
                              },
                              child: Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                    return result == true; // Return true to delete the item
                  },
                  onDismissed: (direction) {
                    setState(() {
                      videos.removeAt(index); // Remove the video from the list
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Video deleted")),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text("Video ${index + 1}"),
                      subtitle: Text(widget.videos[index]),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              fullscreen: true,
                              videoPath: widget.videos[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
