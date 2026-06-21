class IncomeNonContributionDetailModel {
  final int id;
  final String incomeCategory;
  final int amount;
  final String name;
  final String? proof;
  final String verificator;
  final String? happenedAt;

  IncomeNonContributionDetailModel({
    required this.id,
    required this.incomeCategory,
    required this.amount,
    required this.name,
    this.proof,
    required this.verificator,
    this.happenedAt,
  });

  factory IncomeNonContributionDetailModel.fromJson(Map<String, dynamic> json) {
    return IncomeNonContributionDetailModel(
      id: json['id'] as int,
      incomeCategory: json['income_category'] as String? ?? 'Umum',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      proof: json['proof'] as String?,
      verificator: json['verificator'] as String? ?? 'Admin',
      happenedAt: json['happened_at'] as String?,
    );
  }
}
