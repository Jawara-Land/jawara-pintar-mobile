class TransferChannel {
  final int id;
  final String name;
  final String type;
  final String? accountNumber;
  final String? holderName;
  final String? thumbnail;
  final String? qrImage;
  final String? note;

  TransferChannel({
    required this.id,
    required this.name,
    required this.type,
    this.accountNumber,
    this.holderName,
    this.thumbnail,
    this.qrImage,
    this.note,
  });

  factory TransferChannel.fromJson(Map<String, dynamic> json) {
    return TransferChannel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      accountNumber: json['account_number'] as String?,
      holderName: json['holder_name'] as String?,
      thumbnail: json['thumbnail'] as String?,
      qrImage: json['qr_image'] as String?,
      note: json['note'] as String?,
    );
  }
}
