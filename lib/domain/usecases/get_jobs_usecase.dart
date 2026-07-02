import '../entities/job_application.dart';
import '../repositories/job_repository.dart';

class GetJobsUseCase {
  final JobRepository repository;

  GetJobsUseCase(this.repository);

  Future<List<JobApplication>> call() async {
    return await repository.getJobs();
  }
}