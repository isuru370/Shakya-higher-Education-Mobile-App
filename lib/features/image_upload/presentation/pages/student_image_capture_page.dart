import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../image_upload/data/models/image_upload/image_upload_request_model.dart';
import '../../../image_upload/presentation/bloc/image_upload/image_upload_bloc.dart';
import '../../../student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';

class StudentImageCapturePage extends StatefulWidget {
  final String token;

  const StudentImageCapturePage({super.key, required this.token});

  @override
  State<StudentImageCapturePage> createState() =>
      _StudentImageCapturePageState();
}

class _StudentImageCapturePageState extends State<StudentImageCapturePage> {
  File? _imageFile;
  int? _selectedGradeId;
  final ImagePicker _picker = ImagePicker();

  late final StudentGradeBloc _studentGradeBloc;
  late final ImageUploadBloc _imageUploadBloc;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();

    _studentGradeBloc = GetIt.instance<StudentGradeBloc>();
    _imageUploadBloc = GetIt.instance<ImageUploadBloc>();

    _studentGradeBloc.add(GetStudentGradesEvent(token: widget.token));
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Image picking error: $e');
    }
  }

  void _upload() {
    if (_imageFile == null || _selectedGradeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select image and grade')),
      );
      return;
    }

    final request = ImageUploadRequestModel(
      image: _imageFile!,
      token: widget.token,
    );

    _imageUploadBloc.add(
      CreateQuickPhotoEvent(request: request, gradeId: _selectedGradeId!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _studentGradeBloc),
        BlocProvider.value(value: _imageUploadBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Image Upload"),
          centerTitle: true,
        ),
        body: BlocConsumer<ImageUploadBloc, ImageUploadState>(
          listener: (context, state) {
            if (state is ImageUploadLoading) {
              setState(() => _isUploading = true);
            } else {
              setState(() => _isUploading = false);
            }

            if (state is CreateQuickPhotoSuccess) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Upload Successful'),
                    content: Text(
                      'Quick Image ID: ${state.response.data.customId}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // close dialog

                          setState(() {
                            _isUploading = false;
                            _imageFile = null;
                            _selectedGradeId = null; // reset grade also
                          });
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            }

            if (state is ImageUploadError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, uploadState) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        /// Profile Image
                        _imageFile != null
                            ? CircleAvatar(
                                radius: 70,
                                backgroundImage: FileImage(_imageFile!),
                              )
                            : const CircleAvatar(
                                radius: 70,
                                child: Icon(Icons.person, size: 70),
                              ),

                        const SizedBox(height: 20),

                        /// Camera & Gallery
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _isUploading
                                  ? null
                                  : () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Camera"),
                            ),
                            const SizedBox(width: 15),
                            OutlinedButton.icon(
                              onPressed: _isUploading
                                  ? null
                                  : () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text("Gallery"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// Grade Dropdown
                        BlocBuilder<StudentGradeBloc, StudentGradeState>(
                          builder: (context, state) {
                            if (state is StudentGradeLoading) {
                              return const CircularProgressIndicator();
                            }

                            if (state is StudentGradeLoaded) {
                              return DropdownButtonFormField<int>(
                                initialValue: _selectedGradeId,
                                decoration: InputDecoration(
                                  labelText: "Select Grade",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: state.grades.map((grade) {
                                  return DropdownMenuItem<int>(
                                    value: grade.gradeId,
                                    child: Text("Grade ${grade.gradeName}"),
                                  );
                                }).toList(),
                                onChanged: _isUploading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedGradeId = value;
                                        });
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

                        const SizedBox(height: 30),

                        /// Upload Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isUploading ? null : _upload,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Upload",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Show Quick Image
                        if (uploadState is CreateQuickPhotoSuccess)
                          Column(
                            children: [
                              Image.network(
                                uploadState.response.data.quickImg,
                                height: 150,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Custom ID: ${uploadState.response.data.customId}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                /// Loading Overlay
                if (_isUploading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
