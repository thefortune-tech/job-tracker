import 'package:hive_flutter/hive_flutter.dart';
import '../models/job_application_model.dart';

abstract class JobLocalDataSource {
  Future<List<JobApplicationModel>> getJobs();
  Future<void> addJob(JobApplicationModel job);
  Future<void> updateJob(JobApplicationModel job);
  Future<void> deleteJob(String id);
}

class JobLocalDataSourceImpl implements JobLocalDataSource {
  static const String _boxName = 'jobsBox';

  @override
  Future<List<JobApplicationModel>> getJobs() async {
    final box = await Hive.openBox(_boxName);
    return box.values
        .map((e) => JobApplicationModel.fromJsonString(e))
        .toList();
  }

  @override
  Future<void> addJob(JobApplicationModel job) async {
    final box = await Hive.openBox(_boxName);
    await box.put(job.id, job.toJsonString());
  }

  @override
  Future<void> updateJob(JobApplicationModel job) async {
    final box = await Hive.openBox(_boxName);
    await box.put(job.id, job.toJsonString());
  }

  @override
  Future<void> deleteJob(String id) async {
    final box = await Hive.openBox(_boxName);
    await box.delete(id);
  }
}