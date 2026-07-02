import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_tracker/domain/entities/job_application.dart';
import 'package:job_tracker/domain/usecases/get_jobs_usecase.dart';
import 'package:job_tracker/domain/usecases/add_job_usecase.dart';
import 'package:job_tracker/domain/usecases/update_job_usecase.dart';
import 'package:job_tracker/domain/usecases/delete_job_usecase.dart';
import 'package:job_tracker/presentation/bloc/job_bloc.dart';
import 'package:job_tracker/presentation/bloc/job_event.dart';
import 'package:job_tracker/presentation/bloc/job_state.dart';

class MockGetJobsUseCase extends Mock implements GetJobsUseCase {}
class MockAddJobUseCase extends Mock implements AddJobUseCase {}
class MockUpdateJobUseCase extends Mock implements UpdateJobUseCase {}
class MockDeleteJobUseCase extends Mock implements DeleteJobUseCase {}
class FakeJobApplication extends Fake implements JobApplication {}

void main() {
  late JobBloc bloc;
  late MockGetJobsUseCase mockGetJobs;
  late MockAddJobUseCase mockAddJob;
  late MockUpdateJobUseCase mockUpdateJob;
  late MockDeleteJobUseCase mockDeleteJob;

  final tJob = const JobApplication(
    id: '1',
    companyName: 'Google',
    role: 'Flutter Developer',
    status: 'Applied',
    appliedDate: '2026-06-24',
  );

  final tJobs = [tJob];

  setUpAll(() {
    registerFallbackValue(FakeJobApplication());
  });

  setUp(() {
    mockGetJobs = MockGetJobsUseCase();
    mockAddJob = MockAddJobUseCase();
    mockUpdateJob = MockUpdateJobUseCase();
    mockDeleteJob = MockDeleteJobUseCase();

    bloc = JobBloc(
      getJobsUseCase: mockGetJobs,
      addJobUseCase: mockAddJob,
      updateJobUseCase: mockUpdateJob,
      deleteJobUseCase: mockDeleteJob,
    );
  });

  tearDown(() => bloc.close());

  group('JobBloc', () {
    group('LoadJobs', () {
      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobLoaded] when LoadJobs succeeds',
        build: () {
          when(() => mockGetJobs()).thenAnswer((_) async => tJobs);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadJobs()),
        expect: () => [
           JobLoading(),
          JobLoaded(tJobs),
        ],
      );

      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobError] when LoadJobs fails',
        build: () {
          when(() => mockGetJobs())
              .thenThrow(Exception('Load error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadJobs()),
        expect: () => [
           JobLoading(),
          isA<JobError>(),
        ],
      );
    });

    group('AddJob', () {
      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobLoaded] when AddJob succeeds',
        build: () {
          when(() => mockAddJob(any())).thenAnswer((_) async {});
          when(() => mockGetJobs()).thenAnswer((_) async => tJobs);
          return bloc;
        },
        act: (bloc) => bloc.add(AddJob(tJob)),
        expect: () => [
           JobLoading(),
          JobLoaded(tJobs),
        ],
      );

      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobError] when AddJob fails',
        build: () {
          when(() => mockAddJob(any()))
              .thenThrow(Exception('Add error'));
          return bloc;
        },
        act: (bloc) => bloc.add(AddJob(tJob)),
        expect: () => [
           JobLoading(),
          isA<JobError>(),
        ],
      );
    });

    group('DeleteJob', () {
      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobLoaded] when DeleteJob succeeds',
        build: () {
          when(() => mockDeleteJob(any())).thenAnswer((_) async {});
          when(() => mockGetJobs()).thenAnswer((_) async => []);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteJob('1')),
        expect: () => [
           JobLoading(),
           JobLoaded([]),
        ],
      );

      blocTest<JobBloc, JobState>(
        'emits [JobLoading, JobError] when DeleteJob fails',
        build: () {
          when(() => mockDeleteJob(any()))
              .thenThrow(Exception('Delete error'));
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteJob('1')),
        expect: () => [
           JobLoading(),
          isA<JobError>(),
        ],
      );
    });
  });
}