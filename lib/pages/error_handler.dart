// lib/error_handler.dart

class ErrorHandler {
  final List<Map<String, dynamic>> errorData;

  ErrorHandler(this.errorData);

  Map<String, String>? getErrorDetails(int code) {
    final errorDetail = errorData.firstWhere(
          (error) => error['code'] == code,
      orElse: () => {},
    );

    if (errorDetail.isNotEmpty) {
      return {
        'code': errorDetail['code'].toString(),
        'cause': errorDetail['cause'],
      };
    }
    return null;
  }
}
