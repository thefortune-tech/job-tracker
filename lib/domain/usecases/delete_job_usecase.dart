import '../repositories/job_repository.dart';

class DeleteJobUseCase {
  final JobRepository repository;

  DeleteJobUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteJob(id);
  }
}