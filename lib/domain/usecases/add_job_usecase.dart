import '../entities/job_application.dart';
import '../repositories/job_repository.dart';

class AddJobUseCase {
  final JobRepository repository;

  AddJobUseCase(this.repository);

  Future<void> call(JobApplication job) async {
    await repository.addJob(job);
  }
}