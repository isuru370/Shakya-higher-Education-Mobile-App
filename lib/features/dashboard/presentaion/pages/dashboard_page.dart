import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/scan_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/models/student_mini_model.dart';
import '../bloc/mobile_dashboard/mobile_dashboard_bloc.dart';
import '../bloc/sms/sms_bloc.dart';

class DashboardPage extends StatefulWidget {
  final String token;
  final UserModel userModel;
  const DashboardPage({
    super.key,
    required this.token,
    required this.userModel,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<MobileDashboardBloc>().add(
      GetMobileDashboardEvent(widget.token),
    );
    context.read<SmsBloc>().add(GetSmsBalanceEvent(token: widget.token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),

      // 🔥 BODY UPDATED (Everything else unchanged)
      body: BlocBuilder<MobileDashboardBloc, MobileDashboardState>(
        builder: (context, state) {
          if (state is MobileDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MobileDashboardError) {
            return Center(child: Text(state.message));
          }

          if (state is MobileDashboardLoaded) {
            final data = state.dashboard.data;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MobileDashboardBloc>().add(
                  GetMobileDashboardEvent(widget.token),
                );

                context.read<SmsBloc>().add(
                  GetSmsBalanceEvent(token: widget.token),
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 🔹 ICON + SEARCH STUDENT BUTTON (UNCHANGED FEATURE)
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.dashboard,
                          size: 64,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/qr-scan',
                              arguments: {
                                'scanType': ScanType.student,
                                'token': widget.token,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.primaryColor, // NexOra blue
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          icon: const Icon(Icons.search, size: 20),
                          label: const Text(
                            'Search Student',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Welcome to Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Use the menu to navigate',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 🔹 SUMMARY CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          title: "Daily Collection",
                          value:
                              "Rs. ${data.dailyCollection.toStringAsFixed(2)}",
                          icon: Icons.monetization_on,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCard(
                          title: "New Students",
                          value: data.todayRegisteredStudentsCount.toString(),
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  BlocBuilder<SmsBloc, SmsState>(
                    builder: (context, smsState) {
                      if (smsState is SmsLoading) {
                        return _buildCard(
                          title: "SMS Balance",
                          value: "Loading...",
                          icon: Icons.sms,
                          color: Colors.orange,
                        );
                      }

                      if (smsState is SmsLoaded) {
                        return _buildCard(
                          title: "SMS Balance",
                          value: smsState.response.data.currentBalance,
                          icon: Icons.sms,
                          color: Colors.orange,
                        );
                      }

                      if (smsState is SmsError) {
                        return _buildCard(
                          title: "SMS Balance",
                          value: "Unavailable",
                          icon: Icons.sms_failed,
                          color: Colors.red,
                        );
                      }

                      return _buildCard(
                        title: "SMS Balance",
                        value: "--",
                        icon: Icons.sms,
                        color: Colors.orange,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Today's Classes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  ...data.todayClasses.map(
                    (classItem) => _buildClassCard(classItem),
                  ),

                  const Text(
                    "Today's Registered Students",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  ...data.todayRegisteredStudents.map(
                    (registeredStudent) =>
                        _buildStudentRegisteredCard(registeredStudent),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CLASS CARD ----------------

  Widget _buildClassCard(classItem) {
    if (classItem.length == 0) {
      return _buildEmptyBox("No Class Data");
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classItem.subjectName ?? "-",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${classItem.gradeName ?? '-'} - ${classItem.className ?? '-'}",
                        ),
                        const SizedBox(height: 6),
                        Text("Hall: ${classItem.hallName ?? '-'}"),
                        const SizedBox(height: 6),
                        Text(
                          "${classItem.startTime ?? '-'} - ${classItem.endTime ?? '-'}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  if (classItem.status == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/today-attendance',
                              arguments: {
                                'class_id': classItem.classId,
                                'attendance_id': classItem.attendanceId,
                                'class_has_category_id':
                                    classItem.classCategory?.id,
                                'token': widget.token,
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "View Attendance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (classItem.isOngoing == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "ONGOING",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- STUDENT REGISTERED CARD ----------------
  Widget _buildStudentRegisteredCard(StudentMiniModel? student) {
    if (student == null) {
      return _buildEmptyBox("No Student Data");
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
              backgroundImage:
                  (student.imgUrl != null && student.imgUrl!.isNotEmpty)
                  ? NetworkImage(student.imgUrl!)
                  : null,
              child: (student.imgUrl == null || student.imgUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.blue)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.initialName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: ${student.customId}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (student.classType != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            student.classType!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: student.admission ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          student.admission ? "Admitted" : "Not Admitted",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBox(String message) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, color: Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          /// Scrollable menu area
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerHeader(),

                _buildMenuItem(
                  context,
                  icon: Icons.person_add,
                  title: 'Create Student',
                  onTap: () => _navigateToCreateStudent(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.add_home_outlined,
                  title: 'Add Classes',
                  onTap: () => _navigateToAddStudentClass(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  title: 'Student',
                  onTap: () => _navigateToStudent(context),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.card_membership,
                  title: 'Student ID Numbers',
                  onTap: () => _navigateToStudentIdNumbers(context),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.camera,
                  title: 'Capture Image',
                  onTap: () => _navigateToCaptureImage(context),
                ),
                const Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.menu_book,
                  title: 'Mark Tute',
                  onTap: () => _navigateToMarkTute(context),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.people_alt_rounded,
                  title: 'Attendance',
                  onTap: () => _navigateToAttendance(context),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.monetization_on,
                  title: 'Payments',
                  onTap: () => _navigateToPayments(context),
                ),

                const Divider(),

                _buildMenuItem(
                  context,
                  icon: Icons.qr_code,
                  title: 'Temporary Qr',
                  onTap: () => _navigateToTempQrPage(context),
                ),

                if (widget.userModel.email == "admin@nexorait.lk") ...[
                  _buildMenuItem(
                    context,
                    icon: Icons.local_activity,
                    title: 'Activated Qr',
                    onTap: () => _navigateToActiveQrPage(context),
                  ),
                ],

                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Profile',
                  onTap: () => _navigateToUserProfile(context),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  isLogout: true,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),

          /// Bottom Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: const [
                Divider(),
                SizedBox(height: 8),
                Text(
                  "Version 3.1.0",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  "© 2026 NexOra. All rights reserved.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // Blue
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/logo/black_logo.png', height: 140),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isLogout
          ? null
          : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      tileColor: isLogout ? Colors.red.withValues(alpha: 0.05) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _navigateToCreateStudent(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(
      context,
      '/students_image_upload',
      arguments: widget.token,
    );
  }

  void _navigateToAddStudentClass(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(
      context,
      '/qr-scan',
      arguments: {'scanType': ScanType.classes, 'token': widget.token},
    );
  }

  void _navigateToStudent(BuildContext context) {
    Navigator.pop(context); // Close drawer

    Navigator.pushNamed(
      context,
      '/students',
      arguments: widget.token, // ✅ token pass කරනවා
    );
  }

  void _navigateToActiveQrPage(BuildContext context) {
    Navigator.pop(context); // Close drawer

    Navigator.pushNamed(
      context,
      '/active-qr',
      arguments: widget.token, // ✅ token pass කරනවා
    );
  }

  void _navigateToStudentIdNumbers(BuildContext context) {
    Navigator.pop(context); // Close drawer

    Navigator.pushNamed(
      context,
      '/student-id-numbers',
      arguments: widget.token, // ✅ token pass කරනවා
    );
  }

  void _navigateToCaptureImage(BuildContext context) {
    Navigator.pop(context); // Close drawer

    Navigator.pushNamed(
      context,
      '/image_capture',
      arguments: widget.token, // ✅ token pass කරනවා
    );
  }

  void _navigateToMarkTute(BuildContext context) {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      '/qr-scan',
      arguments: {'scanType': ScanType.tute, 'token': widget.token},
    );
  }

  void _navigateToAttendance(BuildContext context) {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      '/qr-scan',
      arguments: {'scanType': ScanType.attendance, 'token': widget.token},
    );
  }

  void _navigateToPayments(BuildContext context) async {
    Navigator.pop(context);

    Navigator.pushNamed(
      context,
      '/qr-scan',
      arguments: {'scanType': ScanType.payment, 'token': widget.token},
    );
  }

  void _navigateToTempQrPage(BuildContext context) async {
    Navigator.pop(context);

    Navigator.pushNamed(context, '/temp_qr_page', arguments: widget.token);
  }

  void _navigateToUserProfile(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(
      context,
      '/user-profile',
      arguments: {
        'token': widget.token,
        'user_model': widget.userModel,
      }, // ✅ token pass කරනවා
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pop(context); // Close drawer

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
