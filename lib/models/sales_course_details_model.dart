class SalesCourseDetailsModel {
  PaymentDetails? paymentDetails;
  String? paymentDate;
  String? courseTitle;
  String? enrolledStudent;
  String? message;
  int? status;
  int? validity;

  SalesCourseDetailsModel(
      {this.paymentDetails,
      this.paymentDate,
      this.courseTitle,
      this.enrolledStudent,
      this.message,
      this.status,
      this.validity});

  SalesCourseDetailsModel.fromJson(Map<String, dynamic> json) {
    paymentDetails = json['payment_details'] != null
        ? PaymentDetails.fromJson(json['payment_details'])
        : null;
    paymentDate = json['payment_date'];
    courseTitle = json['course_title'];
    enrolledStudent = json['enrolled_student'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentDetails != null) {
      data['payment_details'] = paymentDetails!.toJson();
    }
    data['payment_date'] = paymentDate;
    data['course_title'] = courseTitle;
    data['enrolled_student'] = enrolledStudent;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class PaymentDetails {
  String? id;
  String? userId;
  String? paymentType;
  String? courseId;
  String? amount;
  String? dateAdded;
  String? lastModified;
  String? adminRevenue;
  String? instructorRevenue;
  String? instructorPaymentStatus;
  String? transactionId;
  String? sessionId;
  String? coupon;

  PaymentDetails(
      {this.id,
      this.userId,
      this.paymentType,
      this.courseId,
      this.amount,
      this.dateAdded,
      this.lastModified,
      this.adminRevenue,
      this.instructorRevenue,
      this.instructorPaymentStatus,
      this.transactionId,
      this.sessionId,
      this.coupon});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    paymentType = json['payment_type'];
    courseId = json['course_id'];
    amount = json['amount'];
    dateAdded = json['date_added'];
    lastModified = json['last_modified'];
    adminRevenue = json['admin_revenue'];
    instructorRevenue = json['instructor_revenue'];
    instructorPaymentStatus = json['instructor_payment_status'];
    transactionId = json['transaction_id'];
    sessionId = json['session_id'];
    coupon = json['coupon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['payment_type'] = paymentType;
    data['course_id'] = courseId;
    data['amount'] = amount;
    data['date_added'] = dateAdded;
    data['last_modified'] = lastModified;
    data['admin_revenue'] = adminRevenue;
    data['instructor_revenue'] = instructorRevenue;
    data['instructor_payment_status'] = instructorPaymentStatus;
    data['transaction_id'] = transactionId;
    data['session_id'] = sessionId;
    data['coupon'] = coupon;
    return data;
  }
}
