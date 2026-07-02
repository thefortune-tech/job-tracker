import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/add_job_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Center(
        child: Text(
          'Page not found',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddJobPage(),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddJobPage(jobId: id);
        },
      ),
    ],
  );
}