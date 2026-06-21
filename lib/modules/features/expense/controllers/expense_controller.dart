import 'dart:io';
import 'package:get/get.dart';
import '../models/expense_model.dart';
import '../models/expense_category_model.dart';
import '../repositories/expense_repository.dart';

class ExpenseController extends GetxController {
  final ExpenseRepository _repository = ExpenseRepository();
  
  var isLoading = false.obs;
  var isLoadingCategories = false.obs;
  var isSubmitting = false.obs;
  var errorMessage = ''.obs;
  
  var expenses = <Expense>[].obs;
  var categories = <ExpenseCategory>[].obs;
  var selectedExpense = Rx<Expense?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
    fetchCategories();
  }

  Future<void> fetchExpenses({
    String? name,
    int? categoryId,
    String? from,
    String? to,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getExpenses(
        name: name,
        categoryId: categoryId,
        from: from,
        to: to,
      );
      expenses.assignAll(result);
    } catch (e) {
      errorMessage('Failed to load expenses: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories(true);
      final result = await _repository.getCategories();
      categories.assignAll(result);
    } catch (e) {
      errorMessage('Failed to load categories: $e');
    } finally {
      isLoadingCategories(false);
    }
  }

  Future<void> fetchExpenseDetails(int id) async {
    try {
      isLoading(true);
      errorMessage('');
      final result = await _repository.getExpenseDetails(id);
      selectedExpense.value = result;
    } catch (e) {
      errorMessage('Failed to load expense details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> createExpense({
    required String name,
    required int categoryId,
    required num amount,
    required String happenedAt,
    File? proof,
  }) async {
    try {
      isSubmitting(true);
      errorMessage('');
      await _repository.createExpense(
        name: name,
        categoryId: categoryId,
        amount: amount,
        happenedAt: happenedAt,
        proof: proof,
      );
      await fetchExpenses();
      return true;
    } catch (e) {
      errorMessage('Failed to create expense: $e');
      return false;
    } finally {
      isSubmitting(false);
    }
  }
}
