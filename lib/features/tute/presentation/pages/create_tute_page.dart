import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../qr/data/model/read_tute/read_tute_response_model.dart';
import '../bloc/tute/tute_bloc.dart';

class CreateTutePage extends StatefulWidget {
  final String token;
  final ReadTuteResponseModel readTuteResponse;

  const CreateTutePage({
    super.key,
    required this.token,
    required this.readTuteResponse,
  });

  @override
  State<CreateTutePage> createState() => _CreateTutePageState();
}

class _CreateTutePageState extends State<CreateTutePage> {
  final Map<int, DateTime> selectedMonths = {};

  @override
  Widget build(BuildContext context) {
    final dataList = widget.readTuteResponse.data;
    final student = dataList.first.student;

    return BlocListener<TuteBloc, TuteState>(
      listener: (context, state) {
        if (state is TuteCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(state.message),
            ),
          );
        } else if (state is TuteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(title: const Text("Create Tute"), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStudentCard(student),
              const SizedBox(height: 20),

              /// CLASS LIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
                  return _buildClassCard(item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(dynamic student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(student.imageUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${student.initialName}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Student ID: ${student.customId}"),
                Text("Guardian: ${student.guardianMobile}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(dynamic data) {
    final classId = data.classCategoryHasStudentClassId;
    selectedMonths.putIfAbsent(classId, () => DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.className,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text("Category: ${data.categoryName}"),
          Text("Grade: ${data.gradeName}"),
          const SizedBox(height: 12),

          /// MONTH PICKER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Month"),
              TextButton(
                onPressed: () => _pickMonth(classId),
                child: Text(
                  DateFormat("MMM yyyy").format(selectedMonths[classId]!),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// CREATE BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<TuteBloc>().add(
                  CreateTuteEvent(
                    token: widget.token,
                    studentId: data.student.id,
                    classCategoryHasStudentClassId: classId,
                    year: selectedMonths[classId]!.year,
                    month: selectedMonths[classId]!.month,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Create Tute", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Future<void> _pickMonth(int classId) async {
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonths[classId]!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('en'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedMonths[classId] = picked;
      });
    }
  }
}
