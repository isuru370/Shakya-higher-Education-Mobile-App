import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/class_status_request_model.dart';

import '../../../qr/data/model/read_student_classes/read_student_classes_response_model.dart';
import '../../../student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';
import '../../../students/data/models/student_classes_model/create_student_request_class_model.dart';
import '../../../students/presentaion/bloc/student_classes/student_classes_bloc.dart';
import '../../data/models/class_category_model.dart';
import '../../data/models/class_room_item_model.dart';
import '../bloc/class_room/class_room_bloc.dart';

class CreateStudentClasses extends StatefulWidget {
  final String token;
  final ReadStudentClassesResponseModel readStudentClassesState;

  const CreateStudentClasses({
    super.key,
    required this.token,
    required this.readStudentClassesState,
  });

  @override
  State<CreateStudentClasses> createState() => _CreateStudentClassesState();
}

class _CreateStudentClassesState extends State<CreateStudentClasses>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? _selectedGradeId;
  int? _selectedClassId;
  int? _selectedCategoryHasStudentClassId;
  int? _updatingClassId;
  bool _isStudentFreeCard = false;

  List<ClassRoomItemModel> _availableClasses = [];
  List<ClassCategoryModel> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    context.read<StudentGradeBloc>().add(
      GetStudentGradesEvent(token: widget.token),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetSelectionsAfterGradeChange(int? gradeId) {
    setState(() {
      _selectedGradeId = gradeId;
      _selectedClassId = null;
      _selectedCategoryHasStudentClassId = null;
      _availableClasses = [];
      _availableCategories = [];
    });
  }

  void _resetFormAfterSuccess() {
    setState(() {
      _selectedGradeId = null;
      _selectedClassId = null;
      _selectedCategoryHasStudentClassId = null;
      _availableClasses = [];
      _availableCategories = [];
      _isStudentFreeCard = false;
    });
  }

  List<ClassRoomItemModel> _extractClassesFromGradeData(
    Map<String, List<ClassRoomItemModel>> gradeData,
  ) {
    final allClasses = gradeData.values.expand((e) => e).toList();

    final Map<int, ClassRoomItemModel> uniqueClasses = {};
    for (final item in allClasses) {
      uniqueClasses[item.classId] = item;
    }

    return uniqueClasses.values.toList();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.readStudentClassesState.data.student;

    return MultiBlocListener(
      listeners: [
        BlocListener<ClassRoomBloc, ClassRoomState>(
          listener: (context, state) {
            if (state is ClassRoomLoaded) {
              final gradeKey = _selectedGradeId?.toString();
              if (gradeKey == null) return;

              final gradeData = state.response.data[gradeKey] ?? {};
              final loadedClasses = _extractClassesFromGradeData(gradeData);

              if (!mounted) return;

              setState(() {
                _availableClasses = loadedClasses;
                _availableCategories = [];
                _selectedClassId = null;
                _selectedCategoryHasStudentClassId = null;
              });
            }
          },
        ),
        BlocListener<StudentClassesBloc, StudentClassesState>(
          listener: (context, state) {
            if (state is CreateStudentClassSuccess) {
              _showSnack(state.response.message);
              _resetFormAfterSuccess();
            } else if (state is StudentClassStatusChanged) {
              setState(() {
                _updatingClassId = null;
              });

              _showSnack(state.message);
            } else if (state is StudentClassesError) {
              setState(() {
                _updatingClassId = null;
              });

              _showSnack(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7fb),
        appBar: AppBar(
          title: const Text('Student Classes'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildStudentHeader(student),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Add Class'),
                  Tab(text: 'View Classes'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAddClassSection(), _buildViewClassesSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader(dynamic student) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff2563eb), Color(0xff1d4ed8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage:
                student.imageUrl != null &&
                    student.imageUrl.toString().isNotEmpty
                ? NetworkImage(student.imageUrl)
                : null,
            child:
                (student.imageUrl == null ||
                    student.imageUrl.toString().isEmpty)
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.initialName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${student.customId}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  'Guardian: ${student.guardianMobile ?? '-'}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddClassSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assign New Class',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Select Grade',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                BlocBuilder<StudentGradeBloc, StudentGradeState>(
                  builder: (context, state) {
                    if (state is StudentGradeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is StudentGradeLoaded) {
                      return DropdownButtonFormField<int>(
                        value: _selectedGradeId,
                        decoration: InputDecoration(
                          hintText: 'Choose a grade',
                          filled: true,
                          fillColor: const Color(0xfff8fafc),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: state.grades.map((grade) {
                          return DropdownMenuItem<int>(
                            value: grade.gradeId,
                            child: Text('Grade ${grade.gradeName}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _resetSelectionsAfterGradeChange(value);

                          if (value != null) {
                            context.read<ClassRoomBloc>().add(
                              LoadClassesByGradeEvent(
                                token: widget.token,
                                gradeId: value.toString(),
                              ),
                            );
                          }
                        },
                      );
                    }

                    if (state is StudentGradeError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 16),

                const Text(
                  'Select Class',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                BlocBuilder<ClassRoomBloc, ClassRoomState>(
                  builder: (context, state) {
                    if (_selectedGradeId == null) {
                      return DropdownButtonFormField<int>(
                        value: null,
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: 'Select grade first',
                          filled: true,
                          fillColor: const Color(0xfff8fafc),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [],
                        onChanged: null,
                      );
                    }

                    if (state is ClassRoomLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ClassRoomError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      );
                    }

                    return DropdownButtonFormField<int>(
                      value: _selectedClassId,
                      isExpanded: true,
                      itemHeight: null,
                      decoration: InputDecoration(
                        hintText: _availableClasses.isEmpty
                            ? 'No classes available'
                            : 'Choose a class',
                        filled: true,
                        fillColor: const Color(0xfff8fafc),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      selectedItemBuilder: (context) {
                        return _availableClasses.map((classItem) {
                          final teacherName =
                              '${classItem.teacherFname ?? ''} ${classItem.teacherLname ?? ''}'
                                  .trim();

                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              teacherName.isEmpty
                                  ? '${classItem.className} (${classItem.medium})'
                                  : '${classItem.className} (${classItem.medium}) - $teacherName',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList();
                      },
                      items: _availableClasses.map((classItem) {
                        final teacherName =
                            '${classItem.teacherFname ?? ''} ${classItem.teacherLname ?? ''}'
                                .trim();

                        return DropdownMenuItem<int>(
                          value: classItem.classId,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${classItem.className} (${classItem.medium})',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (teacherName.isNotEmpty)
                                  Text(
                                    teacherName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _availableClasses.isEmpty
                          ? null
                          : (value) {
                              ClassRoomItemModel? selectedClass;

                              try {
                                selectedClass = _availableClasses.firstWhere(
                                  (e) => e.classId == value,
                                );
                              } catch (_) {
                                selectedClass = null;
                              }

                              setState(() {
                                _selectedClassId = value;
                                _availableCategories =
                                    selectedClass?.categories ?? [];
                                _selectedCategoryHasStudentClassId = null;
                              });
                            },
                    );
                  },
                ),

                const SizedBox(height: 16),

                const Text(
                  'Select Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<int>(
                  value: _selectedCategoryHasStudentClassId,
                  decoration: InputDecoration(
                    hintText: _selectedClassId == null
                        ? 'Select class first'
                        : _availableCategories.isEmpty
                        ? 'No categories available'
                        : 'Choose a category',
                    filled: true,
                    fillColor: const Color(0xfff8fafc),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _availableCategories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.classCategoryHasStudentClassId,
                      child: Text(
                        '${category.categoryName} - LKR ${category.fees}',
                      ),
                    );
                  }).toList(),
                  onChanged: _availableCategories.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedCategoryHasStudentClassId = value;
                          });
                        },
                ),

                const SizedBox(height: 16),

                const Text(
                  'Student Free Card',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfff8fafc),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isStudentFreeCard ? 'Enabled' : 'Disabled',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _isStudentFreeCard
                                ? Colors.green
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isStudentFreeCard,
                        onChanged: (value) {
                          setState(() {
                            _isStudentFreeCard = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                BlocBuilder<StudentClassesBloc, StudentClassesState>(
                  builder: (context, state) {
                    final isLoading = state is StudentClassesLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_selectedGradeId == null) {
                                  _showSnack('Please select a grade');
                                  return;
                                }

                                if (_selectedClassId == null) {
                                  _showSnack('Please select a class');
                                  return;
                                }

                                if (_selectedCategoryHasStudentClassId ==
                                    null) {
                                  _showSnack('Please select a category');
                                  return;
                                }

                                context.read<StudentClassesBloc>().add(
                                  SubmitCreateStudentClass(
                                    request: CreateStudentClassRequestModel(
                                      token: widget.token,
                                      studentId: widget
                                          .readStudentClassesState
                                          .data
                                          .student
                                          .id,
                                      studentClassesId: _selectedClassId!,
                                      classCategoryHasStudentClassId:
                                          _selectedCategoryHasStudentClassId!,
                                      status: 1,
                                      isFreeCard: _isStudentFreeCard,
                                    ),
                                  ),
                                );
                              },
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.add),
                        label: Text(isLoading ? 'Adding...' : 'Add Class'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewClassesSection() {
    return BlocBuilder<StudentClassesBloc, StudentClassesState>(
      builder: (context, state) {
        List<dynamic> classes = widget.readStudentClassesState.data.classes;

        if (state is StudentClassesLoaded) {
          classes = state.response.data;
        }

        final activeClasses = classes.where((e) => e.status == true).toList();
        final inactiveClasses = classes
            .where((e) => e.status == false)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                title: 'Active Classes',
                count: activeClasses.length,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              activeClasses.isEmpty
                  ? _buildEmptyCard('No active classes')
                  : Column(
                      children: activeClasses
                          .map((item) => _buildClassCard(item, true))
                          .toList(),
                    ),
              const SizedBox(height: 20),
              _buildSectionTitle(
                title: 'Inactive Classes',
                count: inactiveClasses.length,
                color: Colors.red,
              ),
              const SizedBox(height: 10),
              inactiveClasses.isEmpty
                  ? _buildEmptyCard('No inactive classes')
                  : Column(
                      children: inactiveClasses
                          .map((item) => _buildClassCard(item, false))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildClassCard(dynamic item, bool isActive) {
    final studentClass = item.studentClass;
    final category = item.classCategory;
    final isUpdatingThisCard =
        _updatingClassId == item.studentStudentStudentClassesId;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive
              ? Colors.green.withValues(alpha: 0.25)
              : Colors.red.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        studentClass.className,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '(Grade ${item.readStudentGrade.gradeName})',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.category_outlined, 'Category', category.categoryName),
          _infoRow(Icons.language, 'Medium', studentClass.medium),
          _infoRow(Icons.payments_outlined, 'Fees', 'LKR ${category.fees}'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isUpdatingThisCard
                      ? null
                      : () {
                          setState(() {
                            _updatingClassId =
                                item.studentStudentStudentClassesId;
                          });

                          context.read<StudentClassesBloc>().add(
                            ChangeStudentClassStatus(
                              classStatusRequest: ClassStatusRequestModel(
                                studentStudentStudentClassId:
                                    item.studentStudentStudentClassesId,
                                token: widget.token,
                              ),
                              studentId: widget
                                  .readStudentClassesState
                                  .data
                                  .student
                                  .id,
                            ),
                          );
                        },
                  icon: isUpdatingThisCard
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(isActive ? Icons.block : Icons.check_circle),
                  label: Text(
                    isUpdatingThisCard
                        ? 'Updating...'
                        : (isActive ? 'Deactivate' : 'Activate'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
        ),
      ),
    );
  }
}
