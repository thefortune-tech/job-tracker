import 'dart:convert';
import '../../domain/entities/job_application.dart';

class JobApplicationModel extends JobApplication {
  const JobApplicationModel({
    required super.id,
    required super.companyName,
    required super.role,
    required super.status,
    required super.appliedDate,
    super.notes,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['id'],
      companyName: json['companyName'],
      role: json['role'],
      status: json['status'],
      appliedDate: json['appliedDate'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'role': role,
      'status': status,
      'appliedDate': appliedDate,
      'notes': notes,
    };
  }

  factory JobApplicationModel.fromEntity(JobApplication job) {
    return JobApplicationModel(
      id: job.id,
      companyName: job.companyName,
      role: job.role,
      status: job.status,
      appliedDate: job.appliedDate,
      notes: job.notes,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory JobApplicationModel.fromJsonString(String jsonString) {
    return JobApplicationModel.fromJson(jsonDecode(jsonString));
  }
}