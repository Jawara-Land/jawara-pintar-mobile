import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/data/controllers/data_controller.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import 'package:jawara_mobile/modules/features/data/models/house_model.dart';
import 'package:jawara_mobile/modules/features/data/models/resident_model.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:jawara_mobile/shared/styles/app_text_style.dart';

class DataScreen extends GetView<DataController> {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final perm = controller.permissions.value;
      final showGeneralTabs = perm.hasDataAccess;

      return DefaultTabController(
        length: showGeneralTabs ? 3 : 2,
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            backgroundColor: AppColor.surface,
            elevation: 0,
            title: Text(
              showGeneralTabs ? 'Data Warga & Lingkungan' : 'Keluarga Saya',
              style: AppTextStyle.headingMedium,
            ),
            bottom: TabBar(
              controller: controller.tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.textTertiary,
              indicatorColor: AppColor.primary,
              indicatorWeight: 3,
              labelStyle: AppTextStyle.titleLarge,
              unselectedLabelStyle: AppTextStyle.titleMedium,
              tabs: showGeneralTabs
                  ? const [
                      Tab(text: 'Warga'),
                      Tab(text: 'Rumah'),
                      Tab(text: 'Keluarga'),
                    ]
                  : const [
                      Tab(text: 'Profil Keluarga'),
                      Tab(text: 'List Anggota'),
                    ],
            ),
          ),
          body: TabBarView(
            controller: controller.tabController,
            children: showGeneralTabs
                ? [
                    _buildWargaTab(context),
                    _buildRumahTab(context),
                    _buildKeluargaTab(context),
                  ]
                : [
                    _buildMyFamilyProfileTab(context),
                    _buildMyFamilyMembersTab(context),
                  ],
          ),
          floatingActionButton: _buildFAB(context),
        ),
      );
    });
  }

  // --- Dynamic Floating Action Button ---
  Widget? _buildFAB(BuildContext context) {
    return Obx(() {
      final perm = controller.permissions.value;
      if (!controller.permissions.value.hasDataAccess) {
        // Resident role adding family member
        if (perm.myFamilyMembersStore) {
          return FloatingActionButton(
            backgroundColor: AppColor.primary,
            onPressed: () => Get.toNamed('/data/form', arguments: {'type': 'my_family_member'}),
            child: const Icon(Icons.add, color: AppColor.onPrimary),
          );
        }
        return const SizedBox.shrink();
      }

      // General Data tabs: depends on which tab is active
      // We can listen to tabController index
      // Since TabController is not an observable directly, we can use an index variable or GetX update
      // Let's use a state listener on the tab controller index
      return AnimatedBuilder(
        animation: controller.tabController,
        builder: (context, child) {
          final index = controller.tabController.index;
          if (index == 0 && perm.residentsStore) {
            return FloatingActionButton(
              backgroundColor: AppColor.primary,
              onPressed: () => Get.toNamed('/data/form', arguments: {'type': 'resident'}),
              child: const Icon(Icons.add, color: AppColor.onPrimary),
            );
          } else if (index == 1 && perm.housesStore) {
            return FloatingActionButton(
              backgroundColor: AppColor.primary,
              onPressed: () => Get.toNamed('/data/form', arguments: {'type': 'house'}),
              child: const Icon(Icons.add, color: AppColor.onPrimary),
            );
          }
          return const SizedBox.shrink();
        },
      );
    });
  }

  // --- TAB: Warga (General) ---
  Widget _buildWargaTab(BuildContext context) {
    return Column(
      children: [
        _buildWargaSearchAndFilter(context),
        Expanded(
          child: Obx(() {
            if (controller.residentsLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColor.primary));
            }
            if (controller.residents.isEmpty) {
              return _buildEmptyState('Tidak ada data warga ditemukan.');
            }
            return RefreshIndicator(
              color: AppColor.primary,
              onRefresh: () => controller.fetchResidents(refresh: true),
              child: ListView.builder(
                controller: controller.scrollWarga,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.residents.length + (controller.residentsLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.residents.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator(color: AppColor.primary)),
                    );
                  }
                  final resident = controller.residents[index];
                  return _buildWargaCard(resident);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildWargaSearchAndFilter(BuildContext context) {
    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) => controller.searchWargaQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Cari nama warga...',
                hintStyle: AppTextStyle.inputHint,
                prefixIcon: const Icon(Icons.search, color: AppColor.textHint),
                filled: true,
                fillColor: AppColor.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showWargaFilterBottomSheet(context),
            icon: const Icon(Icons.filter_list_rounded, color: AppColor.primary),
            style: IconButton.styleFrom(
              backgroundColor: AppColor.primaryLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showWargaFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter Warga', style: AppTextStyle.headingSmall),
                    TextButton(
                      onPressed: () {
                        controller.filterGender.value = '';
                        controller.filterActiveStatus.value = '';
                        controller.filterFamilyId.value = null;
                        controller.fetchResidents(refresh: true);
                        Get.back();
                      },
                      child: const Text('Reset', style: TextStyle(color: AppColor.error)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Jenis Kelamin', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFilterChip('Semua', controller.filterGender.value == '', () => controller.filterGender.value = ''),
                    const SizedBox(width: 8),
                    _buildFilterChip('Laki-laki', controller.filterGender.value == 'male', () => controller.filterGender.value = 'male'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Perempuan', controller.filterGender.value == 'female', () => controller.filterGender.value = 'female'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Status Aktif', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFilterChip('Semua', controller.filterActiveStatus.value == '', () => controller.filterActiveStatus.value = ''),
                    const SizedBox(width: 8),
                    _buildFilterChip('Aktif', controller.filterActiveStatus.value == 'active', () => controller.filterActiveStatus.value = 'active'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Nonaktif', controller.filterActiveStatus.value == 'inactive', () => controller.filterActiveStatus.value = 'inactive'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Keluarga', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: controller.filterFamilyId.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Semua Keluarga')),
                    ...controller.familyOptions.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))),
                  ],
                  onChanged: (val) {
                    controller.filterFamilyId.value = val;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      controller.fetchResidents(refresh: true);
                      Get.back();
                    },
                    child: Text('Terapkan', style: AppTextStyle.titleLarge.copyWith(color: AppColor.onPrimary)),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildWargaCard(ResidentModel resident) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColor.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // If admin / community_head, can view detail screen
          if (controller.permissions.value.residentsShow) {
            Get.toNamed('/data/detail', arguments: {'type': 'resident', 'id': resident.id});
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      resident.name,
                      style: AppTextStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildRoleBadge(resident.familyRole),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'NIK: ${resident.nik ?? "-"}',
                style: AppTextStyle.caption,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    resident.gender == 'male' ? Icons.male : Icons.female,
                    size: 16,
                    color: AppColor.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    resident.gender == 'male' ? 'Laki-laki' : 'Perempuan',
                    style: AppTextStyle.bodyMedium,
                  ),
                  const Spacer(),
                  _buildStatusBadge(resident.activeStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB: Rumah (General) ---
  Widget _buildRumahTab(BuildContext context) {
    return Column(
      children: [
        _buildRumahSearchAndFilter(context),
        Expanded(
          child: Obx(() {
            if (controller.housesLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColor.primary));
            }
            if (controller.houses.isEmpty) {
              return _buildEmptyState('Tidak ada data rumah ditemukan.');
            }
            return RefreshIndicator(
              color: AppColor.primary,
              onRefresh: () => controller.fetchHouses(refresh: true),
              child: ListView.builder(
                controller: controller.scrollRumah,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.houses.length + (controller.housesLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.houses.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator(color: AppColor.primary)),
                    );
                  }
                  final house = controller.houses[index];
                  return _buildRumahCard(house);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRumahSearchAndFilter(BuildContext context) {
    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) => controller.searchRumahQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Cari alamat rumah...',
                hintStyle: AppTextStyle.inputHint,
                prefixIcon: const Icon(Icons.search, color: AppColor.textHint),
                filled: true,
                fillColor: AppColor.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showRumahFilterBottomSheet(context),
            icon: const Icon(Icons.filter_list_rounded, color: AppColor.primary),
            style: IconButton.styleFrom(
              backgroundColor: AppColor.primaryLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showRumahFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter Rumah', style: AppTextStyle.headingSmall),
                    TextButton(
                      onPressed: () {
                        controller.filterHouseStatus.value = '';
                        controller.fetchHouses(refresh: true);
                        Get.back();
                      },
                      child: const Text('Reset', style: TextStyle(color: AppColor.error)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Status Rumah', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFilterChip('Semua', controller.filterHouseStatus.value == '', () => controller.filterHouseStatus.value = ''),
                    const SizedBox(width: 8),
                    _buildFilterChip('Tersedia', controller.filterHouseStatus.value == 'available', () => controller.filterHouseStatus.value = 'available'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Ditempati', controller.filterHouseStatus.value == 'occupied', () => controller.filterHouseStatus.value = 'occupied'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      controller.fetchHouses(refresh: true);
                      Get.back();
                    },
                    child: Text('Terapkan', style: AppTextStyle.titleLarge.copyWith(color: AppColor.onPrimary)),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildRumahCard(HouseModel house) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColor.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (controller.permissions.value.housesShow) {
            Get.toNamed('/data/detail', arguments: {'type': 'house', 'id': house.id});
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home, color: AppColor.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house.address,
                      style: AppTextStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID Rumah: #${house.id}',
                      style: AppTextStyle.caption,
                    ),
                  ],
                ),
              ),
              _buildHouseStatusBadge(house.status),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB: Keluarga (General) ---
  Widget _buildKeluargaTab(BuildContext context) {
    return Column(
      children: [
        _buildKeluargaSearchAndFilter(context),
        Expanded(
          child: Obx(() {
            if (controller.familiesLoading.value) {
              return const Center(child: CircularProgressIndicator(color: AppColor.primary));
            }
            if (controller.families.isEmpty) {
              return _buildEmptyState('Tidak ada data keluarga ditemukan.');
            }
            return RefreshIndicator(
              color: AppColor.primary,
              onRefresh: () => controller.fetchFamilies(refresh: true),
              child: ListView.builder(
                controller: controller.scrollKeluarga,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.families.length + (controller.familiesLoadMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.families.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator(color: AppColor.primary)),
                    );
                  }
                  final family = controller.families[index];
                  return _buildKeluargaCard(family);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildKeluargaSearchAndFilter(BuildContext context) {
    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (val) => controller.searchKeluargaQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Cari nama keluarga...',
                hintStyle: AppTextStyle.inputHint,
                prefixIcon: const Icon(Icons.search, color: AppColor.textHint),
                filled: true,
                fillColor: AppColor.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.inputBorder),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showKeluargaFilterBottomSheet(context),
            icon: const Icon(Icons.filter_list_rounded, color: AppColor.primary),
            style: IconButton.styleFrom(
              backgroundColor: AppColor.primaryLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _showKeluargaFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filter Keluarga', style: AppTextStyle.headingSmall),
                    TextButton(
                      onPressed: () {
                        controller.filterHouseId.value = null;
                        controller.filterIsActive.value = '';
                        controller.fetchFamilies(refresh: true);
                        Get.back();
                      },
                      child: const Text('Reset', style: TextStyle(color: AppColor.error)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Status Keaktifan', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFilterChip('Semua', controller.filterIsActive.value == '', () => controller.filterIsActive.value = ''),
                    const SizedBox(width: 8),
                    _buildFilterChip('Aktif', controller.filterIsActive.value == '1', () => controller.filterIsActive.value = '1'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Nonaktif', controller.filterIsActive.value == '0', () => controller.filterIsActive.value = '0'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Lokasi Rumah', style: AppTextStyle.titleMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: controller.filterHouseId.value,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Semua Rumah')),
                    ...controller.houseOptions.map((h) => DropdownMenuItem(value: h.id, child: Text(h.address))),
                  ],
                  onChanged: (val) {
                    controller.filterHouseId.value = val;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      controller.fetchFamilies(refresh: true);
                      Get.back();
                    },
                    child: Text('Terapkan', style: AppTextStyle.titleLarge.copyWith(color: AppColor.onPrimary)),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildKeluargaCard(FamilyModel family) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColor.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (controller.permissions.value.familiesShow) {
            Get.toNamed('/data/detail', arguments: {'type': 'family', 'id': family.id});
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      family.name,
                      style: AppTextStyle.titleLarge,
                    ),
                  ),
                  _buildFamilyActiveBadge(family.isActive),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppColor.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Kepala Keluarga: ${family.headOfFamilyName ?? "-"}',
                      style: AppTextStyle.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColor.textTertiary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Alamat: ${family.currentHouseAddress ?? "-"}',
                      style: AppTextStyle.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB: Profil Keluarga (Resident Role) ---
  Widget _buildMyFamilyProfileTab(BuildContext context) {
    return Obx(() {
      if (controller.myFamilyLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColor.primary));
      }
      final fam = controller.myFamily.value;
      if (fam == null) {
        return _buildEmptyState('Kamu belum terdaftar di keluarga manapun.');
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColor.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.family_restroom, color: AppColor.primary, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(fam.name, style: AppTextStyle.headingMedium),
                        ),
                      ],
                    ),
                    const Divider(height: 30, color: AppColor.divider),
                    _buildDetailRow('Kepala Keluarga', fam.headOfFamilyName ?? '-'),
                    const SizedBox(height: 12),
                    _buildDetailRow('Alamat Rumah', fam.currentHouseAddress ?? '-'),
                    const SizedBox(height: 12),
                    _buildDetailRow('Status Keluarga', fam.isActive ? 'Aktif' : 'Nonaktif',
                        customValueWidget: _buildFamilyActiveBadge(fam.isActive)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- TAB: List Anggota (Resident Role) ---
  Widget _buildMyFamilyMembersTab(BuildContext context) {
    return Obx(() {
      if (controller.myFamilyLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColor.primary));
      }
      if (controller.myFamilyMembers.isEmpty) {
        return _buildEmptyState('Tidak ada data anggota keluarga.');
      }
      return RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () => controller.fetchMyFamilyMembers(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: controller.myFamilyMembers.length,
          itemBuilder: (context, index) {
            final member = controller.myFamilyMembers[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColor.border),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Get.toNamed('/data/detail', arguments: {'type': 'my_family_member', 'id': member.id});
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              member.name,
                              style: AppTextStyle.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildRoleBadge(member.familyRole),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('NIK: ${member.nik ?? "-"}', style: AppTextStyle.caption),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            member.gender == 'male' ? Icons.male : Icons.female,
                            size: 16,
                            color: AppColor.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            member.gender == 'male' ? 'Laki-laki' : 'Perempuan',
                            style: AppTextStyle.bodyMedium,
                          ),
                          const Spacer(),
                          _buildStatusBadge(member.activeStatus),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // --- Reusable Small Widgets ---

  Widget _buildDetailRow(String label, String value, {Widget? customValueWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.caption),
        const SizedBox(height: 4),
        customValueWidget ?? Text(value, style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_rounded, size: 64, color: AppColor.textTertiary),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyle.bodyLarge.copyWith(color: AppColor.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColor.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColor.primary : AppColor.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      backgroundColor: AppColor.inputFill,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? AppColor.primary : AppColor.inputBorder),
      ),
    );
  }

  Widget _buildRoleBadge(String? role) {
    Color bg = AppColor.background;
    Color fg = AppColor.textSecondary;
    String label = role ?? '';

    switch (role) {
      case 'head':
        bg = AppColor.primaryLight;
        fg = AppColor.primary;
        label = 'Kepala Keluarga';
        break;
      case 'wife':
        bg = const Color(0xFFFCE7F3);
        fg = const Color(0xFFDB2777);
        label = 'Istri';
        break;
      case 'child':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'Anak';
        break;
      case 'other_member':
        bg = AppColor.border;
        fg = AppColor.textSecondary;
        label = 'Anggota Lain';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(color: fg, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color bg = AppColor.background;
    Color fg = AppColor.textSecondary;
    String label = status ?? '';

    if (status == 'active') {
      bg = const Color(0xFFDCFCE7);
      fg = AppColor.successDark;
      label = 'Aktif';
    } else if (status == 'inactive') {
      bg = AppColor.errorLight;
      fg = AppColor.errorDark;
      label = 'Nonaktif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(color: fg, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildFamilyActiveBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDCFCE7) : AppColor.errorLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Aktif' : 'Nonaktif',
        style: AppTextStyle.caption.copyWith(
          color: isActive ? AppColor.successDark : AppColor.errorDark,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildHouseStatusBadge(String status) {
    Color bg = AppColor.background;
    Color fg = AppColor.textSecondary;
    String label = status;

    if (status == 'available') {
      bg = const Color(0xFFE0F2FE);
      fg = const Color(0xFF0284C7);
      label = 'Tersedia';
    } else if (status == 'occupied') {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
      label = 'Ditempati';
    } else if (status == 'inactive') {
      bg = AppColor.border;
      fg = AppColor.textSecondary;
      label = 'Nonaktif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyle.caption.copyWith(color: fg, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
