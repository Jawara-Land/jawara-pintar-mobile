class IncomeApiConstant {
  IncomeApiConstant._();

  // Non-Contribution Incomes
  static const String categoriesOptions = '/api/mobile/incomes/categories-options';
  static const String nonContributionList = '/api/mobile/incomes/non-contribution';
  static const String nonContributionDetail = '/api/mobile/incomes/non-contribution/'; 
  static const String nonContributionStore = '/api/mobile/incomes/non-contribution';

  // For Resident
  static const String residentBillsList = '/api/mobile/resident/family-contributions';
  static const String residentBillDetail = '/api/mobile/resident/family-contributions/'; 
  static const String getPaymentToken = '/api/mobile/resident/payments/token';
  static const String updateStatusAfterPayment = '/api/mobile/resident/family-contributions/'; 
  static const String updateStatusAfterTransfer = '/api/mobile/resident/family-contributions/';
  static const String uploadProof = '/api/mobile/resident/family-contributions/';
  static const String transferChannels = '/api/mobile/resident/transfer-channels';

  // For Treasurer
  static const String contributionCategoriesOptions = '/api/mobile/contributions/categories-options';
  static const String contributionCategories = '/api/mobile/contributions/categories';
  static const String assignBills = '/api/mobile/family-contributions/assign';
  static const String billsHistory = '/api/mobile/family-contributions/history';
  static const String assignedFamilies = '/api/mobile/family-contributions/history/';
  static const String billsList = '/api/mobile/family-contributions/bills';
  static const String approvePayment = '/api/mobile/family-contributions/';
  static const String rejectPayment = '/api/mobile/family-contributions/';
}
