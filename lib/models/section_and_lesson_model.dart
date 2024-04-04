class SectionAndLessonModel {
  List<SectionAndLesson>? sectionAndLesson;
  String? courseId;
  String? message;
  int? status;
  int? validity;

  SectionAndLessonModel(
      {this.sectionAndLesson,
      this.courseId,
      this.message,
      this.status,
      this.validity});

  SectionAndLessonModel.fromJson(Map<String, dynamic> json) {
    if (json['section_and_lesson'] != null) {
      sectionAndLesson = <SectionAndLesson>[];
      json['section_and_lesson'].forEach((v) {
        sectionAndLesson!.add(SectionAndLesson.fromJson(v));
      });
    }
    courseId = json['course_id'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sectionAndLesson != null) {
      data['section_and_lesson'] =
          sectionAndLesson!.map((v) => v.toJson()).toList();
    }
    data['course_id'] = courseId;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class SectionAndLesson {
  String? id;
  String? title;
  List<Lessons>? lessons;

  SectionAndLesson({this.id, this.title, this.lessons});

  SectionAndLesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(Lessons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lessons {
  String? id;
  String? videoType;
  String? lessonType;
  String? attachmentType;
  String? title;

  Lessons(
      {this.id,
      this.videoType,
      this.lessonType,
      this.attachmentType,
      this.title});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoType = json['video_type'];
    lessonType = json['lesson_type'];
    attachmentType = json['attachment_type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['video_type'] = videoType;
    data['lesson_type'] = lessonType;
    data['attachment_type'] = attachmentType;
    data['title'] = title;
    return data;
  }
}
