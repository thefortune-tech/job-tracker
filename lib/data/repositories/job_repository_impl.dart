import '../../domain/entities/job_application.dart';
import '../../domain/repositories/job_repository.dart';
import '../datasources/job_local_datasource.dart';
import '../models/job_application_model.dart';

class JobRepositoryImpl implements JobRepository {
  final JobLocalDataSource dataSource;

  JobRepositoryImpl(this.dataSource);

  @override
  Future<List<JobApplication>> getJobs() async {
    return await dataSource.getJobs();
  }

  @override
  Future<void> addJob(JobApplication job) async {
    final model = JobApplicationModel.fromEntity(job);
    await dataSource.addJob(model);
  }

  @override
  Future<void> updateJob(JobApplication job) async {
    final model = JobApplicationModel.fromEntity(job);
    await dataSource.updateJob(model);
  }

  @override
  Future<void> deleteJob(String id) async {
    await dataSource.deleteJob(id);
  }
}