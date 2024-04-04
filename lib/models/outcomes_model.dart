class OutcomesModel {
  int? totalOutcomes;
  List<String>? outcomes;
  String? message;
  int? status;
  int? validity;

  OutcomesModel(
      {this.totalOutcomes,
      this.outcomes,
      this.message,
      this.status,
      this.validity});

  OutcomesModel.fromJson(Map<String, dynamic> json) {
    totalOutcomes = json['total_outcomes'];
    outcomes = json['outcomes'].cast<String>();
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_outcomes'] = totalOutcomes;
    data['outcomes'] = outcomes;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}
