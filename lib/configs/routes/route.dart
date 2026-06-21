abstract class Routes {
  static const String splashRoute = '/splash';
  static const String mainRoute = '/main';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String announcementRoute = '/announcement';
  static const String aspirationRoute = '/aspiration';
  static const String profileRoute = '/profile';
  static const String dataRoute = '/data';
  static const String dataDetailRoute = '$dataRoute/detail';
  static const String dataFormRoute = '$dataRoute/form';

  // Income & Billing
  static const String incomeRoute = '/income';
  static const String incomeDetailRoute = '$incomeRoute/detail';
  static const String incomeAddOtherRoute = '$incomeRoute/add-other';
  static const String incomeAssignRoute = '$incomeRoute/assign';
  static const String incomeManageCategoriesRoute = '$incomeRoute/manage-categories';

  // Marketplace
  static const String marketplaceRoute = '/marketplace';
  static const String productDetailRoute = '$marketplaceRoute/product/detail';
  static const String cartRoute = '$marketplaceRoute/cart';
  static const String checkoutRoute = '$marketplaceRoute/checkout';
  static const String orderListRoute = '$marketplaceRoute/orders';
  static const String orderDetailRoute = '$marketplaceRoute/order/detail';
  static const String myStoreRoute = '$marketplaceRoute/my-store';
  static const String createStoreRoute = '$marketplaceRoute/create-store';
  static const String productManagementRoute = '$marketplaceRoute/store/products';
  static const String productFormRoute = '$marketplaceRoute/store/products/form';
  static const String sellerOrderListRoute = '$marketplaceRoute/store/orders';
  static const String sellerOrderDetailRoute = '$marketplaceRoute/store/orders/detail';
  static const String midtransPaymentRoute = '$marketplaceRoute/payment/midtrans';
  static const String addressListRoute = '$marketplaceRoute/addresses';
  static const String addressFormRoute = '$marketplaceRoute/addresses/form';
  static const String notificationListRoute = '$marketplaceRoute/notifications';
}
