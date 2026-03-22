import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../qr/presentation/bloc/read_attendance/read_attendance_bloc.dart';
import '../bloc/attendance/attendance_bloc.dart';

class AttendancePage extends StatefulWidget {
  final ReadAttendanceLoaded attendanceState;
  final String token;

  const AttendancePage({
    super.key,
    required this.attendanceState,
    required this.token,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late List<bool> tuteChecked;

  @override
  void initState() {
    super.initState();
    tuteChecked = List<bool>.filled(
      widget.attendanceState.attendanceList.length,
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceList = widget.attendanceState.attendanceList;

    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceSuccess) {
          String message = '';
          if (!state.attendanceMarked) {
            message = 'Attendance was already marked today';
          } else if (state.attendanceMarked && state.tuteMarked) {
            message = 'Attendance and Tute marked successfully';
          } else if (state.attendanceMarked && !state.tuteMarked) {
            message = 'Attendance marked successfully';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: state.attendanceMarked
                  ? Colors.green
                  : Colors.orange,
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.popUntil(
              context,
              (route) => route.settings.name == '/qr-scan',
            );
          });
        }

        if (state is AttendanceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance Details'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: attendanceList.isEmpty
            ? const Center(child: Text('No attendance records available'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: attendanceList.length,
                itemBuilder: (context, index) {
                  final record = attendanceList[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- STUDENT INFO ----------------
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  record.student.imageUrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.student.initialName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Custom ID: ${record.student.customId}',
                                    ),
                                    Text(
                                      'Guardian: ${record.student.guardianMobile}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ---------------- CLASS INFO ----------------
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _badge(
                                'Class: ${record.studentClassName}',
                                Colors.blue.shade100,
                                Colors.blue,
                              ),
                              _badge(
                                'Category: ${record.categoryName}',
                                Colors.orange.shade100,
                                Colors.orange,
                              ),
                              _badge(
                                'Status: ${record.ongoingClass.isOngoing ? "Active" : "Inactive"}',
                                record.ongoingClass.isOngoing
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                record.ongoingClass.isOngoing
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // ---------------- LAST PAYMENT INFO ----------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Last Payment: ${record.paymentInfo?.lastPaymentDate ?? "No payments yet"}',
                                style: TextStyle(
                                  color:
                                      (record.paymentInfo?.paymentStatus ??
                                          false)
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                record.paymentInfo?.paymentFor != null
                                    ? ' (${record.paymentInfo!.paymentFor})'
                                    : '',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ---------------- TUTE TOGGLE ----------------
                          record.tuteInfo.hasTuteForThisMonth
                              ? Text(
                                  'Tute for ${record.tuteInfo.currentMonth} is available',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Switch(
                                      value: tuteChecked[index],
                                      onChanged: (value) {
                                        setState(() {
                                          tuteChecked[index] = value;
                                        });
                                      },
                                      activeThumbColor: AppTheme.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Mark Tute'),
                                  ],
                                ),
                          const SizedBox(height: 12),

                          // ---------------- MARK ATTENDANCE BUTTON ----------------
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<AttendanceBloc>().add(
                                  MarkAttendanceRequested(
                                    token: widget.token,
                                    studentId: record.student.id,
                                    studentClassId: record
                                        .studentStudentStudentClass
                                        .studentStudentStudentClassId,
                                    attendanceId: record.ongoingClass.id,
                                    tute: tuteChecked[index],
                                    classCategoryHasStudentClassId: record
                                        .ongoingClass
                                        .classCategoryHasStudentClassId,
                                    guardianMobile:
                                        record.student.guardianMobile,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Mark Attendance'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _badge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
