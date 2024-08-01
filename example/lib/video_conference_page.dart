// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

import 'constants.dart';

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  const VideoConferencePage({
    super.key,
    required this.conferenceID,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: yourAppID /*input your AppID*/,
        appSign: yourAppSign /*input your AppSign*/,
        userID: localUserID,
        userName: "user_$localUserID",
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          // customButtonChat: const CustomChatButton(),
          customChatList: (context, scrollController) => Container(
            alignment: Alignment.center,
            child: const Text(
              "Custom Chat List",
              style: TextStyle(color: Colors.white),
            ),
          ),
          avatarBuilder: (context, size, user, extraInfo) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(size.width / 2),
            ),
            child: Center(
              child: Text(
                user?.id ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const yourAppID = 1559834670;
const yourAppSign =
    "b5ecbeb473f51ba7c0868ce00fb584d6568f9f1048bb21f643256c19d46f2160";

const auth =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NTQ5NCwidXNlcl9pZCI6IjU0OTQiLCJjcmVhdGVkIjoxNzIyMzYyMTIyOTk0LCJyZWZyZXNoQ291bnQiOjAsInJzdCI6IjMyN2E1YzkwNWViNmM2MjBkMDk3YmQ5NjJhZDMyNDdlIiwiZXhwIjoxNzI0OTU0MTIyfQ.sOxuUUT6FM2NyJo82_myj7m55dUiMDAkd7gE-xYM6zY";
