import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/image_picker_service.dart';
import '../../../image_upload/data/models/fetch_quick_photo/fetch_quick_photo_request_model.dart';
import '../../../image_upload/data/models/image_upload/image_upload_request_model.dart';
import '../../../image_upload/presentation/bloc/image_upload/image_upload_bloc.dart';

class StudentUploadImagePage extends StatefulWidget {
  final String token;

  const StudentUploadImagePage({super.key, required this.token});

  @override
  State<StudentUploadImagePage> createState() => _StudentUploadImagePageState();
}

class _StudentUploadImagePageState extends State<StudentUploadImagePage> {
  final ImagePickerService _imagePickerService = ImagePickerService();

  final TextEditingController _quickIdController = TextEditingController();

  File? _selectedImage;
  String? _createdImageUrl;
  int? _quickImageId;

  bool _isLoading = false;

  /// Pick Image
  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePickerService.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = image;
        _createdImageUrl = null;
        _quickImageId = null;
      });
    }
  }

  /// Upload Image (Upload → Create Quick Image)
  void _uploadImage() {
    if (_selectedImage == null) return;

    context.read<ImageUploadBloc>().add(
      UploadImageEvent(
        ImageUploadRequestModel(image: _selectedImage!, token: widget.token),
      ),
    );
  }

  /// Fetch Quick Image by ID
  void _fetchQuickImage() {
    if (_quickIdController.text.trim().isEmpty) return;

    context.read<ImageUploadBloc>().add(
      FetchQuickPhotoEvent(
        FetchQuickPhotoRequestModel(
          token: widget.token,
          quickImageId: _quickIdController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageUploadBloc, ImageUploadState>(
      listener: (context, state) {
        if (state is ImageUploadLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is ImageUploadSuccess) {
          setState(() {
            _createdImageUrl = state.response.imageUrl;
            _quickImageId = null;
            _selectedImage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image uploaded successfully!")),
          );
        }

        if (state is FetchQuickPhotoLoaded) {
          setState(() {
            _createdImageUrl = state.result.imageUrl;
            _quickImageId = state.result.id;
            _selectedImage = null;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Quick image loaded!")));
        }

        if (state is ImageUploadError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Student Image Upload"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      /// IMAGE PREVIEW
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : _createdImageUrl != null
                            ? NetworkImage(_createdImageUrl!) as ImageProvider
                            : null,
                        child:
                            _selectedImage == null && _createdImageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(height: 25),

                      /// CAMERA
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Take Photo"),
                          onPressed: _isLoading
                              ? null
                              : () => _pickImage(ImageSource.camera),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// GALLERY
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.photo),
                          label: const Text("Select from Gallery"),
                          onPressed: _isLoading
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                        ),
                      ),

                      /// UPLOAD BUTTON
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: _isLoading ? null : _uploadImage,
                            child: const Text("Upload Image"),
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),
                      const Divider(),
                      const SizedBox(height: 15),

                      /// QUICK ID SECTION
                      const Text(
                        "Use Quick Image ID",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: _quickIdController,
                        decoration: const InputDecoration(
                          hintText: "Enter Quick ID",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _fetchQuickImage,
                          child: const Text("Get Quick Image"),
                        ),
                      ),

                      /// NEXT BUTTON (Shown only after success)
                      if (_createdImageUrl != null) ...[
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                '/create_student',
                                arguments: {
                                  'token': widget.token,
                                  'quick_image_id': _quickImageId,
                                  'image_url': _createdImageUrl,
                                },
                              );
                            },
                            child: const Text("Next"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            /// LOADING OVERLAY
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
