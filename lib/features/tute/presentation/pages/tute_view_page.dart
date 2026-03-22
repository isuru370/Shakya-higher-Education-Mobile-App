import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tute/tute_bloc.dart';

class TuteViewPage extends StatefulWidget {
  final String token;
  final int studentId;
  final int classCategoryStudentClassId;

  const TuteViewPage({
    super.key,
    required this.token,
    required this.studentId,
    required this.classCategoryStudentClassId,
  });

  @override
  State<TuteViewPage> createState() => _TuteViewPageState();
}

class _TuteViewPageState extends State<TuteViewPage> {
  @override
  void initState() {
    super.initState();

    context.read<TuteBloc>().add(
      LoadAllTuteEvent(
        token: widget.token,
        studentId: widget.studentId,
        classCategoryStudentClassId: widget.classCategoryStudentClassId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TuteBloc, TuteState>(
      listener: (context, state) {
        if (state is TuteToggleStatusSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: state.message.contains("Titute activated")
                  ? Colors.green
                  : Colors.red,
              content: Text(state.message),
            ),
          );

          // Refresh the list after creation or status toggle
          context.read<TuteBloc>().add(
            LoadAllTuteEvent(
              token: widget.token,
              studentId: widget.studentId,
              classCategoryStudentClassId: widget.classCategoryStudentClassId,
            ),
          );
        }

        if (state is TuteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Tute History"),
          centerTitle: true,
        ),
        body: BlocBuilder<TuteBloc, TuteState>(
          builder: (context, state) {
            if (state is TuteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TuteError) {
              return _buildErrorState(state.message);
            }

            if (state is TuteLoaded) {
              if (state.tutes.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TuteBloc>().add(
                    LoadAllTuteEvent(
                      token: widget.token,
                      studentId: widget.studentId,
                      classCategoryStudentClassId:
                          widget.classCategoryStudentClassId,
                    ),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.tutes.length,
                  itemBuilder: (context, index) {
                    final tute = state.tutes[index];
                    return _buildTuteCard(tute);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTuteCard(dynamic tute) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tute.tuteFor,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "TUTE",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<TuteBloc>().add(
                        ToggleStatusTuteEvent(
                          token: widget.token,
                          tuteId: tute.id,
                        ),
                      );
                    },
                    icon: tute.activeStatus
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildInfoRow(Icons.class_, "Class", tute.className),
          _buildInfoRow(Icons.category, "Category", tute.categoryName),
          _buildInfoRow(Icons.school, "Grade", tute.gradeName),
          _buildInfoRow(Icons.calendar_today, "Created", tute.createdAt),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.menu_book, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No Tutes Found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
