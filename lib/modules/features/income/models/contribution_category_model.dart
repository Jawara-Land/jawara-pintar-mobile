class ContributionCategoryModel {
  final int id;
  final String name;
  final bool? isRecurring;
  final int? amount;
  final String? category;
  final String? contributionCode;
  final String? period;
  final String? status;
  final String? familyName;
  final String? familyStatus;
  final String? paymentMethod;
  final String? paymentProof;
  final String? recordStatus;
  final String? paymentReceipt;
  final int? contributionCategoryId;

  ContributionCategoryModel({
    required this.id,
    required this.name,
    this.isRecurring,
    this.amount,
    this.category,
    this.contributionCode,
    this.period,
    this.status,
    this.familyName,
    this.familyStatus,
    this.paymentMethod,
    this.paymentProof,
    this.recordStatus,
    this.paymentReceipt,
    this.contributionCategoryId,
  });

  factory ContributionCategoryModel.fromJson(Map<String, dynamic> json) {
    return ContributionCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      isRecurring: json['is_recurring'] == 1 || json['is_recurring'] == true,
      amount: (json['amount'] as num?)?.toInt(),
      category: json['category'] as String?,
      contributionCode: json['contribution_code'] as String?,
      period: json['period'] as String?,
      status: json['status'] as String?,
      familyName: json['family_name'] as String?,
      familyStatus: json['family_status']?.toString(),
      paymentMethod: json['payment_method'] as String?,
      paymentProof: json['payment_proof'] as String?,
      recordStatus: json['record_status'] as String?,
      paymentReceipt: json['payment_receipt'] as String?,
      contributionCategoryId: json['contribution_category_id'] as int?,
    );
  }
}
