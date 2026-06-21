class ExpenseCategory {
  final int id;
  final String name;

  ExpenseCategory({
    required this.id,
    required this.name,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
