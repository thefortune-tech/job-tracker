import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';
import '../widgets/job_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Job Tracker',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: BlocBuilder<JobBloc, JobState>(
              builder: (context, state) {
                if (state is JobLoaded) {
                  return Center(
                    child: Text(
                      '${state.jobs.length} Applications',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is JobError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⛔', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    onPressed: () =>
                        context.read<JobBloc>().add(LoadJobs()),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is JobLoaded && state.jobs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('💼', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text(
                    'No applications yet\nTap + to add one',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.whiteMuted,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is JobLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                return JobCard(job: state.jobs[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}