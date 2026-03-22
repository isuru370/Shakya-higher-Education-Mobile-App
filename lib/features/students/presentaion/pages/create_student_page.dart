import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';
import '../../data/models/students_model.dart';
import '../bloc/students/students_bloc.dart';

class CreateStudentPage extends StatefulWidget {
  final String token;
  final int? quickImageId;
  final String imageUrl;

  const CreateStudentPage({
    super.key,
    required this.token,
    this.quickImageId,
    required this.imageUrl,
  });

  @override
  State<CreateStudentPage> createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final _temporaryQrCodeController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicController = TextEditingController();
  final _bdayController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _address3Controller = TextEditingController();
  final _guardianFnameController = TextEditingController();
  final _guardianLnameController = TextEditingController();
  final _guardianMobileController = TextEditingController();
  final _guardianNicController = TextEditingController();
  final _studentSchool = TextEditingController();

  int? _selectedGradeId;
  String _selectedGender = 'male';
  String _selectClassType = 'offline';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    context.read<StudentGradeBloc>().add(
      GetStudentGradesEvent(token: widget.token),
    );
  }

  @override
  void dispose() {
    _temporaryQrCodeController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _mobileController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _nicController.dispose();
    _bdayController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _guardianFnameController.dispose();
    _guardianLnameController.dispose();
    _guardianMobileController.dispose();
    _guardianNicController.dispose();
    _studentSchool.dispose();
    super.dispose();
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 10),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      _bdayController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _submitStudent() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGradeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select grade")));
      return;
    }

    setState(() => _isLoading = true);

    final student = StudentModel(
      id: 0,
      quickImageId: widget.quickImageId,
      customId: null,
      temporaryQrCode: _temporaryQrCodeController.text.trim(),
      fullName: _fnameController.text.trim(),
      initialName: _lnameController.text.trim(),
      mobile: _mobileController.text.trim(),
      whatsappMobile: _whatsappController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      nic: _nicController.text.trim().isEmpty
          ? null
          : _nicController.text.trim(),
      bday: _bdayController.text.trim(),
      gender: _selectedGender,
      address1: _address1Controller.text.trim(),
      address2: _address2Controller.text.trim().isEmpty
          ? null
          : _address2Controller.text.trim(),
      address3: _address3Controller.text.trim().isEmpty
          ? null
          : _address3Controller.text.trim(),
      guardianFname: _guardianFnameController.text.trim(),
      guardianLname: _guardianLnameController.text.trim(),
      guardianMobile: _guardianMobileController.text.trim(),
      guardianNic: _guardianNicController.text.trim().isEmpty
          ? null
          : _guardianNicController.text.trim(),
      isActive: true,
      imageUrl: widget.imageUrl,
      gradeId: _selectedGradeId!,
      classType: _selectClassType,
      admission: false,
      studentSchool: _studentSchool.text.trim().isEmpty
          ? null
          : _studentSchool.text.trim(),
    );

    context.read<StudentsBloc>().add(
      CreateStudentEvent(student: student, token: widget.token),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: (v) =>
          requiredField && (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is StudentsLoading) {
          setState(() => _isLoading = true);
        } else if (state is StudentsCreated) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Student created successfully (ID: ${state.student.customId})',
              ),
            ),
          );

          Navigator.pop(context);
        } else if (state is StudentsError) {
          setState(() => _isLoading = false);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Create Student")),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: widget.imageUrl.isNotEmpty
                            ? NetworkImage(widget.imageUrl)
                            : null,
                        child: widget.imageUrl.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionHeader("Enter"),
                              _buildTextField(
                                controller: _temporaryQrCodeController,
                                label: 'Temporary Qr Code',
                              ),

                              _sectionHeader("Personal Info"),
                              _buildTextField(
                                controller: _fnameController,
                                label: 'Full Name',
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _lnameController,
                                label: 'Initial Name',
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _mobileController,
                                label: 'Mobile',
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _whatsappController,
                                label: 'WhatsApp Mobile',
                                keyboardType: TextInputType.phone,
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _emailController,
                                label: 'Email',
                                requiredField: false,
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _nicController,
                                label: 'NIC',
                                requiredField: false,
                              ),

                              const SizedBox(height: 10),

                              TextFormField(
                                controller: _bdayController,
                                readOnly: true,
                                onTap: _pickBirthday,
                                decoration: InputDecoration(
                                  labelText: 'Birthday',
                                  suffixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),

                              const SizedBox(height: 10),

                              DropdownButtonFormField<String>(
                                value: _selectedGender,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'male',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'female',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'other',
                                    child: Text('Other'),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _selectedGender = v!),
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              _sectionHeader("Address Info"),

                              _buildTextField(
                                controller: _address1Controller,
                                label: 'Address 1',
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _address2Controller,
                                label: 'Address 2',
                                requiredField: false,
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _address3Controller,
                                label: 'Address 3',
                                requiredField: false,
                              ),

                              const SizedBox(height: 20),

                              _sectionHeader("Guardian Info"),

                              _buildTextField(
                                controller: _guardianFnameController,
                                label: 'Guardian First Name',
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _guardianLnameController,
                                label: 'Guardian Last Name',
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _guardianMobileController,
                                label: 'Guardian Mobile',
                              ),

                              const SizedBox(height: 20),

                              _sectionHeader("Academic Info"),

                              BlocBuilder<StudentGradeBloc, StudentGradeState>(
                                builder: (context, state) {
                                  if (state is StudentGradeLoading) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (state is StudentGradeLoaded) {
                                    return DropdownButtonFormField<int>(
                                      value: _selectedGradeId,
                                      items: state.grades
                                          .map(
                                            (g) => DropdownMenuItem(
                                              value: g.gradeId,
                                              child: Text(
                                                "Grade ${g.gradeName}",
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => _selectedGradeId = v),
                                      decoration: InputDecoration(
                                        labelText: "Select Grade",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      validator: (v) =>
                                          v == null ? "Select Grade" : null,
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

                              const SizedBox(height: 10),

                              DropdownButtonFormField<String>(
                                value: _selectClassType,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'online',
                                    child: Text("Online"),
                                  ),
                                  DropdownMenuItem(
                                    value: 'offline',
                                    child: Text("Offline"),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _selectClassType = v!),
                                decoration: InputDecoration(
                                  labelText: "Class Type",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              _buildTextField(
                                controller: _studentSchool,
                                label: "Student School",
                                requiredField: false,
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitStudent,
                    child: const Text("Create Student"),
                  ),
                ),
              ),

              if (_isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
