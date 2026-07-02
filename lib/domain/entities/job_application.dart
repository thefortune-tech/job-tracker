import 'package:equatable/equatable.dart';

class JobApplication extends Equatable {
  final String id;
  final String companyName;
  final String role;
  final String status;
  final String appliedDate;
  final String? notes;

  const JobApplication({
    required this.id,
    required this.companyName,
    required this.role,
    required this.status,
    required this.appliedDate,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    companyName,
    role,
    status,
    appliedDate,
    notes,
  ];
}