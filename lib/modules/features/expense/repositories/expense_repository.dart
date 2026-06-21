import 'dart:io';

import 'package:jawara_mobile/shared/utils/services/api_service.dart';
import '../constants/expense_api_constant.dart';
import '../models/expense_model.dart';
import '../models/expense_category_model.dart';

class ExpenseRepository {
  Future<List<Expense>> getExpenses({
    String? name,
    int? categoryId,
    String? from,
    String? to,
  }) async {
    final queryParams = <String>[];
    if (name != null) queryParams.add('filter[name]=$name');
    if (categoryId != null) queryParams.add('filter[expense_category_id]=$categoryId');
    if (from != null) queryParams.add('filter[from]=$from');
    if (to != null) queryParams.add('filter[to]=$to');

    final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final url = '${ExpenseApiConstant.expenses}$queryString';

    final response = await ApiService.get(url);

    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data']['data'] ?? [];
      return dataList.map((e) => Expense.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to fetch expenses');
  }

  Future<List<ExpenseCategory>> getCategories() async {
    final response = await ApiService.get(ExpenseApiConstant.expenseCategories);

    if (response['_statusCode'] == 200 && response['success'] == true) {
      final List dataList = response['data'] ?? [];
      return dataList.map((e) => ExpenseCategory.fromJson(e)).toList();
    }
    throw Exception(response['message'] ?? 'Failed to fetch expense categories');
  }

  Future<Expense> getExpenseDetails(int id) async {
    final response = await ApiService.get('${ExpenseApiConstant.expenses}/$id');

    if (response['_statusCode'] == 200 && response['success'] == true) {
      return Expense.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Failed to fetch expense details');
  }

  Future<Expense> createExpense({
    required String name,
    required int categoryId,
    required num amount,
    required String happenedAt,
    File? proof,
  }) async {
    final fields = {
      'name': name,
      'expense_category_id': categoryId.toString(),
      'amount': amount.toString(),
      'happened_at': happenedAt,
    };

    final Map<String, File>? files = proof != null ? {'file_path': proof} : null;

    final Map<String, dynamic> response;
    
    if (files != null) {
      response = await ApiService.postMultipart(
        ExpenseApiConstant.expenses,
        fields: fields,
        files: files,
      );
    } else {
      response = await ApiService.post(ExpenseApiConstant.expenses, fields);
    }

    if ((response['_statusCode'] == 200 || response['_statusCode'] == 201) && response['success'] == true) {
      return Expense.fromJson(response['data']);
    }
    throw Exception(response['message'] ?? 'Failed to create expense');
  }
}
