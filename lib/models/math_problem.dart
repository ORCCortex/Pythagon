import 'dart:io';

class MathProblem {
  final String id;
  final String title;
  final File imageFile;
  final DateTime createdAt;
  final String? description;
  final ProblemStatus status;

  MathProblem({
    required this.id,
    required this.title,
    required this.imageFile,
    required this.createdAt,
    this.description,
    this.status = ProblemStatus.pending,
  });

  MathProblem copyWith({
    String? id,
    String? title,
    File? imageFile,
    DateTime? createdAt,
    String? description,
    ProblemStatus? status,
  }) {
    return MathProblem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageFile: imageFile ?? this.imageFile,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}

enum ProblemStatus {
  pending,
  analyzing,
  solved,
  error,
}