import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/students_model.dart';
import '../bloc/students/students_bloc.dart';
import 'single_student_view_page.dart';

class StudentListPage extends StatefulWidget {
  final String token;

  const StudentListPage({super.key, required this.token});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedGrade;

  List<StudentModel> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    final studentsBloc = context.read<StudentsBloc>();
    studentsBloc.add(FetchStudents(widget.token));
  }

  void _filterStudents(List<StudentModel> students) {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredStudents = students.where((student) {
        final matchesName = (student.initialName)
            .toLowerCase()
            .contains(query);
        final matchesGrade =
            selectedGrade == null || student.grade?.gradeName == selectedGrade;
        return matchesName && matchesGrade;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is StudentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentsLoaded) {
            final students = state.students;

            // Initialize filteredStudents if empty
            if (filteredStudents.isEmpty) filteredStudents = students;

            return Column(
              children: [
                // ---------------- SEARCH BAR ----------------
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _filterStudents(students),
                    decoration: InputDecoration(
                      hintText: 'Search student...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                  ),
                ),

                // ---------------- GRADE FILTER DROPDOWN ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedGrade,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    hint: const Text('Filter by grade'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Grades'),
                      ),
                      ...students
                          .map((s) => s.grade?.gradeName)
                          .toSet()
                          .map(
                            (grade) => DropdownMenuItem(
                              value: grade,
                              child: Text(grade ?? 'Unknown Grade'),
                            ),
                          ),
                    ],
                    onChanged: (value) {
                      setState(() => selectedGrade = value);
                      _filterStudents(students);
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // ---------------- STUDENT LIST ----------------
                Expanded(
                  child: filteredStudents.isEmpty
                      ? const Center(
                          child: Text(
                            'No students found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredStudents.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SingleStudentViewPage(
                                      token: widget.token,
                                      student: student,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  leading: CircleAvatar(
                                    radius: 26,
                                    backgroundColor: AppTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    backgroundImage: student.imageUrl != null
                                        ? NetworkImage(student.imageUrl!)
                                        : null,
                                    child: student.imageUrl == null
                                        ? const Icon(
                                            Icons.person,
                                            color: AppTheme.primaryColor,
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    student.initialName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Grade: ${student.grade?.gradeName ?? 'N/A'} • ${student.mobile}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Text(
                                    student.customId ?? 'N/A',
                                    style: TextStyle(color: Colors.grey[500]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          if (state is StudentsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
