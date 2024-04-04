class PayoutReportModel {
  List<Payouts>? payouts;
  int? totalPendingAmoun;
  int? totalPayoutAmount;
  String? requestedWithdrawalAmount;
  String? message;
  int? status;
  int? validity;

  PayoutReportModel(
      {this.payouts,
      this.totalPendingAmoun,
      this.totalPayoutAmount,
      this.requestedWithdrawalAmount,
      this.message,
      this.status,
      this.validity});

  PayoutReportModel.fromJson(Map<String, dynamic> json) {
    if (json['payouts'] != null) {
      payouts = <Payouts>[];
      json['payouts'].forEach((v) {
        payouts!.add(Payouts.fromJson(v));
      });
    }
    totalPendingAmoun = json['total_pending_amoun'];
    totalPayoutAmount = json['total_payout_amount'];
    requestedWithdrawalAmount = json['requested_withdrawal_amount'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payouts != null) {
      data['payouts'] = payouts!.map((v) => v.toJson()).toList();
    }
    data['total_pending_amoun'] = totalPendingAmoun;
    data['total_payout_amount'] = totalPayoutAmount;
    data['requested_withdrawal_amount'] = requestedWithdrawalAmount;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}

class Payouts {
  String? id;
  String? userId;
  String? paymentType;
  String? amount;
  String? dateAdded;
  String? lastModified;
  String? status;

  Payouts(
      {this.id,
      this.userId,
      this.paymentType,
      this.amount,
      this.dateAdded,
      this.lastModified,
      this.status});

  Payouts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    paymentType = json['payment_type'];
    amount = json['amount'];
    dateAdded = json['date_added'];
    lastModified = json['last_modified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['payment_type'] = paymentType;
    data['amount'] = amount;
    data['date_added'] = dateAdded;
    data['last_modified'] = lastModified;
    data['status'] = status;
    return data;
  }
}
