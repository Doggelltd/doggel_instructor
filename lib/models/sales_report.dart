class SalesReport {
  String? id;
  String? userId;
  String? paymentType;
  String? courseId;
  String? amount;
  String? dateAdded;
  String? adminRevenue;
  String? instructorRevenue;
  String? instructorPaymentStatus;
  String? transactionId;
  String? sessionId;
  String? coupon;

  SalesReport(
      {this.id,
      this.userId,
      this.paymentType,
      this.courseId,
      this.amount,
      this.dateAdded,
      this.adminRevenue,
      this.instructorRevenue,
      this.instructorPaymentStatus,
      this.transactionId,
      this.sessionId,
      this.coupon});
}
