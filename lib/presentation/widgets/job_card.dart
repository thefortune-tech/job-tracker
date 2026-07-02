import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/job_application.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';

class JobCard extends StatelessWidget {
  final JobApplication job;
  const JobCard({super.key, required this.job});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return AppColors.accent;
      case 'interview':
        return AppColors.warning;
      case 'offer':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.whiteMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.companyName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(job.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  job.status,
                  style: TextStyle(
                    color: _getStatusColor(job.status),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            job.role,
            style: const TextStyle(
              color: AppColors.whiteMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.whiteFaint,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                job.appliedDate,
                style: const TextStyle(
                  color: AppColors.whiteFaint,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.accent,
                  size: 20,
                ),
                onPressed: () => context.go('/edit/${job.id}'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: () => context
                    .read<JobBloc>()
                    .add(DeleteJob(job.id)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (job.notes != null && job.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              job.notes!,
              style: const TextStyle(
                color: AppColors.whiteFaint,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}