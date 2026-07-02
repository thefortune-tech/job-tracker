import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_tracker/domain/entities/job_application.dart';
import 'package:job_tracker/domain/repositories/job_repository.dart';
import 'package:job_tracker/domain/usecases/get_jobs_usecase.dart';

// Mock class
class MockJobRepository extends Mock implements JobRepository {}

void main() {
  late GetJobsUseCase useCase;
  late MockJobRepository mockRepository;

  setUp(() {
    mockRepository = MockJobRepository();
    useCase = GetJobsUseCase(mockRepository);
  });

  final tJobs = [
    const JobApplication(
      id: '1',
      companyName: 'Google',
      role: 'Flutter Developer',
      status: 'Applied',
      appliedDate: '2026-06-24',
    ),
    const JobApplication(
      id: '2',
      companyName: 'Meta',
      role: 'Mobile Engineer',
      status: 'Interview',
      appliedDate: '2026-06-20',
    ),
  ];

  group('GetJobsUseCase', () {
    test('should return list of jobs from repository', () async {
      // Arrange
      when(() => mockRepository.getJobs()).thenAnswer((_) async => tJobs);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tJobs);
      verify(() => mockRepository.getJobs()).called(1);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(() => mockRepository.getJobs())
          .thenThrow(Exception('Repository error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}