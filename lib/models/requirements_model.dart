class RequirementsModel {
  int? totalRequirements;
  List<String>? requirements;
  String? message;
  int? status;
  int? validity;

  RequirementsModel(
      {this.totalRequirements,
      this.requirements,
      this.message,
      this.status,
      this.validity});

  RequirementsModel.fromJson(Map<String, dynamic> json) {
    totalRequirements = json['total_requirements'];
    requirements = json['requirements'].cast<String>();
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_requirements'] = totalRequirements;
    data['requirements'] = requirements;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}
