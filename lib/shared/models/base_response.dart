class BaseResponse<T> {
  final bool success;
  final String message;
  final int statusCode;
  final T? data;
  final Map<String, List<String>>? errors;

  BaseResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    this.data,
    this.errors,
  });

  bool get hasErrors => errors != null && errors!.isNotEmpty;

  String? getFieldError(String field) {
    if (errors == null || !errors!.containsKey(field)) return null;
    final fieldErrors = errors![field]!;
    return fieldErrors.isNotEmpty ? fieldErrors.first : null;
  }

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? fromJsonT,
  }) {
    Map<String, List<String>>? parsedErrors;
    if (json['errors'] != null) {
      final errorsRaw = json['errors'] as Map<String, dynamic>;
      parsedErrors = errorsRaw.map(
        (key, value) =>
            MapEntry(key, List<String>.from(value as List<dynamic>)),
      );
    }

    T? parsedData;
    if (fromJsonT != null && json['data'] != null) {
      parsedData = fromJsonT(json['data'] as Map<String, dynamic>);
    }

    return BaseResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      statusCode: json['_statusCode'] as int? ?? 0,
      data: parsedData,
      errors: parsedErrors,
    );
  }
}
