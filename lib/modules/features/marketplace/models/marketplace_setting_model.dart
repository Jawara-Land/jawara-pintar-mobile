class MarketplaceSettingModel {
  final Map<String, dynamic> settings;

  MarketplaceSettingModel(this.settings);

  factory MarketplaceSettingModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceSettingModel(json);
  }

  String? getValue(String key) => settings[key]?.toString();

  // bool get isMidtransEnabled => getValue('midtrans_enabled') == 'true';
  String get serviceFeeType => getValue('service_fee_type') ?? 'percentage';
  double get serviceFeeAmount => double.tryParse(getValue('service_fee_amount') ?? '0') ?? 0;
}
