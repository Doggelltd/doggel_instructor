// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/screens/google_drive_video_add_form.dart';
import 'package:doggel_instructor/screens/iframe_add_form.dart';
import 'package:doggel_instructor/screens/image_add_form.dart';
import 'package:doggel_instructor/screens/youtube_vimeo_add_form.dart';
import 'package:doggel_instructor/screens/document_add_form.dart';
import 'package:doggel_instructor/screens/video_file_add_form.dart';
import 'package:doggel_instructor/screens/text_add_form.dart';
import 'package:doggel_instructor/screens/video_url_add_form.dart';
import 'package:flutter/material.dart';

enum SingingCharacter {
  youtube,
  vimeo,
  videoFile,
  videoUrl,
  googleDriveVideo,
  document,
  text,
  imageFile,
  iframe
}

class LessonAddDialog extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const LessonAddDialog(
      {Key? key, required this.courseId, required this.courseTitle})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LessonAddDialogState createState() => _LessonAddDialogState();
}

class _LessonAddDialogState extends State<LessonAddDialog> {
  SingingCharacter _character = SingingCharacter.youtube;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: const Text(
          'Add New Lesson',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Lesson Type",
                style: TextStyle(fontSize: 18),
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Youtube Video',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.youtube,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Vimeo Video',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.vimeo,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Video File',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.videoFile,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Video Url [.mp4]',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.videoUrl,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Google drive video',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.googleDriveVideo,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Document',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.document,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Text',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.text,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Iframe embed',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.iframe,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              RadioListTile<SingingCharacter>(
                title: const Text(
                  'Image file',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: Colors.black45),
                ),
                dense: true,
                value: SingingCharacter.imageFile,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value!;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  elevation: 0.1,
                  onPressed: () async {
                    dynamic authToken =
                        await SharedPreferenceHelper().getAuthToken();
                    Navigator.of(context).pop();
                    if (_character.toString() == "SingingCharacter.videoFile") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VideoFileAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.videoUrl") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return VideoUrlAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.document") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DocumentAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle,
                            token: authToken);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.googleDriveVideo") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GoogleDriveVideoAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.text") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TextAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.iframe") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return IframeAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else if (_character.toString() ==
                        "SingingCharacter.imageFile") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return YoutubeVimeoAddScreen(
                            type: _character,
                            courseId: widget.courseId,
                            courseTitle: widget.courseTitle);
                      }));
                    }
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: kGreenColor,
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: const BorderSide(color: kGreenColor),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
