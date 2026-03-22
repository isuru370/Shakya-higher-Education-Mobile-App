import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/student_classes/student_classes_bloc.dart';

class StudentViewClasses extends StatelessWidget {
  final String token;
  const StudentViewClasses({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentClassesBloc, StudentClassesState>(
      builder: (context, state) {
        if (state is StudentClassesLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Classes'),
              backgroundColor: AppTheme.primaryColor,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is StudentClassesLoaded ||
            state is StudentClassStatusChanged) {
          final classes = (state is StudentClassesLoaded
              ? state.response.data
              : (context.read<StudentClassesBloc>().state
                        as StudentClassesLoaded)
                    .response
                    .data);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Student Classes'),
              backgroundColor: AppTheme.primaryColor,
            ),
            body: classes.isEmpty
                ? const Center(child: Text("No Classes Found"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    itemCount: classes.length,
                    itemBuilder: (context, index) {
                      final item = classes[index];
                      final studentClass = item.studentClass;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Class title
                              Text(
                                '${studentClass.className} • Grade ${studentClass.grade.gradeName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Teacher: ${studentClass.teacher.firstName} ${studentClass.teacher.lastName}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Subject: ${studentClass.subject.subjectName}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Category: ${item.classCategory.categoryName}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),

                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: item.status
                                      ? AppTheme.primaryColor.withValues(
                                          alpha: 0.1,
                                        )
                                      : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.status ? "Active" : "Inactive",
                                      style: TextStyle(
                                        color: item.status
                                            ? AppTheme.primaryColor
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.isFreeCard ? 'Free Card' : 'Paid',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Student info
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                      item.student.imgUrl,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.student.initialName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Status: ${item.student.studentStatus ? "Active" : "Inactive"}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Fee & Join info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Joined: ${item.joinedDate}'),
                                  Text(
                                    'Fee: LKR ${item.classCategoryHasStudentClass.classFee}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // 🔹 Modern Payment & Attendance Buttons
                              Row(
                                children: [
                                  if (!item.isFreeCard)
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppTheme.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        icon: const Icon(Icons.payment),
                                        label: const Text('Payment'),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/payment-history',
                                            arguments: {
                                              'student_id': item.studentId,
                                              'student_student_class_id':
                                                  item.studentStudentClassId,
                                              'token': token,
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  if (!item.isFreeCard)
                                    const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      icon: const Icon(Icons.check_circle),
                                      label: const Text('Attend'),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/attendance-history',
                                          arguments: {
                                            'class_category_has_student_class_id':
                                                item.classCategoryHasStudentClassId,
                                            'student_id': item.studentId,
                                            'token': token,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orangeAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      icon: const Icon(Icons.check_circle),
                                      label: const Text('Tute'),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/tute',
                                          arguments: {
                                            'class_category_has_student_class_id':
                                                item.classCategoryHasStudentClassId,
                                            'student_id': item.studentId,
                                            'token': token,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Student Classes'),
            backgroundColor: AppTheme.primaryColor,
          ),
          body: const Center(child: Text("No Classes Found")),
        );
      },
    );
  }
}
