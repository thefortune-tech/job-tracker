import 'package:equatable/equatable.dart';
import '../../domain/entities/job_application.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {
  const JobInitial();
}

class JobLoading extends JobState {
  const JobLoading();
}

class JobLoaded extends JobState {
  final List<JobApplication> jobs;
  const JobLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class JobError extends JobState {
  final String message;
  const JobError(this.message);

  @override
  List<Object?> get props => [message];
}