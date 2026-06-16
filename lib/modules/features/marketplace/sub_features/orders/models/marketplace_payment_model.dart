class MarketplacePaymentModel {
  final int id;
  final int orderId;
  final String midtransOrderId;
  final String transactionStatus;
  final String? paymentType;
  final int? grossAmount;
  final DateTime? createdAt;

  MarketplacePaymentModel({
    required this.id,
    required this.orderId,
    required this.midtransOrderId,
    required this.transactionStatus,
    this.paymentType,
    this.grossAmount,
    this.createdAt,
  });

  factory MarketplacePaymentModel.fromJson(Map<String, dynamic> json) {
    return MarketplacePaymentModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderId: (json['order_id'] as num?)?.toInt() ?? 0,
      midtransOrderId: json['midtrans_order_id'] as String? ?? '',
      transactionStatus: json['transaction_status'] as String? ?? '',
      paymentType: json['payment_type'] as String?,
      grossAmount: (json['gross_amount'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
