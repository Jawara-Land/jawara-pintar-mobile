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
  ];
}
