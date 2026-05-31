import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jawara_mobile/modules/features/data/controllers/data_controller.dart';
import 'package:jawara_mobile/modules/features/data/models/family_model.dart';
import 'package:jawara_mobile/modules/features/data/models/house_model.dart';
import 'package:jawara_mobile/modules/features/data/models/resident_model.dart';
import 'package:jawara_mobile/modules/features/data/repositories/data_repository.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:jawara_mobile/shared/styles/app_text_style.dart';

class DataDetailScreen extends StatefulWidget {
  const DataDetailScreen({super.key});

  @override
  State<DataDetailScreen> createState() => _DataDetailScreenState();
}

class _DataDetailScreenState extends State<DataDetailScreen> {
  final DataController controller = DataController.to;

  late final String type;
  late final int id;

  bool isLoading = true;
  String? errorMessage;

  ResidentModel? resident;
  HouseModel? house;
  List<dynamic> residentHistories = [];
  FamilyModel? family;
  List<ResidentModel> familyMembers = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null || args['type'] == null || args['id'] == null) {
      errorMessage = 'Parameter tidak valid';
      isLoading = false;
      return;
    }

    type = args['type'] as String;
    id = args['id'] as int;

    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (type == 'resident' || type == 'my_family_member') {
        final res = await DataRepository.getResidentDetail(id);
        if (res['success'] == true) {
          resident = res['resident'] as ResidentModel;
        } else {
          errorMessage = res['message'];
        }
      } else if (type == 'house') {
        final res = await DataRepository.getHouseDetail(id);
        if (res['success'] == true) {
          house = res['house'] as HouseModel;
          residentHistories = res['resident_histories'] as List<dynamic>;
        } else {
          errorMessage = res['message'];
        }
      } else if (type == 'family') {
        final res = await DataRepository.getFamilyDetail(id);
        if (res['success'] == true) {
          family = res['family'] as FamilyModel;
          familyMembers = res['members'] as List<ResidentModel>;
        } else {
          errorMessage = res['message'];
        }
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          _getAppBarTitle(),
          style: AppTextStyle.headingMedium,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.primary))
          : errorMessage != null
              ? _buildErrorState()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: _buildContent(),
                      ),
                    ),
                    _buildActionButtons(),
                  ],
                ),
    );
  }

  String _getAppBarTitle() {
    switch (type) {
      case 'resident':
      case 'my_family_member':
        return 'Detail Warga';
      case 'house':
        return 'Detail Rumah';
      case 'family':
        return 'Detail Keluarga';
      default:
        return 'Detail Data';
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColor.error),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Gagal memuat detail data.',
              style: AppTextStyle.bodyLarge.copyWith(color: AppColor.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
              onPressed: _loadDetails,
              child: const Text('Coba Lagi'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (type == 'resident' || type == 'my_family_member') {
      return _buildResidentContent();
    } else if (type == 'house') {
      return _buildHouseContent();
    } else if (type == 'family') {
      return _buildFamilyContent();
    }
    return const SizedBox.shrink();
  }

  Widget _buildResidentContent() {
    final r = resident!;
    return Card(
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
                CircleAvatar(
                  backgroundColor: AppColor.primaryLight,
                  radius: 28,
                  child: Text(
                    r.name.isNotEmpty ? r.name[0].toUpperCase() : '?',
                    style: AppTextStyle.headingMedium.copyWith(color: AppColor.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name, style: AppTextStyle.headingSmall),
                      const SizedBox(height: 4),
                      Text('NIK: ${r.nik ?? "-"}', style: AppTextStyle.caption),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 40, color: AppColor.divider),
            _buildDetailItem(Icons.family_restroom, 'Keluarga', r.family ?? '-'),
            _buildDetailItem(Icons.star, 'Peran Keluarga', _getFamilyRoleLabel(r.familyRole)),
            _buildDetailItem(r.gender == 'male' ? Icons.male : Icons.female, 'Jenis Kelamin', r.gender == 'male' ? 'Laki-laki' : 'Perempuan'),
            _buildDetailItem(Icons.cake, 'Tempat, Tanggal Lahir', '${r.birthplace ?? "-"}, ${r.birthdate ?? "-"}'),
            _buildDetailItem(Icons.phone, 'Nomor Telepon', r.phoneNumber ?? '-'),
            _buildDetailItem(Icons.menu_book, 'Agama', _getReligionLabel(r.religion)),
            _buildDetailItem(Icons.bloodtype, 'Golongan Darah', r.bloodType?.toUpperCase() ?? '-'),
            _buildDetailItem(Icons.school, 'Pendidikan Terakhir', _getEducationLabel(r.lastEducation)),
            _buildDetailItem(Icons.work, 'Pekerjaan', _getOccupationLabel(r.occupation)),
            _buildDetailItem(Icons.check_circle_outline, 'Status Aktif', r.activeStatus == 'active' ? 'Aktif' : 'Nonaktif'),
            _buildDetailItem(Icons.favorite, 'Status Jiwa', r.lifeStatus == 'alive' ? 'Hidup' : 'Wafat'),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseContent() {
    final h = house!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Icon(Icons.home, color: AppColor.primary, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat Rumah', style: AppTextStyle.caption),
                          const SizedBox(height: 4),
                          Text(h.address, style: AppTextStyle.headingSmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30, color: AppColor.divider),
                _buildDetailItem(Icons.tag, 'ID Rumah', '#${h.id}'),
                _buildDetailItem(Icons.info_outline, 'Status Rumah', h.statusLabel),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Riwayat Penghuni', style: AppTextStyle.headingSmall),
        const SizedBox(height: 12),
        if (residentHistories.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.border),
            ),
            child: Center(
              child: Text(
                'Belum ada riwayat penghuni rumah ini.',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColor.textTertiary),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: residentHistories.length,
            itemBuilder: (context, index) {
              final hist = residentHistories[index] as Map<String, dynamic>;
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColor.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hist['resident_name'] as String? ?? '-',
                        style: AppTextStyle.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tanggal Masuk: ${hist['enter_date'] as String? ?? "-"}',
                        style: AppTextStyle.bodyMedium,
                      ),
                      if (hist['exit_date'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal Keluar: ${hist['exit_date'] as String}',
                          style: AppTextStyle.bodyMedium.copyWith(color: AppColor.errorDark),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildFamilyContent() {
    final f = family!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Icon(Icons.family_restroom, color: AppColor.primary, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama Keluarga', style: AppTextStyle.caption),
                          const SizedBox(height: 4),
                          Text(f.name, style: AppTextStyle.headingSmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 30, color: AppColor.divider),
                _buildDetailItem(Icons.person, 'Kepala Keluarga', f.headOfFamilyName ?? '-'),
                _buildDetailItem(Icons.location_on, 'Alamat Rumah', f.currentHouseAddress ?? '-'),
                _buildDetailItem(Icons.info, 'Status Keaktifan', f.isActive ? 'Aktif' : 'Nonaktif'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Anggota Keluarga', style: AppTextStyle.headingSmall),
        const SizedBox(height: 12),
        if (familyMembers.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.border),
            ),
            child: Center(
              child: Text(
                'Tidak ada anggota terdaftar.',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColor.textTertiary),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: familyMembers.length,
            itemBuilder: (context, index) {
              final member = familyMembers[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColor.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member.name, style: AppTextStyle.titleLarge),
                            const SizedBox(height: 4),
                            Text('NIK: ${member.nik ?? "-"}', style: AppTextStyle.caption),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: member.familyRole == 'head' ? AppColor.primaryLight : AppColor.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getFamilyRoleLabel(member.familyRole),
                          style: AppTextStyle.caption.copyWith(
                            color: member.familyRole == 'head' ? AppColor.primary : AppColor.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.textTertiary, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.caption),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyle.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColor.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final perm = controller.permissions.value;

    bool showEdit = false;
    bool showDelete = false;

    if (type == 'resident') {
      showEdit = perm.residentsUpdate;
      // Cannot delete head of family
      showDelete = perm.residentsDestroy && (resident != null && !resident!.isHead);
    } else if (type == 'house') {
      // Edit & Delete only for available houses, not occupied
      final isAvailable = house != null && house!.isAvailable;
      showEdit = perm.housesUpdate && isAvailable;
      showDelete = perm.housesDestroy && isAvailable;
    } else if (type == 'my_family_member') {
      showEdit = perm.myFamilyMembersUpdate;
      showDelete = false; // No delete endpoint exposed on backend API for residents
    }

    if (!showEdit && !showDelete) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (showDelete) ...[
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.errorLight,
                    foregroundColor: AppColor.errorDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Hapus'),
                  onPressed: _confirmDelete,
                ),
              ),
              if (showEdit) const SizedBox(width: 16),
            ],
            if (showEdit)
              Expanded(
                flex: showDelete ? 1 : 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit'),
                  onPressed: () {
                    Get.toNamed('/data/form', arguments: {
                      'type': type,
                      'model': type == 'house' ? house : resident,
                    })?.then((updated) {
                      if (updated == true) {
                        _loadDetails();
                      }
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          type == 'house'
              ? 'Apakah kamu yakin ingin menghapus data rumah ini?'
              : 'Apakah kamu yakin ingin menghapus data warga ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.error),
            onPressed: () async {
              Get.back(); // close dialog
              setState(() {
                isLoading = true;
              });

              bool success = false;
              if (type == 'resident') {
                success = await controller.deleteResident(id);
              } else if (type == 'house') {
                success = await controller.deleteHouse(id);
              }

              if (success) {
                Get.back(result: true); // go back to list
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // --- Translation Mappers ---

  String _getFamilyRoleLabel(String? role) {
    switch (role) {
      case 'head':
        return 'Kepala Keluarga';
      case 'wife':
        return 'Istri';
      case 'child':
        return 'Anak';
      case 'other_member':
        return 'Anggota Lain';
      default:
        return role ?? '-';
    }
  }

  String _getReligionLabel(String? religion) {
    switch (religion) {
      case 'islam':
        return 'Islam';
      case 'christian':
        return 'Kristen';
      case 'catholic':
        return 'Katolik';
      case 'buddhist':
        return 'Buddha';
      case 'confucianism':
        return 'Khonghucu';
      case 'hindu':
        return 'Hindu';
      default:
        return religion ?? '-';
    }
  }

  String _getEducationLabel(String? edu) {
    switch (edu) {
      case 'no_schooling':
        return 'Tidak Sekolah';
      case 'elementary':
        return 'SD';
      case 'junior_high':
        return 'SMP';
      case 'senior_high':
        return 'SMA';
      case 'bachelor_or_diploma':
        return 'Sarjana/Diploma';
      default:
        return edu ?? '-';
    }
  }

  String _getOccupationLabel(String? occ) {
    switch (occ) {
      case 'unemployed':
        return 'Tidak Bekerja';
      case 'student':
        return 'Pelajar';
      case 'housewife':
        return 'Ibu Rumah Tangga';
      case 'employee':
        return 'Pegawai';
      case 'entrepreneur':
        return 'Wirausaha';
      case 'laborer':
        return 'Buruh';
      case 'other':
        return 'Lainnya';
      default:
        return occ ?? '-';
    }
  }
}
