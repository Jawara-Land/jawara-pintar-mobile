import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/configs/routes/route.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/controllers/order_controller.dart';
import 'package:jawara_mobile/modules/features/marketplace/sub_features/orders/models/order_model.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';
import 'package:jawara_mobile/shared/widgets/app_widgets.dart';

class SellerOrderListScreen extends StatefulWidget {
  const SellerOrderListScreen({super.key});

  @override
  State<SellerOrderListScreen> createState() => _SellerOrderListScreenState();
}

class _SellerOrderListScreenState extends State<SellerOrderListScreen> {
  final controller = Get.find<OrderController>();
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    controller.fetchSellerOrders();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: AppColor.onPrimary,
              onSurface: AppColor.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  List<OrderModel> _filterOrdersByDate(List<OrderModel> orders) {
    if (_selectedDateRange == null) return orders;
    return orders.where((order) {
      if (order.createdAt == null) return false;
      final orderDate = DateTime(
        order.createdAt!.year,
        order.createdAt!.month,
        order.createdAt!.day,
      );
      final startDate = DateTime(
        _selectedDateRange!.start.year,
        _selectedDateRange!.start.month,
        _selectedDateRange!.start.day,
      );
      final endDate = DateTime(
        _selectedDateRange!.end.year,
        _selectedDateRange!.end.month,
        _selectedDateRange!.end.day,
      );
      return (orderDate.isAtSameMomentAs(startDate) ||
              orderDate.isAfter(startDate)) &&
          (orderDate.isAtSameMomentAs(endDate) || orderDate.isBefore(endDate));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Masuk (Toko)'),
          actions: [
            IconButton(
              icon: Icon(
                _selectedDateRange == null
                    ? Icons.date_range_outlined
                    : Icons.date_range,
                color: _selectedDateRange == null ? null : AppColor.primary,
              ),
              onPressed: _selectDateRange,
              tooltip: 'Filter Tanggal',
            ),

            if (_selectedDateRange != null)
              IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  setState(() {
                    _selectedDateRange = null;
                  });
                },
                tooltip: 'Hapus Filter',
              ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Belum Bayar'),
              Tab(text: 'Sudah Bayar'),
              Tab(text: 'Diproses'),
              Tab(text: 'Dikirim/Diambil'),
              Tab(text: 'Selesai'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingSeller.value &&
              controller.sellerOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredOrders = _filterOrdersByDate(controller.sellerOrders);

          if (filteredOrders.isEmpty) {
            return AppEmptyState(
              icon: Icons.shopping_bag_outlined,
              message: _selectedDateRange == null
                  ? 'Belum ada pesanan masuk'
                  : 'Tidak ada pesanan masuk pada rentang tanggal ini',
            );
          }

          return TabBarView(
            children: [
              _buildOrderList(filteredOrders),
              _buildOrderList(
                filteredOrders.where((o) => o.status == 'pending').toList(),
              ),
              _buildOrderList(
                filteredOrders.where((o) => o.status == 'paid').toList(),
              ),
              _buildOrderList(
                filteredOrders.where((o) => o.status == 'processed').toList(),
              ),
              _buildOrderList(
                filteredOrders
                    .where(
                      (o) => o.status == 'shipped' || o.status == 'picked_up',
                    )
                    .toList(),
              ),
              _buildOrderList(
                filteredOrders.where((o) => o.status == 'completed').toList(),
              ),
              _buildOrderList(
                filteredOrders.where((o) => o.status == 'cancelled').toList(),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const AppEmptyState(
        icon: Icons.shopping_bag_outlined,
        message: 'Tidak ada pesanan di kategori ini',
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final buyerName = order.buyerName ?? 'Pembeli';
        final initialLetter = buyerName.isNotEmpty
            ? buyerName[0].toUpperCase()
            : 'P';
        final formattedDate = order.createdAt != null
            ? DateFormat(
                'dd MMM yyyy, HH:mm',
              ).format(order.createdAt!.toLocal())
            : '-';

        return InkWell(
          onTap: () => Get.toNamed(
            Routes.orderDetailRoute,
            arguments: {'order': order, 'role': 'seller'},
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 2,
            shadowColor: AppColor.shadow.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColor.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          initialLetter,
                          style: AppTextStyle.titleLarge.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buyerName,
                              style: AppTextStyle.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 14,
                                  color: AppColor.textTertiary,
                                ),

                                SizedBox(width: 4),

                                Expanded(
                                  child: Text(
                                    order.orderNumber,
                                    style: AppTextStyle.caption,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 8),

                      OrderStatusBadge(
                        status: order.status,
                        label: order.statusLabel,
                      ),
                    ],
                  ),

                  Divider(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tanggal Pesanan', style: AppTextStyle.caption),

                          SizedBox(height: 4),

                          Text(
                            formattedDate,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total', style: AppTextStyle.caption),

                          SizedBox(height: 2),

                          CurrencyText(
                            order.totalAmount,
                            style: AppTextStyle.headingMedium.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (order.status == 'paid' ||
                      order.status == 'processed') ...[
                    SizedBox(height: 12),

                    if (order.status == 'paid')
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => controller.updateOrderStatus(
                            order.id,
                            'processed',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            'Proses Pesanan',
                            style: AppTextStyle.labelLarge.copyWith(
                              color: AppColor.textOnPrimary,
                            ),
                          ),
                        ),
                      ),

                    if (order.status == 'processed')
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => controller.updateOrderStatus(
                            order.id,
                            order.deliveryMethod == 'pickup'
                                ? 'picked_up'
                                : 'shipped',
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            order.deliveryMethod == 'pickup'
                                ? 'Siap Diambil'
                                : 'Kirim Pesanan',
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
