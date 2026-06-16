import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/marketplace_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/cart/controllers/cart_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/store/controllers/store_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/order_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/midtrans_payment_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/product_detail_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/address/controllers/address_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/controllers/notification_controller.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceController>(() => MarketplaceController());
    Get.put<CartController>(CartController(), permanent: true);
    Get.lazyPut<StoreController>(() => StoreController());
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<MidtransController>(() => MidtransController(), fenix: true);
    Get.lazyPut<AddressController>(() => AddressController(), fenix: true);
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
    Get.lazyPut<ProductDetailController>(() {
      final productId = Get.arguments?['id'] as int? ?? 0;
      return ProductDetailController(productId: productId);
    }, fenix: true);
  }
}
