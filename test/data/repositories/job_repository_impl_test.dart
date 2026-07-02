import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_tracker/domain/entities/job_application.dart';
import 'package:job_tracker/data/datasources/job_local_datasource.dart';
import 'package:job_tracker/data/models/job_application_model.dart';
import 'package:job_tracker/data/repositories/job_repository_impl.dart';

class MockJobLocalDataSource extends Mock implements JobLocalDataSource {}
class FakeJobApplicationModel extends Fake implements JobApplicationModel {}

void main() {
  late JobRepositoryImpl repository;
  late MockJobLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(FakeJobApplicationModel());
  });

  setUp(() {
    mockDataSource = MockJobLocalDataSource();
    repository = JobRepositoryImpl(mockDataSource);
  });

  final tModel = JobApplicationModel(
    id: '1',
    companyName: 'Google',
    role: 'Flutter Developer',
    status: 'Applied',
    appliedDate: '2026-06-24',
  );

  final tJob = const JobApplication(
    id: '1',
    companyName: 'Google',
    role: 'Flutter Developer',
    status: 'Applied',
    appliedDate: '2026-06-24',
  );

  group('JobRepositoryImpl', () {
    group('getJobs', () {
      test('should return list of jobs from datasource', () async {
        // Arrange
        when(() => mockDataSource.getJobs())
            .thenAnswer((_) async => [tModel]);

        // Act
        final result = await repository.getJobs();

        // Assert
        expect(result, [tModel]);
        verify(() => mockDataSource.getJobs()).called(1);
      });

      test('should throw exception when datasource fails', () async {
        // Arrange
        when(() => mockDataSource.getJobs())
            .thenThrow(Exception('Datasource error'));

        // Act & Assert
        expect(() => repository.getJobs(), throwsException);
      });
    });

    group('addJob', () {
      test('should call datasource addJob with correct model', () async {
        // Arrange
        when(() => mockDataSource.addJob(any()))
            .thenAnswer((_) async {});

        // Act
        await repository.addJob(tJob);

        // Assert
        verify(() => mockDataSource.addJob(any())).called(1);
      });

      test('should throw exception when datasource fails', () async {
        // Arrange
        when(() => mockDataSource.addJob(any()))
            .thenThrow(Exception('Datasource error'));

        // Act & Assert
        expect(() => repository.addJob(tJob), throwsException);
      });
    });

    group('deleteJob', () {
      test('should call datasource deleteJob with correct id', () async {
        // Arrange
        when(() => mockDataSource.deleteJob(any()))
            .thenAnswer((_) async {});

        // Act
        await repository.deleteJob('1');

        // Assert
        verify(() => mockDataSource.deleteJob('1')).called(1);
      });

      test('should throw exception when datasource fails', () async {
        // Arrange
        when(() => mockDataSource.deleteJob(any()))
            .thenThrow(Exception('Datasource error'));

        // Act & Assert
        expect(() => repository.deleteJob('1'), throwsException);
      });
    });
  });
}