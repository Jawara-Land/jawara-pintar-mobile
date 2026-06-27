import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/finance/finance_repository.dart';
import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FinanceController extends GetxController {
  final FinanceRepository _repository = FinanceRepository();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final dashboard = <String, dynamic>{}.obs;
  final incomes = <Map<String, dynamic>>[].obs;
  final expenses = <Map<String, dynamic>>[].obs;
  final report = <String, dynamic>{}.obs;
  final reportType = 'all'.obs;
  final startDate = DateTime.now()
      .subtract(const Duration(days: 30))
      .toString()
      .substring(0, 10)
      .obs;
  final endDate = DateTime.now().toString().substring(0, 10).obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _repository.getDashboard();
      dashboard.assignAll(response.data ?? {});
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllIncomes() async {
    try {
      isLoading(true);
      errorMessage('');
      incomes.assignAll(await _repository.getAllIncomes());
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllExpenses() async {
    try {
      isLoading(true);
      errorMessage('');
      expenses.assignAll(await _repository.getAllExpenses());
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchReport() async {
    try {
      isLoading(true);
      errorMessage('');
      report.assignAll(
        await _repository.getReport(
          type: reportType.value,
          start: startDate.value,
          end: endDate.value,
        ),
      );
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> printReport() async {
    try {
      isLoading(true);
      if (startDate.value.isEmpty || endDate.value.isEmpty) {
        throw Exception('Pilih rentang tanggal terlebih dahulu');
      }

      final String baseUrl = ApiService.baseUrl.endsWith('/')
          ? ApiService.baseUrl.substring(0, ApiService.baseUrl.length - 1)
          : ApiService.baseUrl;

      final token = await ApiService.getToken();

      final url =
          '$baseUrl/api/mobile/reports/download?type=${reportType.value}&start_date=${startDate.value}&end_date=${endDate.value}&token=$token';

      final uri = Uri.parse(url);

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
