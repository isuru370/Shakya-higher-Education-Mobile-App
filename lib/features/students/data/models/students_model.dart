import 'package:nexorait_education_app/features/students/data/models/portal_login_model.dart';

import '../../../../core/constants/api_constants.dart';
import 'grade_model.dart';

class StudentModel {
  final int id;
  final String? temporaryQrCode;
  final String? temporaryQrCodeExpireDate;
  final int? quickImageId;
  final String? customId;
  final String fullName;
  final String initialName;
  final String mobile;
  final String? email;
  final String whatsappMobile;
  final String? nic;
  final String bday;
  final String gender;
  final String address1;
  final String? address2;
  final String? address3;

  final String guardianFname;
  final String guardianLname;
  final String guardianMobile;
  final String? guardianNic;

  final bool isActive;
  final String? imageUrl;
  final int gradeId;
  final String classType;
  final bool admission;
  final String? studentSchool;

  final String? createdAt;
  final String? updatedAt;

  final GradeModel? grade;
  final PortalLoginModel? portalLogin;
  final bool? permanentQrActive;
  final bool? studentDisable;

  StudentModel({
    required this.id,
    this.temporaryQrCode,
    this.temporaryQrCodeExpireDate,
    this.quickImageId,
    this.customId,
    required this.fullName,
    required this.initialName,
    required this.mobile,
    this.email,
    required this.whatsappMobile,
    this.nic,
    required this.bday,
    required this.gender,
    required this.address1,
    this.address2,
    this.address3,
    required this.guardianFname,
    required this.guardianLname,
    required this.guardianMobile,
    this.guardianNic,
    required this.isActive,
    this.imageUrl,
    required this.gradeId,
    required this.classType,
    required this.admission,
    this.studentSchool,
    this.createdAt,
    this.updatedAt,
    this.grade,
    this.portalLogin,
    this.permanentQrActive,
    this.studentDisable,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      temporaryQrCode: json['temporary_qr_code'] ?? '',
      temporaryQrCodeExpireDate: json['temporary_qr_code_expire_date'],
      customId: json['custom_id'],
      fullName: json['full_name'],
      initialName: json['initial_name'],
      mobile: json['mobile'],
      email: json['email'],
      whatsappMobile: json['whatsapp_mobile'],
      nic: json['nic'],
      bday: json['bday'],
      gender: json['gender'],
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      guardianFname: json['guardian_fname'],
      guardianLname: json['guardian_lname'],
      guardianMobile: json['guardian_mobile'],
      guardianNic: json['guardian_nic'],
      isActive: json['is_active'],
      imageUrl: json['img_url']?.toString().replaceFirst(
        'http://127.0.0.1:8000',
        ApiConstants.baseUrl,
      ),
      gradeId: json['grade_id'],
      classType: json['class_type'],
      admission: json['admission'],
      studentSchool: json['student_school'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      // ✅ FIX HERE
      grade: json['grade'] != null ? GradeModel.fromJson(json['grade']) : null,

      portalLogin: json['portal_login'] != null
          ? PortalLoginModel.fromJson(json['portal_login'])
          : null,

      permanentQrActive: json['permanent_qr_active'] ?? false,
      studentDisable: json['student_disable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temporary_qr_code': temporaryQrCode,
      'quick_image_id': quickImageId,
      'full_name': fullName,
      'initial_name': initialName,
      'mobile': mobile,
      'email': email,
      'whatsapp_mobile': whatsappMobile,
      'nic': nic,
      'bday': bday,
      'gender': gender,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'guardian_fname': guardianFname,
      'guardian_lname': guardianLname,
      'guardian_mobile': guardianMobile,
      'guardian_nic': guardianNic,
      'is_active': isActive,
      'img_url': imageUrl,
      'grade_id': gradeId,
      'class_type': classType,
      'admission': admission,
      'student_school': studentSchool,
    };
  }
}
