class FamilyContributionModel {
  final int id;
  final String? contributionCode;
  final String familyName;
  final String contributionName;
  final String? category;
  final String amount;
  final String status;
  final String billMonth;
  final int? familyId;
  final int? contributionId;
  final String? address;
  final bool? familyStatus;
  final String? paymentMethod;
  final String? paymentProof;
  final String? paymentReceipt;
  final String? recordStatus;
  final String? verifiedAt;
  final String? rejectedReason;

  FamilyContributionModel({
    required this.id,
    this.contributionCode,
    required this.familyName,
    required this.contributionName,
    this.category,
    required this.amount,
    required this.status,
    required this.billMonth,
    this.familyId,
    this.contributionId,
    this.address,
    this.familyStatus,
    this.paymentMethod,
    this.paymentProof,
    this.paymentReceipt,
    this.recordStatus,
    this.verifiedAt,
    this.rejectedReason,
  });

  bool get isPaid => status == 'approved' || status == 'paid';
  bool get isPending => status == 'pending';
  bool get isUnpaid => status == 'unpaid';
  bool get isWaitingApproval =>
      status == 'waiting_approval' || status == 'pending_verificator';

  factory FamilyContributionModel.fromJson(Map<String, dynamic> json) {
    return FamilyContributionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      contributionCode: json['contribution_code'] as String?,
      familyName:
          json['family_name'] as String? ?? json['family'] as String? ?? '',
      contributionName:
          json['name'] as String? ?? json['contribution_name'] as String? ?? '',
      category: json['category'] as String?,
      amount: json['amount']?.toString() ?? '0',
      status: json['status'] as String? ?? 'unpaid',
      billMonth:
          json['period'] as String? ??
          json['bill_month'] as String? ??
          json['month'] as String? ??
          '',
      familyId: (json['family_id'] as num?)?.toInt(),
      contributionId: (json['contribution_id'] as num?)?.toInt(),
      address: json['address'] as String?,
      familyStatus: json['family_status'] is bool
          ? json['family_status'] as bool
          : null,
      paymentMethod: json['payment_method'] as String?,
      paymentProof:
          json['payment_proof'] as String? ?? json['latest_proof'] as String?,
      paymentReceipt: json['payment_receipt'] as String?,
      recordStatus: json['record_status'] as String?,
      verifiedAt: json['verified_at'] as String?,
      rejectedReason: json['rejected_reason'] as String?,
    );
  }
}
