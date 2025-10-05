import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/math_problem.dart';
import 'api_service.dart';

class ProblemService extends ChangeNotifier {
  final ApiService _apiService;
  final List<MathProblem> _problems = [];
  final Map<String, List<Solution>> _solutions = {};
  bool _isLoading = false;
  String? _error;
  
  ProblemService(this._apiService);
  
  List<MathProblem> get problems => List.unmodifiable(_problems);
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Solution> getSolutionsForProblem(String problemId) {
    return _solutions[problemId] ?? [];
  }
  
  MathProblem? getProblemById(String? id) {
    if (id == null) return null;
    try {
      return _problems.firstWhere((problem) => problem.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add problem from image (existing functionality)
  Future<MathProblem> addProblem(File imageFile, {String? title}) async {
    final String problemId = DateTime.now().millisecondsSinceEpoch.toString();
    final String problemTitle = title ?? 'Math Problem ${_problems.length + 1}';
    
    // Save image to app directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = 'problem_$problemId.jpg';
    final String filePath = path.join(appDir.path, fileName);
    final File savedFile = await imageFile.copy(filePath);
    
    final problem = MathProblem(
      id: problemId,
      title: problemTitle,
      imageFile: savedFile,
      createdAt: DateTime.now(),
    );
    
    _problems.insert(0, problem);
    notifyListeners();
    
    return problem;
  }

  // Upload PDF and get problems
  Future<List<MathProblem>> uploadPDF(File pdfFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('📤 Uploading PDF: ${pdfFile.path}');
      final response = await _apiService.uploadPDF(pdfFile);
      
      final List<MathProblem> newProblems = [];
      final List<dynamic> problemsData = response['problems'] ?? [];
      
      for (var problemData in problemsData) {
        final problem = MathProblem(
          id: problemData['problem_id'],
          title: 'Page ${problemData['page_number']}',
          pdfPath: pdfFile.path,
          pageNumber: problemData['page_number'],
          createdAt: DateTime.now(),
          status: _parseStatus(problemData['status']),
        );
        
        newProblems.add(problem);
        _problems.insert(0, problem);
      }
      
      _isLoading = false;
      notifyListeners();
      
      // Start polling for status updates
      for (var problem in newProblems) {
        _pollProblemStatus(problem.id);
      }
      
      return newProblems;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error uploading PDF: $e');
      rethrow;
    }
  }

  // Poll problem status
  Future<void> _pollProblemStatus(String problemId) async {
    int attempts = 0;
    const maxAttempts = 20;
    const pollInterval = Duration(seconds: 3);

    while (attempts < maxAttempts) {
      try {
        await Future.delayed(pollInterval);
        final statusData = await _apiService.checkUploadStatus(problemId);
        
        final problemIndex = _problems.indexWhere((p) => p.id == problemId);
        if (problemIndex == -1) return;

        final updatedProblem = _problems[problemIndex].copyWith(
          status: _parseStatus(statusData['status']),
          extractedText: statusData['extracted_text'],
          mathExpressions: (statusData['math_expressions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
          errorMessage: statusData['error'],
        );

        _problems[problemIndex] = updatedProblem;
        notifyListeners();

        if (statusData['status'] == 'completed' || statusData['status'] == 'failed') {
          debugPrint('✅ Problem ${problemId} status: ${statusData['status']}');
          break;
        }
      } catch (e) {
        debugPrint('⚠️ Error polling status for $problemId: $e');
        attempts++;
      }
    }
  }

  // Solve problem
  Future<void> solveProblem(String problemId) async {
    try {
      final problemIndex = _problems.indexWhere((p) => p.id == problemId);
      if (problemIndex == -1) return;

      _problems[problemIndex] = _problems[problemIndex].copyWith(
        status: ProblemStatus.processing,
      );
      notifyListeners();

      final response = await _apiService.solveProblem(problemId);
      final List<dynamic> solutionsData = response['solutions'] ?? [];
      
      final solutions = solutionsData
          .map((data) => Solution.fromJson(data))
          .toList();
      
      _solutions[problemId] = solutions;
      
      // Poll for solution status
      for (var solution in solutions) {
        _pollSolutionStatus(solution.id, problemId);
      }
      
      notifyListeners();
    } catch (e) {
      final problemIndex = _problems.indexWhere((p) => p.id == problemId);
      if (problemIndex != -1) {
        _problems[problemIndex] = _problems[problemIndex].copyWith(
          status: ProblemStatus.failed,
          errorMessage: e.toString(),
        );
        notifyListeners();
      }
      debugPrint('❌ Error solving problem: $e');
      rethrow;
    }
  }

  // Poll solution status
  Future<void> _pollSolutionStatus(String solutionId, String problemId) async {
    int attempts = 0;
    const maxAttempts = 20;
    const pollInterval = Duration(seconds: 2);

    while (attempts < maxAttempts) {
      try {
        await Future.delayed(pollInterval);
        final solution = await _apiService.getSolution(solutionId);
        
        final solutions = _solutions[problemId] ?? [];
        final solutionIndex = solutions.indexWhere((s) => s.id == solutionId);
        
        if (solutionIndex != -1) {
          solutions[solutionIndex] = solution;
          _solutions[problemId] = solutions;
          notifyListeners();
        }

        if (solution.status == SolutionStatus.completed || 
            solution.status == SolutionStatus.failed) {
          debugPrint('✅ Solution ${solutionId} status: ${solution.status}');
          
          // Update problem status
          final problemIndex = _problems.indexWhere((p) => p.id == problemId);
          if (problemIndex != -1) {
            _problems[problemIndex] = _problems[problemIndex].copyWith(
              status: ProblemStatus.completed,
            );
            notifyListeners();
          }
          break;
        }
      } catch (e) {
        debugPrint('⚠️ Error polling solution status: $e');
        attempts++;
      }
    }
  }

  // Solve expression directly
  Future<Solution> solveExpression(String expression) async {
    try {
      final response = await _apiService.solveExpression(expression);
      return Solution.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error solving expression: $e');
      rethrow;
    }
  }

  // Load problems from server
  Future<void> loadProblems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final problemsData = await _apiService.getUserProblems();
      _problems.clear();
      
      for (var data in problemsData) {
        final problem = MathProblem(
          id: data['problem_id'],
          title: data['title'] ?? 'Problem',
          pageNumber: data['page_number'],
          createdAt: DateTime.parse(data['created_at']),
          status: _parseStatus(data['status']),
          extractedText: data['extracted_text'],
          mathExpressions: (data['math_expressions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
        );
        _problems.add(problem);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error loading problems: $e');
    }
  }

  void deleteProblem(String problemId) {
    final problemIndex = _problems.indexWhere((p) => p.id == problemId);
    if (problemIndex != -1) {
      final problem = _problems[problemIndex];
      
      // Delete the image file if exists
      if (problem.imageFile?.existsSync() ?? false) {
        problem.imageFile!.deleteSync();
      }
      
      _problems.removeAt(problemIndex);
      _solutions.remove(problemId);
      notifyListeners();
      
      // Delete from server
      _apiService.deleteProblem(problemId).catchError((e) {
        debugPrint('⚠️ Error deleting problem from server: $e');
      });
    }
  }

  ProblemStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'processing':
        return ProblemStatus.processing;
      case 'completed':
        return ProblemStatus.completed;
      case 'failed':
        return ProblemStatus.failed;
      default:
        return ProblemStatus.pending;
    }
  }
  
  void updateProblemStatus(String problemId, ProblemStatus status) {
    final problemIndex = _problems.indexWhere((p) => p.id == problemId);
    if (problemIndex != -1) {
      _problems[problemIndex] = _problems[problemIndex].copyWith(status: status);
      notifyListeners();
    }
  }
}