import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jawara_mobile/modules/features/data/controllers/data_controller.dart';
import 'package:jawara_mobile/modules/features/data/models/house_model.dart';
import 'package:jawara_mobile/modules/features/data/models/resident_model.dart';
import 'package:jawara_mobile/shared/styles/app_color.dart';
import 'package:jawara_mobile/shared/styles/app_text_style.dart';

class DataFormScreen extends StatefulWidget {
  const DataFormScreen({super.key});

  @override
  State<DataFormScreen> createState() => _DataFormScreenState();
}

class _DataFormScreenState extends State<DataFormScreen> {
  final DataController controller = DataController.to;
  final _formKey = GlobalKey<FormState>();

  late final String type;
  late final bool isEdit;
  dynamic model; // ResidentModel or HouseModel

  bool isSubmitting = false;

  // Form Fields - Citizens / Family Members
  int? selectedFamilyId;
  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final birthplaceController = TextEditingController();
  DateTime? birthdate;
  String? selectedGender;
  String? selectedReligion;
  String? selectedBloodType;
  String? selectedFamilyRole;
  String? selectedEducation;
  String? selectedOccupation;
  String? selectedActiveStatus;
  String? selectedLifeStatus;
  final phoneController = TextEditingController();

  // Form Fields - Houses
  final addressController = TextEditingController();
  String? selectedHouseStatus;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null || args['type'] == null) {
      Get.back();
      return;
    }

    type = args['type'] as String;
    model = args['model'];
    isEdit = model != null;

    _initializeFields();
  }

  void _initializeFields() {
    if (type == 'resident' || type == 'my_family_member') {
      if (isEdit && model is ResidentModel) {
        final r = model as ResidentModel;
        selectedFamilyId = r.familyId;
        nameController.text = r.name;
        nikController.text = r.nik ?? '';
        birthplaceController.text = r.birthplace ?? '';
        if (r.birthdate != null) {
          try {
            // Parse date from API. Standard format is "d M Y H" or "d F Y" (localized),
            // but let's check. Wait, in ResidentResource it returns "d M Y H".
            // If it fails to parse, it remains null. Let's try standard parsing.
            // A safer option is to support both.
            birthdate = DateFormat("d M y H").parse(r.birthdate!);
          } catch (_) {
            try {
              birthdate = DateFormat("d F y").parse(r.birthdate!);
            } catch (_) {
              try {
                birthdate = DateTime.parse(r.birthdate!);
              } catch (_) {}
            }
          }
        }
        selectedGender = r.gender;
        selectedReligion = r.religion;
        selectedBloodType = r.bloodType;
        selectedFamilyRole = r.familyRole;
        selectedEducation = r.lastEducation;
        selectedOccupation = r.occupation;
        selectedActiveStatus = r.activeStatus;
        selectedLifeStatus = r.lifeStatus;
        phoneController.text = r.phoneNumber ?? '';
      } else {
        // Defaults for store
        selectedActiveStatus = 'active';
        selectedLifeStatus = 'alive';
      }
    } else if (type == 'house') {
      if (isEdit && model is HouseModel) {
        final h = model as HouseModel;
        addressController.text = h.address;
        selectedHouseStatus = h.status;
      } else {
        selectedHouseStatus = 'available';
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    birthplaceController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
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
          isEdit ? 'Edit ${_getFormTypeName()}' : 'Tambah ${_getFormTypeName()}',
          style: AppTextStyle.headingMedium,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: type == 'house' ? _buildHouseForm() : _buildResidentForm(),
              ),
            ),
          ),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  String _getFormTypeName() {
    if (type == 'house') return 'Rumah';
    if (type == 'my_family_member') return 'Anggota Keluarga';
    return 'Warga';
  }

  // --- FORM: House (Rumah) ---
  Widget _buildHouseForm() {
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
            _buildLabel('Alamat Rumah'),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Masukkan alamat lengkap rumah',
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Alamat wajib diisi';
                }
                return null;
              },
            ),
            if (isEdit) ...[
              const SizedBox(height: 20),
              _buildLabel('Status Rumah'),
              DropdownButtonFormField<String>(
                value: selectedHouseStatus,
                decoration: const InputDecoration(
                  fillColor: AppColor.inputFill,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'available', child: Text('Tersedia')),
                  DropdownMenuItem(value: 'occupied', child: Text('Ditempati')),
                  DropdownMenuItem(value: 'inactive', child: Text('Nonaktif')),
                ],
                onChanged: (val) {
                  setState(() {
                    selectedHouseStatus = val;
                  });
                },
                validator: (val) => val == null ? 'Status wajib dipilih' : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- FORM: Resident (Warga & My Family Member) ---
  Widget _buildResidentForm() {
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
            if (type == 'resident') ...[
              _buildLabel('Pilih Keluarga'),
              Obx(() {
                return DropdownButtonFormField<int>(
                  value: selectedFamilyId,
                  decoration: const InputDecoration(
                    fillColor: AppColor.inputFill,
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: '-- Pilih Keluarga --',
                  ),
                  items: controller.familyOptions.map((f) {
                    return DropdownMenuItem(value: f.id, child: Text(f.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedFamilyId = val;
                    });
                  },
                  validator: (val) => val == null ? 'Keluarga wajib dipilih' : null,
                );
              }),
              const SizedBox(height: 20),
            ],
            _buildLabel('Nama Lengkap'),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Masukkan nama lengkap',
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('NIK (16 Digit)'),
            TextFormField(
              controller: nikController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: const InputDecoration(
                hintText: 'Masukkan 16 digit NIK',
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                counterText: '',
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'NIK wajib diisi';
                }
                if (val.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'NIK harus terdiri dari 16 digit angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildLabel('Tempat Lahir'),
            TextFormField(
              controller: birthplaceController,
              decoration: const InputDecoration(
                hintText: 'Masukkan tempat lahir',
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Tanggal Lahir'),
            InkWell(
              onTap: _pickBirthdate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  fillColor: AppColor.inputFill,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      birthdate == null ? 'Pilih tanggal lahir' : DateFormat('dd MMMM yyyy').format(birthdate!),
                      style: birthdate == null ? AppTextStyle.inputHint : AppTextStyle.bodyLarge,
                    ),
                    const Icon(Icons.calendar_month, color: AppColor.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Jenis Kelamin'),
            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Jenis Kelamin --',
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'female', child: Text('Perempuan')),
              ],
              onChanged: (val) => setState(() => selectedGender = val),
              validator: (val) => val == null ? 'Jenis kelamin wajib dipilih' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Peran Keluarga'),
            DropdownButtonFormField<String>(
              value: selectedFamilyRole,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Peran Keluarga --',
              ),
              // Restrict role options to non-head (wife, child, other_member)
              items: const [
                DropdownMenuItem(value: 'wife', child: Text('Istri')),
                DropdownMenuItem(value: 'child', child: Text('Anak')),
                DropdownMenuItem(value: 'other_member', child: Text('Anggota Lain')),
              ],
              onChanged: (val) => setState(() => selectedFamilyRole = val),
              validator: (val) => val == null ? 'Peran keluarga wajib dipilih' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('Nomor HP (format: 08xxxxxxxxxx)'),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Masukkan nomor HP aktif',
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val != null && val.isNotEmpty) {
                  if (!RegExp(r'^08[0-9]{8,11}$').hasMatch(val)) {
                    return 'Format nomor HP tidak valid (08xxxxxxxxxx)';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildLabel('Agama'),
            DropdownButtonFormField<String>(
              value: selectedReligion,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Agama --',
              ),
              items: const [
                DropdownMenuItem(value: 'islam', child: Text('Islam')),
                DropdownMenuItem(value: 'christian', child: Text('Kristen')),
                DropdownMenuItem(value: 'catholic', child: Text('Katolik')),
                DropdownMenuItem(value: 'buddhist', child: Text('Buddha')),
                DropdownMenuItem(value: 'confucianism', child: Text('Khonghucu')),
                DropdownMenuItem(value: 'hindu', child: Text('Hindu')),
              ],
              onChanged: (val) => setState(() => selectedReligion = val),
            ),
            const SizedBox(height: 20),
            _buildLabel('Golongan Darah'),
            DropdownButtonFormField<String>(
              value: selectedBloodType,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Golongan Darah --',
              ),
              items: const [
                DropdownMenuItem(value: 'a', child: Text('A')),
                DropdownMenuItem(value: 'b', child: Text('B')),
                DropdownMenuItem(value: 'ab', child: Text('AB')),
                DropdownMenuItem(value: 'o', child: Text('O')),
              ],
              onChanged: (val) => setState(() => selectedBloodType = val),
            ),
            const SizedBox(height: 20),
            _buildLabel('Pendidikan Terakhir'),
            DropdownButtonFormField<String>(
              value: selectedEducation,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Pendidikan --',
              ),
              items: const [
                DropdownMenuItem(value: 'no_schooling', child: Text('Tidak Sekolah')),
                DropdownMenuItem(value: 'elementary', child: Text('SD')),
                DropdownMenuItem(value: 'junior_high', child: Text('SMP')),
                DropdownMenuItem(value: 'senior_high', child: Text('SMA')),
                DropdownMenuItem(value: 'bachelor_or_diploma', child: Text('Sarjana/Diploma')),
              ],
              onChanged: (val) => setState(() => selectedEducation = val),
            ),
            const SizedBox(height: 20),
            _buildLabel('Pekerjaan'),
            DropdownButtonFormField<String>(
              value: selectedOccupation,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
                hintText: '-- Pilih Pekerjaan --',
              ),
              items: const [
                DropdownMenuItem(value: 'unemployed', child: Text('Tidak Bekerja')),
                DropdownMenuItem(value: 'student', child: Text('Pelajar')),
                DropdownMenuItem(value: 'housewife', child: Text('Ibu Rumah Tangga')),
                DropdownMenuItem(value: 'employee', child: Text('Pegawai')),
                DropdownMenuItem(value: 'entrepreneur', child: Text('Wirausaha')),
                DropdownMenuItem(value: 'laborer', child: Text('Buruh')),
                DropdownMenuItem(value: 'other', child: Text('Lainnya')),
              ],
              onChanged: (val) => setState(() => selectedOccupation = val),
            ),
            const SizedBox(height: 20),
            _buildLabel('Status Keaktifan'),
            DropdownButtonFormField<String>(
              value: selectedActiveStatus,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Aktif')),
                DropdownMenuItem(value: 'inactive', child: Text('Nonaktif')),
              ],
              onChanged: (val) => setState(() => selectedActiveStatus = val),
            ),
            const SizedBox(height: 20),
            _buildLabel('Status Jiwa'),
            DropdownButtonFormField<String>(
              value: selectedLifeStatus,
              decoration: const InputDecoration(
                fillColor: AppColor.inputFill,
                filled: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'alive', child: Text('Hidup')),
                DropdownMenuItem(value: 'deceased', child: Text('Wafat')),
              ],
              onChanged: (val) => setState(() => selectedLifeStatus = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: AppTextStyle.labelLarge.copyWith(color: AppColor.textPrimary)),
    );
  }

  Future<void> _pickBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthdate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        birthdate = picked;
      });
    }
  }

  Widget _buildSubmitButton() {
    return Container(
      color: AppColor.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: isSubmitting ? null : _submitForm,
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: AppColor.onPrimary, strokeWidth: 2),
                  )
                : const Text('Simpan'),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    bool success = false;

    if (type == 'house') {
      final payload = {
        'address': addressController.text.trim(),
        if (isEdit) 'status': selectedHouseStatus,
      };

      if (isEdit) {
        success = await controller.editHouse(model.id, payload);
      } else {
        success = await controller.createHouse(payload);
      }
    } else {
      // resident or my_family_member
      final payload = {
        if (type == 'resident') 'family_id': selectedFamilyId,
        'name': nameController.text.trim(),
        'nik': nikController.text.trim(),
        'birthplace': birthplaceController.text.trim(),
        'birthdate': birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : null,
        'gender': selectedGender,
        'religion': selectedReligion,
        'blood_type': selectedBloodType,
        'family_role': selectedFamilyRole,
        'last_education': selectedEducation,
        'occupation': selectedOccupation,
        'active_status': selectedActiveStatus,
        'life_status': selectedLifeStatus,
        'phone_number': phoneController.text.trim(),
      };

      if (type == 'resident') {
        if (isEdit) {
          success = await controller.editResident(model.id, payload);
        } else {
          success = await controller.createResident(payload);
        }
      } else {
        // my_family_member
        if (isEdit) {
          success = await controller.editMyFamilyMember(model.id, payload);
        } else {
          success = await controller.createMyFamilyMember(payload);
        }
      }
    }

    setState(() {
      isSubmitting = false;
    });

    if (success) {
      Get.back(result: true); // Return true to indicate reload needed
    }
  }
}
