import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/finance/finance_controller.dart';
import 'package:jawara_mobile/shared/styles/app_styles.dart';

class FinanceReportScreen extends GetView<FinanceController> {
  const FinanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: const Text('Laporan Keuangan'),
          actions: [
            IconButton(
              onPressed: controller.printReport,
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FilterChip(
                      label: 'Semua',
                      selected: controller.reportType.value == 'all',
                      onTap: () => controller.reportType('all'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterChip(
                      label: 'Pemasukan',
                      selected: controller.reportType.value == 'income',
                      onTap: () => controller.reportType('income'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FilterChip(
                      label: 'Pengeluaran',
                      selected: controller.reportType.value == 'expense',
                      onTap: () => controller.reportType('expense'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          controller.startDate(
                            date.toString().substring(0, 10),
                          );
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Mulai',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          controller.startDate.value.isEmpty
                              ? 'Pilih Tanggal'
                              : controller.startDate.value,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          controller.endDate(date.toString().substring(0, 10));
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Akhir',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          controller.endDate.value.isEmpty
                              ? 'Pilih Tanggal'
                              : controller.endDate.value,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.fetchReport,
                child: const Text('Tampilkan Laporan'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    controller.report.isEmpty ||
                        controller.report['transactions'] == null
                    ? Center(child: Text('Belum ada laporan.'))
                    : ListView.builder(
                        itemCount:
                            (controller.report['transactions'] as List).length,
                        itemBuilder: (context, index) {
                          final e =
                              (controller.report['transactions']
                                  as List)[index];
                          return ListTile(
                            title: Text(e['description'] ?? '-'),
                            subtitle: Text('${e['date']} - ${e['category']}'),
                            trailing: Text(
                              'Rp ${e['amount']}',
                              style: TextStyle(
                                color:
                                    (e['type']?.toString().toLowerCase() ==
                                        'pengeluaran')
                                    ? Colors.red
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
