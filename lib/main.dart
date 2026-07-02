import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_colors.dart';
import 'data/datasources/job_local_datasource.dart';
import 'data/repositories/job_repository_impl.dart';
import 'domain/usecases/get_jobs_usecase.dart';
import 'domain/usecases/add_job_usecase.dart';
import 'domain/usecases/update_job_usecase.dart';
import 'domain/usecases/delete_job_usecase.dart';
import 'presentation/bloc/job_bloc.dart';
import 'presentation/bloc/job_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  await Hive.initFlutter();

  // Dependency Injection
  final dataSource = JobLocalDataSourceImpl();
  final repository = JobRepositoryImpl(dataSource);
  final getJobsUseCase = GetJobsUseCase(repository);
  final addJobUseCase = AddJobUseCase(repository);
  final updateJobUseCase = UpdateJobUseCase(repository);
  final deleteJobUseCase = DeleteJobUseCase(repository);

  runApp(
    BlocProvider(
      create: (_) => JobBloc(
        getJobsUseCase: getJobsUseCase,
        addJobUseCase: addJobUseCase,
        updateJobUseCase: updateJobUseCase,
        deleteJobUseCase: deleteJobUseCase,
      )..add(LoadJobs()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⛔', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details.exception.toString(),
                style: const TextStyle(
                  color: AppColors.whiteMuted,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    };

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.background,
        ),
      ),
    );
  }
}