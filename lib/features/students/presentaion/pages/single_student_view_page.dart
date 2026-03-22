import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/students_model.dart';
import '../bloc/student_classes/student_classes_bloc.dart';
import 'student_view_classes.dart';

class SingleStudentViewPage extends StatelessWidget {
  final String token;
  final StudentModel student;

  const SingleStudentViewPage({
    super.key,
    required this.student,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentClassesBloc, StudentClassesState>(
      listener: (context, state) {
        if (state is StudentClassesLoading) {
          // Optionally show a loading indicator
          debugPrint('Loading student classes...');
        } else if (state is StudentClassesLoaded) {
          final classes = state.response.data;

          if (classes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No classes found for this student.'),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentViewClasses(token: token),
              ),
            );
          }
        } else if (state is StudentClassesError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(student.initialName),
          backgroundColor: AppTheme.primaryColor,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            context.read<StudentClassesBloc>().add(
              FetchStudentClasses(studentId: student.id, token: token),
            );
          },
          icon: const Icon(Icons.class_),
          label: const Text('View Classes'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- PROFILE AVATAR ----------------
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                  backgroundImage: student.imageUrl != null
                      ? NetworkImage(student.imageUrl!)
                      : null,
                  child: student.imageUrl == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: AppTheme.primaryColor,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  student.initialName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '${student.grade?.gradeName ?? 'N/A'} • ${student.classType} • ${student.temporaryQrCode}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // ---------------- INFO SECTIONS ----------------
              _buildSection('Contact Information', [
                _infoRow('Mobile', student.mobile),
                _infoRow('WhatsApp', student.whatsappMobile),
                _infoRow('Email', student.email ?? 'N/A'),
              ]),
              _buildSection('Personal Details', [
                _infoRow('Full Name', student.fullName),
                _infoRow(
                  'Birthday',
                  DateFormat('yyyy MM dd').format(DateTime.parse(student.bday)),
                ),
                _infoRow('Gender', student.gender),
                _infoRow('NIC', student.nic ?? 'N/A'),
              ]),
              _buildSection('Address', [
                _infoRow('Address 1', student.address1),
                _infoRow('Address 2', student.address2 ?? 'N/A'),
                _infoRow('Address 3', student.address3 ?? 'N/A'),
              ]),
              _buildSection('Guardian Information', [
                _infoRow(
                  'Name',
                  '${student.guardianFname} ${student.guardianLname}',
                ),
                _infoRow('Mobile', student.guardianMobile),
                _infoRow('NIC', student.guardianNic ?? 'N/A'),
              ]),
              _buildSection('Other Information', [
                _infoRow('Admission', student.admission ? 'Yes' : 'No'),
                _infoRow('Active', student.isActive ? 'Yes' : 'No'),
                _infoRow(
                  'Created At',
                  student.createdAt != null
                      ? DateFormat(
                          'yyyy MM dd HH:mm',
                        ).format(DateTime.parse(student.createdAt!).toLocal())
                      : 'N/A',
                ),

                _infoRow(
                  'Updated At',
                  student.updatedAt != null
                      ? DateFormat(
                          'yyyy MM dd HH:mm',
                        ).format(DateTime.parse(student.updatedAt!).toLocal())
                      : 'N/A',
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION BUILDER ----------------
  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- INFO ROW ----------------
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
