class IncomeNonContributionModel {
  final int id;
  final String incomeCategory;
  final int amount;
  final String name;
  final String? verifiedAt;
  final String? happenedAt;

  IncomeNonContributionModel({
    required this.id,
    required this.incomeCategory,
    required this.amount,
    required this.name,
    this.verifiedAt,
    this.happenedAt,
  });

  factory IncomeNonContributionModel.fromJson(Map<String, dynamic> json) {
    return IncomeNonContributionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      incomeCategory: json['income_category'] as String? ?? 'Umum',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      verifiedAt: json['verified_at'] as String?,
      happenedAt: json['happened_at'] as String?,
    );
  }
}
