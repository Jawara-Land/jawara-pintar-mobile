class Expense {
  final int id;
  final String? expenseCategory;
  final num amount;
  final String name;
  final String? proof;
  final String? verifiedAt;
  final String? happenedAt;
  final String? verificator;

  Expense({
    required this.id,
    this.expenseCategory,
    required this.amount,
    required this.name,
    this.proof,
    this.verifiedAt,
    this.happenedAt,
    this.verificator,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as int,
      expenseCategory: json['expense_category'] as String?,
      amount: json['amount'] as num,
      name: json['name'] as String,
      proof: json['proof'] as String?,
      verifiedAt: json['verified_at'] as String?,
      happenedAt: json['happened_at'] as String?,
      verificator: json['verificator'] as String?,
    );
  }
}
