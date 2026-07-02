import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/job_application.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';

class AddJobPage extends StatefulWidget {
  final String? jobId;
  const AddJobPage({super.key, this.jobId});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedStatus = 'Applied';
  JobApplication? _existingJob;

  final List<String> _statusOptions = [
    'Applied',
    'Interview',
    'Offer',
    'Rejected',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) {
      final state = context.read<JobBloc>().state;
      if (state is JobLoaded) {
        _existingJob = state.jobs.firstWhere(
          (j) => j.id == widget.jobId,
        );
        _companyController.text = _existingJob!.companyName;
        _roleController.text = _existingJob!.role;
        _notesController.text = _existingJob!.notes ?? '';
        _selectedStatus = _existingJob!.status;
      }
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_companyController.text.isEmpty || _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Company name and role are required'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (widget.jobId != null && _existingJob != null) {
      context.read<JobBloc>().add(
            UpdateJob(
              JobApplication(
                id: _existingJob!.id,
                companyName: _companyController.text.trim(),
                role: _roleController.text.trim(),
                status: _selectedStatus,
                appliedDate: _existingJob!.appliedDate,
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
              ),
            ),
          );
    } else {
      context.read<JobBloc>().add(
            AddJob(
              JobApplication(
                id: const Uuid().v4(),
                companyName: _companyController.text.trim(),
                role: _roleController.text.trim(),
                status: _selectedStatus,
                appliedDate: DateTime.now()
                    .toIso8601String()
                    .substring(0, 10),
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
              ),
            ),
          );
    }
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.jobId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          isEditing ? 'Edit Application' : 'Add Application',
          style: const TextStyle(color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _companyController,
              hint: 'Company Name',
              icon: Icons.business,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _roleController,
              hint: 'Role / Position',
              icon: Icons.work,
            ),
            const SizedBox(height: 16),
            _buildStatusDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              hint: 'Notes (optional)',
              icon: Icons.note,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  isEditing ? 'Update Application' : 'Add Application',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.whiteFaint),
        prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          dropdownColor: const Color(0xFF1A2A48),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.accent),
          isExpanded: true,
          style: const TextStyle(color: AppColors.white),
          items: _statusOptions.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  const Icon(Icons.flag, color: AppColors.accent, size: 18),
                  const SizedBox(width: 8),
                  Text(status),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedStatus = value);
            }
          },
        ),
      ),
    );
  }
}