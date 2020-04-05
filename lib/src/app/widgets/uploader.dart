import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class Uploader extends StatefulWidget {
  final File file;
  final ValueChanged<StorageTaskSnapshot> updater;

  Uploader({Key key, this.file, this.updater}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://train-beers.appspot.com');
  StorageUploadTask _uploadTask;

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            /// If the parent widget has a listener, then call it with the new upload event data.
            if (_uploadTask.isComplete && widget.updater != null) {
              widget.updater(event);
            }

            return Column(
                children: [
                  Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) => _uploadTask.isComplete,
                    widgetBuilder: (BuildContext context) {
                      return Text('🎉🎉🎉');
                    },
                    fallbackBuilder: (BuildContext context) => null,
                  ),
                  Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) => _uploadTask.isPaused,
                    widgetBuilder: (BuildContext context) {
                      return FlatButton(
                        child: Icon(Icons.play_arrow),
                        onPressed: _uploadTask.resume,
                      );
                    },
                    fallbackBuilder: (BuildContext context) => null,
                  ),
                  Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) => _uploadTask.isInProgress,
                    widgetBuilder: (BuildContext context) {
                      return FlatButton(
                        child: Icon(Icons.pause),
                        onPressed: _uploadTask.pause,
                      );
                    },
                    fallbackBuilder: (BuildContext context) => null,
                  ),

                  // Progress bar
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % '
                  ),
                ].where((widget) => widget != null).toList(),
              );
          });
    } 
    else {
      // Allows user to decide when to start the upload
      return FlatButton.icon(
          label: Text('Upload to Firebase'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,
        );
    }
  }

  /// Starts an upload task
  void _startUpload() {
    /// Unique file name for the file
    String filePath = 'images/avatars/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }
}