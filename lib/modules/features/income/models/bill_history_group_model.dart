class BillHistoryGroupModel {
  final String code;
  final int id;
  final int contributionId;
  final String name;
  final String categoryName;
  final int totalFamilies;
  final String period;
  final String recordStatus;
  final int amount;

  BillHistoryGroupModel({
    required this.code,
    required this.id,
    required this.contributionId,
    required this.name,
    required this.categoryName,
    required this.totalFamilies,
    required this.period,
    required this.recordStatus,
    required this.amount,
  });

  factory BillHistoryGroupModel.fromJson(Map<String, dynamic> json) {
    return BillHistoryGroupModel(
      code: json['code'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      contributionId: (json['contribution_id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      categoryName: json['category'] as String? ?? '',
      totalFamilies: (json['total_families'] as num?)?.toInt() ?? 0,
      period: json['period'] as String? ?? '',
      recordStatus: json['record_status'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
    );
  }
}
