import 'dart:io';

class MathProblem {
  final String id;
  final String title;
  final File? imageFile;
  final String? pdfPath;
  final int? pageNumber;
  final DateTime createdAt;
  final String? description;
  final String? extractedText;
  final List<String>? mathExpressions;
  final ProblemStatus status;
  final String? errorMessage;

  MathProblem({
    required this.id,
    required this.title,
    this.imageFile,
    this.pdfPath,
    this.pageNumber,
    required this.createdAt,
    this.description,
    this.extractedText,
    this.mathExpressions,
    this.status = ProblemStatus.pending,
    this.errorMessage,
  });

  MathProblem copyWith({
    String? id,
    String? title,
    File? imageFile,
    String? pdfPath,
    int? pageNumber,
    DateTime? createdAt,
    String? description,
    String? extractedText,
    List<String>? mathExpressions,
    ProblemStatus? status,
    String? errorMessage,
  }) {
    return MathProblem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageFile: imageFile ?? this.imageFile,
      pdfPath: pdfPath ?? this.pdfPath,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      extractedText: extractedText ?? this.extractedText,
      mathExpressions: mathExpressions ?? this.mathExpressions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pdfPath': pdfPath,
      'pageNumber': pageNumber,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'extractedText': extractedText,
      'mathExpressions': mathExpressions,
      'status': status.toString(),
      'errorMessage': errorMessage,
    };
  }
}

class Solution {
  final String id;
  final String problemId;
  final String expression;
  final String? steps;
  final String? result;
  final SolutionStatus status;
  final DateTime createdAt;
  final String? errorMessage;

  Solution({
    required this.id,
    required this.problemId,
    required this.expression,
    this.steps,
    this.result,
    required this.status,
    required this.createdAt,
    this.errorMessage,
  });

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      id: json['solution_id'] ?? json['id'] ?? '',
      problemId: json['problem_id'] ?? '',
      expression: json['expression'] ?? '',
      steps: json['steps']?.toString(),
      result: json['result']?.toString(),
      status: _statusFromString(json['status']?.toString() ?? 'pending'),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      errorMessage: json['error'],
    );
  }

  static SolutionStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return SolutionStatus.completed;
      case 'processing':
        return SolutionStatus.processing;
      case 'failed':
        return SolutionStatus.failed;
      default:
        return SolutionStatus.pending;
    }
  }
}

enum ProblemStatus {
  pending,
  processing,
  analyzing,
  solved,
  completed,
  failed,
  error,
}

enum SolutionStatus {
  pending,
  processing,
  completed,
  failed,
}