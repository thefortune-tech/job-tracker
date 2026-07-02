import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/usecases/add_job_usecase.dart';
import '../../domain/usecases/update_job_usecase.dart';
import '../../domain/usecases/delete_job_usecase.dart';
import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final GetJobsUseCase getJobsUseCase;
  final AddJobUseCase addJobUseCase;
  final UpdateJobUseCase updateJobUseCase;
  final DeleteJobUseCase deleteJobUseCase;

  JobBloc({
    required this.getJobsUseCase,
    required this.addJobUseCase,
    required this.updateJobUseCase,
    required this.deleteJobUseCase,
  }) : super(JobInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<AddJob>(_onAddJob);
    on<UpdateJob>(_onUpdateJob);
    on<DeleteJob>(_onDeleteJob);
  }

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final jobs = await getJobsUseCase();
      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onAddJob(AddJob event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      await addJobUseCase(event.job);
      final jobs = await getJobsUseCase();
      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onUpdateJob(UpdateJob event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      await updateJobUseCase(event.job);
      final jobs = await getJobsUseCase();
      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> _onDeleteJob(DeleteJob event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      await deleteJobUseCase(event.id);
      final jobs = await getJobsUseCase();
      emit(JobLoaded(jobs));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }
}