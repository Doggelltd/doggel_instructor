class CourseModel {
  List<Categories>? categories;
  List<Languages>? languages;
  String? title;
  String? shortDescription;
  String? description;
  String? subCategoryId;
  String? level;
  String? language;
  String? courseOverviewProvider;
  String? videoUrl;
  String? isTopCourse;
  String? theme;
  CourseMediaImages? courseMediaImages;
  String? metaKeywords;
  String? metaDescription;
  int? status;
  int? validity;
  String? message;

  CourseModel(
      {this.categories,
      this.languages,
      this.title,
      this.shortDescription,
      this.description,
      this.subCategoryId,
      this.level,
      this.language,
      this.courseOverviewProvider,
      this.videoUrl,
      this.isTopCourse,
      this.theme,
      this.courseMediaImages,
      this.metaKeywords,
      this.metaDescription,
      this.status,
      this.validity,
      this.message});

  CourseModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    subCategoryId = json['sub_category_id'];
    level = json['level'];
    language = json['language'];
    courseOverviewProvider = json['course_overview_provider'];
    videoUrl = json['video_url'];
    isTopCourse = json['is_top_course'];
    theme = json['theme'];
    courseMediaImages = json['course_media_images'] != null
        ? CourseMediaImages.fromJson(json['course_media_images'])
        : null;
    metaKeywords = json['meta_keywords'];
    metaDescription = json['meta_description'];
    status = json['status'];
    validity = json['validity'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['sub_category_id'] = subCategoryId;
    data['level'] = level;
    data['language'] = language;
    data['course_overview_provider'] = courseOverviewProvider;
    data['video_url'] = videoUrl;
    data['is_top_course'] = isTopCourse;
    data['theme'] = theme;
    if (courseMediaImages != null) {
      data['course_media_images'] = courseMediaImages!.toJson();
    }
    data['meta_keywords'] = metaKeywords;
    data['meta_description'] = metaDescription;
    data['status'] = status;
    data['validity'] = validity;
    data['message'] = message;
    return data;
  }
}

class Categories {
  String? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Languages {
  String? name;

  Languages({this.name});

  Languages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class CourseMediaImages {
  String? courseThumbnail;
  String? courseBanner;
  String? courseSliderThumbnail;
  String? courseSliderBanner;

  CourseMediaImages(
      {this.courseThumbnail,
      this.courseBanner,
      this.courseSliderThumbnail,
      this.courseSliderBanner});

  CourseMediaImages.fromJson(Map<String, dynamic> json) {
    courseThumbnail = json['course_thumbnail'];
    courseBanner = json['course_banner'];
    courseSliderThumbnail = json['course_slider_thumbnail'];
    courseSliderBanner = json['course_slider_banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_thumbnail'] = courseThumbnail;
    data['course_banner'] = courseBanner;
    data['course_slider_thumbnail'] = courseSliderThumbnail;
    data['course_slider_banner'] = courseSliderBanner;
    return data;
  }
}
