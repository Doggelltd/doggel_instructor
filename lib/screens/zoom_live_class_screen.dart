// // ignore_for_file: use_build_context_synchronously

// import 'package:doggel_instructor/constants.dart';
// import 'package:doggel_instructor/models/common_functions.dart';
// import 'package:doggel_instructor/models/live_class.dart';
// import 'package:doggel_instructor/models/zoom_settings.dart';
// import 'package:doggel_instructor/providers/fetch_data.dart';
// import 'package:doggel_instructor/providers/shared_pref_helper.dart';
// import 'package:doggel_instructor/widgets/custom_app_bar.dart';
// import 'package:doggel_instructor/widgets/start_meeting_widget.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class ZoomLiveClassScreen extends StatefulWidget {
//   final String courseId;
//   const ZoomLiveClassScreen({Key? key, required this.courseId})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ZoomLiveClassScreenState createState() => _ZoomLiveClassScreenState();
// }

// class _ZoomLiveClassScreenState extends State<ZoomLiveClassScreen> {
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   bool _isInit = true;
//   bool _isLoading = false;
//   LiveClass liveClass = LiveClass();
//   ZoomSettings zoomSettings = ZoomSettings();

//   final dateController = TextEditingController();
//   final timeController = TextEditingController();
//   final noteController = TextEditingController();
//   final idController = TextEditingController();
//   final passwordController = TextEditingController();

//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   final dateView = DateFormat('dd/MM/yy');
//   final timeView = DateFormat('hh:mm a');
//   dynamic date;
//   dynamic time;

//   Future<void> _selectdate(BuildContext context) async {
//     final DateTime? seldate = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2090),
//         builder: (context, child) {
//           return SingleChildScrollView(
//             child: child,
//           );
//         });
//     if (seldate != null) {
//       setState(() {
//         selectedDate = seldate;
//         dateController.text =
//             DateFormat('dd-MM-yyyy').format(selectedDate).toString();
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? timeOfDay = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//       initialEntryMode: TimePickerEntryMode.dial,
//     );
//     if (timeOfDay != null && timeOfDay != selectedTime) {
//       setState(() {
//         selectedTime = timeOfDay;
//         timeController.text = selectedTime.format(context);
//       });
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       Provider.of<FetchData>(context)
//           .fetchZoomLiveClassDetails(widget.courseId)
//           .then((_) {
//         setState(() {
//           liveClass = Provider.of<FetchData>(context, listen: false).liveClass;
//         });
//         if (liveClass.courseId == widget.courseId) {
//           final dateView = DateFormat('dd-MM-yyyy');
//           date = dateView.format(DateTime.fromMillisecondsSinceEpoch(
//               int.parse(liveClass.date!) * 1000));

//           dateController.text = date;
//           time = timeView.format(DateTime.fromMillisecondsSinceEpoch(
//               int.parse(liveClass.time!) * 1000));
//           timeController.text = time;
//           noteController.text = '${liveClass.noteToStudents}';
//           idController.text = '${liveClass.zoomMeetingId}';
//           passwordController.text = '${liveClass.zoomMeetingPassword}';
//         } else {
//           dateController.text =
//               DateFormat('dd-MM-yyyy').format(selectedDate).toString();
//           timeController.text = selectedTime.format(context);
//         }
//       });
//       Provider.of<FetchData>(context).fetchZoomSettings().then((_) {
//         setState(() {
//           zoomSettings =
//               Provider.of<FetchData>(context, listen: false).zoomSettings;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   Future<void> _submit() async {
//     final token = await SharedPreferenceHelper().getAuthToken();
//     if (!globalFormKey.currentState!.validate()) {
//       // Invalid!
//       return;
//     }
//     globalFormKey.currentState!.save();
//     setState(() {
//       _isLoading = true;
//     });
//     const url = "$BASE_URL/api_instructor/save_live_class_data";
//     try {
//       FormData formData = FormData.fromMap({
//         'auth_token': token,
//         'course_id': widget.courseId,
//         'date': dateController.text,
//         'time': timeController.text,
//         'note_to_students': noteController.text,
//         'zoom_meeting_id': idController.text,
//         'zoom_meeting_password': passwordController.text,
//       });

//       await Dio().post(url, data: formData);

//       setState(() {
//         _isLoading = false;
//       });

//       Navigator.of(context).pop();
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return ZoomLiveClassScreen(courseId: widget.courseId);
//       }));

//       CommonFunctions.showSuccessToast('Live class updated Successfully');
//     } catch (error) {
//       const errorMsg = 'Update failed!';
//       CommonFunctions.showErrorDialog(errorMsg, context);
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   InputDecoration getInputDecoration(String hintext, IconData iconData) {
//     return InputDecoration(
//       enabledBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         borderSide: BorderSide(color: Colors.white),
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         borderSide: BorderSide(color: Color(0xFF3862FD)),
//       ),
//       focusedErrorBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         borderSide: BorderSide(color: Color(0xFFF65054)),
//       ),
//       errorBorder: const OutlineInputBorder(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         borderSide: BorderSide(color: Color(0xFFF65054)),
//       ),
//       filled: true,
//       hintStyle: const TextStyle(color: kTextColor),
//       hintText: hintext,
//       fillColor: Colors.white,
//       prefixIcon: Icon(
//         iconData,
//         color: const Color(0xFFc7c8ca),
//       ),
//       contentPadding: const EdgeInsets.symmetric(vertical: 17),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: CustomAppBar(),
//       backgroundColor: kBackgroundColor,
//       body: SingleChildScrollView(
//         child: Form(
//           key: globalFormKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 // height: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Live class schedule (Date)',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: InkWell(
//                               onTap: () => _selectdate(context),
//                               child: Card(
//                                 elevation: 0.5,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 14, horizontal: 10),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.wb_sunny_outlined,
//                                         color: Color(0xFFc7c8ca),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Text(
//                                           dateController.text,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Card(
//                               elevation: 0.5,
//                               color: kGreenColor,
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 14),
//                                 child: IconButton(
//                                   padding: EdgeInsets.zero,
//                                   constraints: const BoxConstraints(),
//                                   onPressed: () => _selectdate(context),
//                                   icon: const Icon(
//                                     Icons.calendar_today_outlined,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 5.0,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Live class schedule (Time)',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: InkWell(
//                               onTap: () => _selectTime(context),
//                               child: Card(
//                                 elevation: 0.5,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 14, horizontal: 10),
//                                   child: Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.access_time,
//                                         color: Color(0xFFc7c8ca),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: Text(
//                                           timeController.text,
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Card(
//                               elevation: 0.5,
//                               color: kGreenColor,
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 14),
//                                 child: IconButton(
//                                   padding: EdgeInsets.zero,
//                                   constraints: const BoxConstraints(),
//                                   onPressed: () => _selectTime(context),
//                                   icon: const Icon(
//                                     Icons.access_time,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 5.0,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Note to students',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         decoration: getInputDecoration(
//                           'Note for students.',
//                           Icons.edit_outlined,
//                         ),
//                         keyboardType: TextInputType.text,
//                         controller: noteController,
//                         onSaved: (value) {
//                           setState(() {
//                             noteController.text = value!;
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 5.0,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Zoom meeting id',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         decoration: getInputDecoration(
//                           'Meeting id',
//                           Icons.video_call_outlined,
//                         ),
//                         keyboardType: TextInputType.text,
//                         controller: idController,
//                         // ignore: missing_return
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Meeting id can't be empty.";
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           setState(() {
//                             idController.text = value!;
//                           });
//                         },
//                       ),
//                       const SizedBox(
//                         height: 5.0,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(4.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Zoom meeting password',
//                             style: TextStyle(
//                               color: kTextColor,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       TextFormField(
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         decoration: getInputDecoration(
//                           'Meeting password.',
//                           Icons.lock_outlined,
//                         ),
//                         keyboardType: TextInputType.text,
//                         controller: passwordController,
//                         // ignore: missing_return
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Zoom meeting password can't be empty.";
//                           }
//                           return null;
//                         },
//                         onSaved: (value) {
//                           setState(() {
//                             passwordController.text = value!;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: MaterialButton(
//                     onPressed: _submit,
//                     color: kGreenColor,
//                     textColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 10),
//                     splashColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       side: const BorderSide(color: kGreenColor),
//                     ),
//                     child: _isLoading
//                         ? const SizedBox(
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           )
//                         : const Text(
//                             'Update Settings',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 16),
//                           ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                   child: MaterialButton(
//                     onPressed: () {
//                       zoomSettings.status == 200
//                           ? Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                               return StartMeetingWidget(
//                                 sdkKey: zoomSettings.sdkKey,
//                                 sdkSecret: zoomSettings.sdkSecretKey,
//                                 email: zoomSettings.email,
//                                 password: zoomSettings.password,
//                                 instructorName: zoomSettings.instructorName,
//                                 meetingId: idController.text,
//                                 meetingPassword: passwordController.text,
//                               );
//                             }))
//                           : ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text(
//                                       'Configure the Zoom settings first to start the mettings.')));
//                       // : CommonFunctions.showSuccessToast(
//                       //     'Configure the Zoom settings first to start the mettings');
//                     },
//                     color: kGreenColor,
//                     textColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 15, vertical: 10),
//                     splashColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       side: const BorderSide(color: kGreenColor),
//                     ),
//                     child: const Text(
//                       'Start Meeting',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
