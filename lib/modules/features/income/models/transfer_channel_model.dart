class TransferChannelModel {
  final String code;
  final String name;
  final String accountName;
  final String accountNumber;
  final String? bankLogo;

  TransferChannelModel({
    required this.code,
    required this.name,
    required this.accountName,
    required this.accountNumber,
    this.bankLogo,
  });

  factory TransferChannelModel.fromJson(Map<String, dynamic> json) {
    return TransferChannelModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      accountNumber: json['account_number'] as String? ?? '',
      bankLogo: json['bank_logo'] as String? ?? json['logo'] as String?,
    );
  }
}
