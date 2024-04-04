class LessonModel {
  LessonDetails? lessonDetails;
  String? message;
  int? status;
  int? validity;

  LessonModel({this.lessonDetails, this.message, this.status, this.validity});

  LessonModel.fromJson(Map<String, dynamic> json) {
    lessonDetails = json['lesson_details'] != null
        ? LessonDetails.fromJson(json['lesson_details'])
        : null;
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lessonDetails != null) {
      data['lesson_details'] = lessonDetails!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class LessonDetails {
  String? id;
  String? title;
  String? duration;
  String? courseId;
  String? sectionId;
  String? videoType;
  String? videoUrl;
  String? dateAdded;
  String? lastModified;
  String? lessonType;
  String? attachment;
  String? attachmentType;
  String? summary;
  String? order;
  String? videoTypeForMobileApplication;
  String? videoUrlForMobileApplication;
  String? durationForMobileApplication;
  String? isFree;

  LessonDetails(
      {this.id,
      this.title,
      this.duration,
      this.courseId,
      this.sectionId,
      this.videoType,
      this.videoUrl,
      this.dateAdded,
      this.lastModified,
      this.lessonType,
      this.attachment,
      this.attachmentType,
      this.summary,
      this.order,
      this.videoTypeForMobileApplication,
      this.videoUrlForMobileApplication,
      this.durationForMobileApplication,
      this.isFree});

  LessonDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    courseId = json['course_id'];
    sectionId = json['section_id'];
    videoType = json['video_type'];
    videoUrl = json['video_url'];
    dateAdded = json['date_added'];
    lastModified = json['last_modified'];
    lessonType = json['lesson_type'];
    attachment = json['attachment'];
    attachmentType = json['attachment_type'];
    summary = json['summary'];
    order = json['order'];
    videoTypeForMobileApplication = json['video_type_for_mobile_application'];
    videoUrlForMobileApplication = json['video_url_for_mobile_application'];
    durationForMobileApplication = json['duration_for_mobile_application'];
    isFree = json['is_free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['course_id'] = courseId;
    data['section_id'] = sectionId;
    data['video_type'] = videoType;
    data['video_url'] = videoUrl;
    data['date_added'] = dateAdded;
    data['last_modified'] = lastModified;
    data['lesson_type'] = lessonType;
    data['attachment'] = attachment;
    data['attachment_type'] = attachmentType;
    data['summary'] = summary;
    data['order'] = order;
    data['video_type_for_mobile_application'] = videoTypeForMobileApplication;
    data['video_url_for_mobile_application'] = videoUrlForMobileApplication;
    data['duration_for_mobile_application'] = durationForMobileApplication;
    data['is_free'] = isFree;
    return data;
  }
}
