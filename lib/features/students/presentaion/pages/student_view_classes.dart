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
          final blocState = context.read<StudentClassesBloc>().state;

          final classes = state is StudentClassesLoaded
              ? state.response.data
              : blocState is StudentClassesLoaded
              ? blocState.response.data
              : <dynamic>[];

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
                              Text(
                                '${studentClass.className} • ${studentClass.grade.gradeName}',
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

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: item.status
                                      ? AppTheme.primaryColor.withValues(
                                          alpha: 0.08,
                                        )
                                      : Colors.red.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.inactiveText.isNotEmpty
                                            ? item.inactiveText.toUpperCase()
                                            : (item.status
                                                  ? 'ACTIVE'
                                                  : 'INACTIVE'),
                                        style: TextStyle(
                                          color: item.status
                                              ? AppTheme.primaryColor
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item.isFreeCard ? 'Free Card' : 'Paid',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        item.student.imgUrl.isNotEmpty
                                        ? NetworkImage(item.student.imgUrl)
                                        : null,
                                    child: item.student.imgUrl.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.student.fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.student.studentCustomId,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Student Status: ${item.student.studentStatus ? "Active" : "Inactive"}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Joined Date',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          item.joinedDate,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Default Fee',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          'LKR ${item.defaultFee.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Final Fee',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          'LKR ${item.finalFee.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: item.isFreeCard
                                                ? Colors.green
                                                : AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Fee Type',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          item.feeType,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (item.discountPercentage != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Discount',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            '${item.discountPercentage!.toStringAsFixed(2)}%',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

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
                                      icon: const Icon(Icons.menu_book),
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
