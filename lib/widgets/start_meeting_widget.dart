// // ignore_for_file: avoid_print, duplicate_ignore, no_leading_underscores_for_local_identifiers
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_sdk/zoom_options.dart';
// import 'package:flutter_zoom_sdk/zoom_view.dart';
// import '../constants.dart';

// class StartMeetingWidget extends StatefulWidget {
//   final String? meetingId;
//   final String? meetingPassword;
//   final String? sdkKey;
//   final String? sdkSecret;
//   final String? email;
//   final String? password;
//   final String? instructorName;
//   const StartMeetingWidget(
//       {Key? key,
//       this.meetingId,
//       this.meetingPassword,
//       this.sdkKey,
//       this.sdkSecret,
//       this.email,
//       this.password,
//       this.instructorName})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _StartMeetingWidgetState createState() => _StartMeetingWidgetState();
// }

// class _StartMeetingWidgetState extends State<StartMeetingWidget> {
//   late Timer timer;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kBackgroundColor,
//         elevation: 0,
//         title: const Text(
//           'Loading meeting',
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: startMeetingNormal(context),
//     );
//   }

//   //Start Meeting With Custom Meeting ID ----- Emila & Password For Zoom is required.
//   startMeetingNormal(BuildContext context) {
//     bool _isMeetingEnded(String status) {
//       var result = false;

//       if (Platform.isAndroid) {
//         result = status == "MEETING_STATUS_DISCONNECTING" ||
//             status == "MEETING_STATUS_FAILED";
//       } else {
//         result = status == "MEETING_STATUS_IDLE";
//       }

//       return result;
//     }

//     ZoomOptions zoomOptions = ZoomOptions(
//       domain: "zoom.us",
//       appKey: widget.sdkKey, //API SDK KEY FROM ZOOM
//       appSecret: widget.sdkSecret, //API SDK SECRET FROM ZOOM
//     );
//     var meetingOptions = ZoomMeetingOptions(
//         userId: widget.email, //pass host email for zoom
//         userPassword: widget.password, //pass host password for zoom
//         displayName: widget.instructorName,
//         meetingId: widget.meetingId,
//         meetingPassword: widget.meetingPassword,
//         disableDialIn: "false",
//         disableDrive: "false",
//         disableInvite: "false",
//         disableShare: "false",
//         disableTitlebar: "false",
//         viewOptions: "false",
//         noAudio: "false",
//         noDisconnectAudio: "false");

//     var zoom = ZoomView();
//     zoom.initZoom(zoomOptions).then((results) {
//       if (results[0] == 0) {
//         zoom.onMeetingStatus().listen((status) {
//           // print("${"[Meeting Status Stream] : " + status[0]} - " + status[1]);
//           if (_isMeetingEnded(status[0])) {
//             print("[Meeting Status] :- Ended");
//             timer.cancel();
//           }
//           if (status[0] == "MEETING_STATUS_INMEETING") {
//             zoom.meetinDetails().then((meetingDetailsResult) {
//               print("[MeetingDetailsResult] :- $meetingDetailsResult");
//             });
//           }
//         });
//         zoom.startMeetingNormal(meetingOptions).then((loginResult) {
//           print("[LoginResult] :- $loginResult");
//           if (loginResult[0] == "SDK ERROR") {
//             //SDK INIT FAILED
//             print((loginResult[1]).toString());
//           } else if (loginResult[0] == "LOGIN ERROR") {
//             //LOGIN FAILED - WITH ERROR CODES
//             print((loginResult[1]).toString());
//           } else {
//             //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
//             print((loginResult[0]).toString());
//           }
//         });
//       }
//     }).catchError((error) {
//       // print("[Error Generated] : " + error);
//     });
//   }

// }
