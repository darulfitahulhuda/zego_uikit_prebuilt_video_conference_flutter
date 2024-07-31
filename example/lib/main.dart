import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference_example/video_conference_page.dart';

/// https://github.com/ZEGOCLOUD/zego_uikit_prebuilt_video_conference_example_flutter
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: VideoConferencePage(
        conferenceID: 'channel-2043397',
      ),
    ),
  );
}
