import 'package:get/get.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/login/bindings/login_binding.dart';
import 'package:jawara_mobile/modules/features/login/view/ui/login_screen.dart';
import 'package:jawara_mobile/modules/features/main/bindings/main_binding.dart';
import 'package:jawara_mobile/modules/features/main/view/ui/main_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/bindings/marketplace_binding.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/ui/marketplace_screen.dart';
import 'package:jawara_mobile/modules/features/onboarding/bindings/onboarding_binding.dart';
import 'package:jawara_mobile/modules/features/onboarding/views/ui/onboarding_screen.dart';
import 'package:jawara_mobile/modules/features/profile/bindings/profile_binding.dart';
import 'package:jawara_mobile/modules/features/profile/view/ui/profile_screen.dart';
import 'package:jawara_mobile/modules/features/register/bindings/register_binding.dart';
import 'package:jawara_mobile/modules/features/register/view/ui/register_screen.dart';
import 'package:jawara_mobile/modules/features/splash/bindings/splash_binding.dart';
import 'package:jawara_mobile/modules/features/splash/view/ui/splash_screen.dart';
import 'package:jawara_mobile/modules/features/data/bindings/data_binding.dart';
import 'package:jawara_mobile/modules/features/data/view/ui/data_screen.dart';
import 'package:jawara_mobile/modules/features/data/view/ui/data_detail_screen.dart';
import 'package:jawara_mobile/modules/features/data/view/ui/data_form_screen.dart';
import 'package:jawara_mobile/modules/features/income/bindings/income_binding.dart';
import 'package:jawara_mobile/modules/features/income/view/ui/income_screen.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/resident_bill/view/ui/resident_bill_detail_screen.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/non_contribution/view/ui/add_income_non_contribution_screen.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/view/ui/assign_bill_form_screen.dart';
import 'package:jawara_mobile/modules/features/income/sub_features/treasurer_bill/view/ui/manage_contribution_categories_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/ui/product_detail_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/view/ui/cart_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/view/components/checkout_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/view/ui/order_list_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/view/components/order_detail_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/ui/my_store_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/ui/create_store_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/ui/product_management_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/view/ui/product_form_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/view/ui/seller_order_list_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/view/components/midtrans_payment_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/view/ui/address_list_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/view/components/address_form_screen.dart';
import 'package:jawara_mobile/modules/features/marketplace/view/ui/notification_list_screen.dart';
import 'package:jawara_mobile/modules/features/expense/bindings/expense_binding.dart';
import 'package:jawara_mobile/modules/features/expense/views/ui/expense_screen.dart';
import 'package:jawara_mobile/modules/features/expense/views/ui/expense_detail_screen.dart';
import 'package:jawara_mobile/modules/features/expense/views/ui/expense_create_screen.dart';
import 'package:jawara_mobile/modules/features/user_management/bindings/user_management_binding.dart';
import 'package:jawara_mobile/modules/features/user_management/views/ui/user_management_screen.dart';
import 'package:jawara_mobile/modules/features/user_management/views/ui/user_management_form_screen.dart';
import 'package:jawara_mobile/modules/features/log_history/bindings/log_history_binding.dart';
import 'package:jawara_mobile/modules/features/log_history/views/ui/log_history_screen.dart';
import 'package:jawara_mobile/modules/features/transfer_channel/bindings/transfer_channel_binding.dart';
import 'package:jawara_mobile/modules/features/transfer_channel/views/ui/transfer_channel_screen.dart';
import 'package:jawara_mobile/modules/features/transfer_channel/views/ui/transfer_channel_form_screen.dart';
import 'package:jawara_mobile/modules/features/event/bindings/event_binding.dart';
import 'package:jawara_mobile/modules/features/event/bindings/event_form_binding.dart';
import 'package:jawara_mobile/modules/features/event/view/ui/event_screen.dart';
import 'package:jawara_mobile/modules/features/event/view/ui/forms/event_form_screen.dart';
import 'package:jawara_mobile/modules/features/announcement/bindings/announcement_binding.dart';
import 'package:jawara_mobile/modules/features/announcement/bindings/announcement_form_binding.dart';
import 'package:jawara_mobile/modules/features/announcement/view/ui/announcement_screen.dart';
import 'package:jawara_mobile/modules/features/announcement/view/ui/forms/announcement_form_screen.dart';
import 'package:jawara_mobile/modules/features/app_notification/bindings/app_notification_binding.dart';
import 'package:jawara_mobile/modules/features/app_notification/view/ui/app_notification_list_screen.dart';
import 'package:jawara_mobile/modules/features/aspiration/bindings/aspiration_binding.dart';
import 'package:jawara_mobile/modules/features/aspiration/view/ui/aspiration_screen.dart';
import 'package:jawara_mobile/modules/features/aspiration/view/ui/aspiration_form_screen.dart';
import 'package:jawara_mobile/modules/features/finance/finance_binding.dart';
import 'package:jawara_mobile/modules/features/finance/finance_screen.dart';
import 'package:jawara_mobile/modules/features/finance/view/ui/finance_incomes_screen.dart';
import 'package:jawara_mobile/modules/features/finance/view/ui/finance_expenses_screen.dart';
import 'package:jawara_mobile/modules/features/finance/view/ui/finance_report_screen.dart';

abstract class Pages {
  static final page = [
    GetPage(
      name: Routes.splashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.mainRoute,
      page: () => MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.onboardingRoute,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.loginRoute,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.registerRoute,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.marketplaceRoute,
      page: () => MarketplaceScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.dataRoute,
      page: () => const DataScreen(),
      binding: DataBinding(),
    ),
    GetPage(
      name: Routes.dataDetailRoute,
      page: () => const DataDetailScreen(),
      binding: DataBinding(),
    ),
    GetPage(
      name: Routes.dataFormRoute,
      page: () => const DataFormScreen(),
      binding: DataBinding(),
    ),
    GetPage(
      name: Routes.incomeRoute,
      page: () => IncomeScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.incomeDetailRoute,
      page: () => const ResidentBillDetailScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.incomeAddOtherRoute,
      page: () => const AddIncomeNonContributionScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.incomeAssignRoute,
      page: () => const AssignBillFormScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.incomeManageCategoriesRoute,
      page: () => const ManageContributionCategoriesScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.productDetailRoute,
      page: () => const ProductDetailScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.cartRoute,
      page: () => const CartScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.checkoutRoute,
      page: () => const CheckoutScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.orderListRoute,
      page: () => const OrderListScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.orderDetailRoute,
      page: () => const OrderDetailScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.myStoreRoute,
      page: () => const MyStoreScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.createStoreRoute,
      page: () => const CreateStoreScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.productManagementRoute,
      page: () => const ProductManagementScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.productFormRoute,
      page: () => const ProductFormScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.sellerOrderListRoute,
      page: () => const SellerOrderListScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.midtransPaymentRoute,
      page: () => const MidtransPaymentScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.addressListRoute,
      page: () => const AddressListScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.addressFormRoute,
      page: () => const AddressFormScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.notificationListRoute,
      page: () => const NotificationListScreen(),
      binding: MarketplaceBinding(),
    ),
    GetPage(
      name: Routes.profileRoute,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.residentBillRoute,
      page: () => const ResidentBillDetailScreen(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: Routes.expenseRoute,
      page: () => const ExpenseScreen(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: '${Routes.expenseDetailRoute}/:id',
      page: () => ExpenseDetailScreen(id: int.parse(Get.parameters['id']!)),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: Routes.expenseCreateRoute,
      page: () => ExpenseCreateScreen(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: Routes.userManagementRoute,
      page: () => const UserManagementScreen(),
      binding: UserManagementBinding(),
    ),
    GetPage(
      name: Routes.userManagementFormRoute,
      page: () => const UserManagementFormScreen(),
      binding: UserManagementFormBinding(),
    ),
    GetPage(
      name: Routes.logHistoryRoute,
      page: () => const LogHistoryScreen(),
      binding: LogHistoryBinding(),
    ),
    GetPage(
      name: Routes.transferChannelRoute,
      page: () => const TransferChannelScreen(),
      binding: TransferChannelBinding(),
    ),
    GetPage(
      name: Routes.eventRoute,
      page: () => const EventScreen(),
      binding: EventBinding(),
    ),
    GetPage(
      name: Routes.announcementRoute,
      page: () => const AnnouncementScreen(),
      binding: AnnouncementBinding(),
    ),
    GetPage(
      name: Routes.aspirationRoute,
      page: () => const AspirationScreen(),
      binding: AspirationBinding(),
    ),
    GetPage(
      name: Routes.aspirationFormRoute,
      page: () => const AspirationFormScreen(),
      binding: AspirationBinding(),
    ),
    GetPage(
      name: Routes.financeRoute,
      page: () => const FinanceScreen(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: Routes.financeIncomeRoute,
      page: () => const FinanceIncomesScreen(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: Routes.financeExpenseRoute,
      page: () => const FinanceExpensesScreen(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: Routes.financeReportRoute,
      page: () => const FinanceReportScreen(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: Routes.transferChannelCreateRoute,
      page: () => const TransferChannelFormScreen(),
      binding: TransferChannelBinding(),
    ),
    GetPage(
      name: Routes.transferChannelEditRoute,
      page: () => const TransferChannelFormScreen(),
      binding: TransferChannelBinding(),
    ),
    GetPage(
      name: Routes.appNotificationRoute,
      page: () => const AppNotificationListScreen(),
      binding: AppNotificationBinding(),
    ),
    GetPage(
      name: Routes.eventFormRoute,
      page: () => const EventFormScreen(),
      binding: EventFormBinding(),
    ),
    GetPage(
      name: Routes.announcementFormRoute,
      page: () => const AnnouncementFormScreen(),
      binding: AnnouncementFormBinding(),
    ),
  ];
}
