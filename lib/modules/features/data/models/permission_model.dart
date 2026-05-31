class PermissionModel {
  final bool residentsIndex;
  final bool residentsShow;
  final bool residentsStore;
  final bool residentsUpdate;
  final bool residentsDestroy;
  final bool housesIndex;
  final bool housesShow;
  final bool housesStore;
  final bool housesUpdate;
  final bool housesDestroy;
  final bool familiesIndex;
  final bool familiesShow;
  final bool myFamily;
  final bool myFamilyMembersStore;
  final bool myFamilyMembersUpdate;

  PermissionModel({
    this.residentsIndex = false,
    this.residentsShow = false,
    this.residentsStore = false,
    this.residentsUpdate = false,
    this.residentsDestroy = false,
    this.housesIndex = false,
    this.housesShow = false,
    this.housesStore = false,
    this.housesUpdate = false,
    this.housesDestroy = false,
    this.familiesIndex = false,
    this.familiesShow = false,
    this.myFamily = false,
    this.myFamilyMembersStore = false,
    this.myFamilyMembersUpdate = false,
  });

  /// Whether the user has access to the general data tabs (Warga/Rumah/Keluarga)
  bool get hasDataAccess =>
      residentsIndex || housesIndex || familiesIndex;

  /// Whether the user only has my-family access (resident/treasurer)
  bool get hasOnlyMyFamilyAccess => !hasDataAccess && myFamily;

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      residentsIndex: json['residents_index'] as bool? ?? false,
      residentsShow: json['residents_show'] as bool? ?? false,
      residentsStore: json['residents_store'] as bool? ?? false,
      residentsUpdate: json['residents_update'] as bool? ?? false,
      residentsDestroy: json['residents_destroy'] as bool? ?? false,
      housesIndex: json['houses_index'] as bool? ?? false,
      housesShow: json['houses_show'] as bool? ?? false,
      housesStore: json['houses_store'] as bool? ?? false,
      housesUpdate: json['houses_update'] as bool? ?? false,
      housesDestroy: json['houses_destroy'] as bool? ?? false,
      familiesIndex: json['families_index'] as bool? ?? false,
      familiesShow: json['families_show'] as bool? ?? false,
      myFamily: json['my_family'] as bool? ?? false,
      myFamilyMembersStore: json['my_family_members_store'] as bool? ?? false,
      myFamilyMembersUpdate: json['my_family_members_update'] as bool? ?? false,
    );
  }
}
