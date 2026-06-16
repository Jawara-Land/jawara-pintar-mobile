import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';

class StoreDashboardModel {
  final int totalRevenue;
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final List<OrderModel> recentOrders;

  StoreDashboardModel({
    required this.totalRevenue,
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.recentOrders,
  });

  factory StoreDashboardModel.fromJson(Map<String, dynamic> json) {
    return StoreDashboardModel(
      totalRevenue: (json['total_revenue'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pending_orders'] as num?)?.toInt() ?? 0,
      processingOrders: (json['processing_orders'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completed_orders'] as num?)?.toInt() ?? 0,
      cancelledOrders: (json['cancelled_orders'] as num?)?.toInt() ?? 0,
      recentOrders: json['recent_orders'] != null && json['recent_orders'] is List
          ? (json['recent_orders'] as List)
                .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}
