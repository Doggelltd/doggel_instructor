import 'package:doggel_instructor/constants.dart';
import 'package:doggel_instructor/screens/document_lesson_edit.dart';
import 'package:doggel_instructor/screens/google_drive_lesson_edit.dart';
import 'package:doggel_instructor/screens/iframe_lesson_edit_form.dart';
import 'package:doggel_instructor/screens/image_lesson__edit.dart';
import 'package:doggel_instructor/screens/text_lesson_edit.dart';
import 'package:doggel_instructor/screens/video_url_lesson_edit.dart';
import 'package:doggel_instructor/screens/youtube_vimeo_lesson_edit.dart';
import 'package:doggel_instructor/screens/video_file_lesson_edit.dart';
import 'package:doggel_instructor/screens/lesson_sort_screen.dart';
import 'package:doggel_instructor/widgets/section_edit_widget.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import 'lesson_error_dialog.dart';

class CourseDetailListItem extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String sectionId;
  final String sectionTitle;
  final List lessons;
  final String token;

  const CourseDetailListItem({
    Key? key,
    required this.courseId,
    required this.courseTitle,
    required this.sectionId,
    required this.sectionTitle,
    required this.lessons,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: kPrimaryColor,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(sectionTitle),
                  ),
                ),
                PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditSectionWidget(
                              courseId: courseId,
                              courseTitle: courseTitle,
                              sectionId: sectionId,
                              sectionTitle: sectionTitle);
                        }));
                      } else {
                        if (lessons.isNotEmpty) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LessonSortScreen(
                                lessons: lessons,
                                courseId: courseId,
                                courseTitle: courseTitle);
                          }));
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => const LessonErrorDialog(),
                          );
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: kIconColor,
                    ),
                    itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'sort',
                            child: Text('Sort lessons'),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit section'),
                          ),
                        ]),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lessons.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var unescape = HtmlUnescape();
                        var lessonTitle =
                            unescape.convert(lessons[index].title);
                        return Card(
                          elevation: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(lessonTitle),
                                ),
                              ),
                              IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: kIconColor,
                                  ),
                                  onPressed: () {
                                    if (lessons[index].videoType == "YouTube" ||
                                        lessons[index].videoType == "Vimeo") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return YoutubeVimeoEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].videoType ==
                                        "google_drive") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return GoogleDriveLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].videoType ==
                                        "html5") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return VideoUrlLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].lessonType ==
                                        "text") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return TextLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].videoType ==
                                        "system") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return VideoFileLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].attachmentType ==
                                        "img") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ImageLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].attachmentType ==
                                        "iframe") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return IframeLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    } else if (lessons[index].lessonType ==
                                        "other") {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return DocumentLessonEditScreen(
                                          lessonId: lessons[index].id,
                                          courseId: courseId,
                                          courseTitle: courseTitle,
                                          sectionId: sectionId,
                                          sectionTitle: sectionTitle,
                                        );
                                      }));
                                    }
                                  }),
                            ],
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
