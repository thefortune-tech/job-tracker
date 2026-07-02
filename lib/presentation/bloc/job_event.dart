import '../../domain/entities/job_application.dart';

abstract class JobEvent {}

class LoadJobs extends JobEvent {}

class AddJob extends JobEvent {
  final JobApplication job;
  AddJob(this.job);
}

class UpdateJob extends JobEvent {
  final JobApplication job;
  UpdateJob(this.job);
}

class DeleteJob extends JobEvent {
  final String id;
  DeleteJob(this.id);
}