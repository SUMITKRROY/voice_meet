import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Fill in the app ID obtained from the Agora console
const appId = "2d6ab14ac0ae4d2380c2b493dc7fed7c";
// Fill in the temporary token generated using Agora console
const token =
    "007eJxTYPjuc2F1x79Qg/meTexOJwO8VRW9VX6tPNmf5Lug2FMga7MCg1GKWWKSoUliskFiqkmKkbGFQbJRkomlcUqyeVpqinnyphf+6Q2BjAyxOzawMjJAIIjPwVCSWlwSn51aycAAAM6pIaw=";
// Fill in the channel name
const channel = "test_key";

// Application class
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({Key? key}) : super(key: key);

  @override
  _VoiceChatScreenState createState() => _VoiceChatScreenState();
}

// Application state class
class _VoiceChatScreenState extends State<VoiceChatScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  // Initialize Agora and setup audio profile
  Future<void> initAgora() async {
    // Request microphone permission
    await [Permission.microphone].request();

    // Create RtcEngine instance
    _engine = await createAgoraRtcEngine();

    // Initialize the engine
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Set the audio profile to balance quality and latency
    // await _engine.setAudioProfile(
    //   AudioProfileType.defaultAudioProfile,
    //   AudioScenarioType.audioScenarioChatRoomEntertainment,
    // );

    // Handle engine events
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint('Local user ${connection.localUid} joined');
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    // Join the channel with the token and options
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0, // Let Agora assign a random UID if set to 0
    );
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  // Cleanup after leaving the channel
  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Voice Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _localUserJoined
                ? Text('You have joined the channel.')
                : Text('Waiting to join the channel...'),
            if (_remoteUid != null)
              Text('Remote user $_remoteUid is in the channel.'),
            ElevatedButton(
              onPressed: _dispose,
              child: Text('Leave Channel'),
            ),
          ],
        ),
      ),
    );
  }
}
