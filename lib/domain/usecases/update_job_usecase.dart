import '../entities/job_application.dart';
import '../repositories/job_repository.dart';

class UpdateJobUseCase {
  final JobRepository repository;

  UpdateJobUseCase(this.repository);

  Future<void> call(JobApplication job) async {
    await repository.updateJob(job);
  }
}