import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/math_problem.dart';

class ProblemService extends ChangeNotifier {
  final List<MathProblem> _problems = [];
  
  List<MathProblem> get problems => List.unmodifiable(_problems);
  
  MathProblem? getProblemById(String? id) {
    if (id == null) return null;
    try {
      return _problems.firstWhere((problem) => problem.id == id);
    } catch (e) {
      return null;
    }
  }

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
    
    _problems.insert(0, problem); // Add to beginning of list
    notifyListeners();
    
    return problem;
  }

  void deleteProblem(String problemId) {
    final problemIndex = _problems.indexWhere((p) => p.id == problemId);
    if (problemIndex != -1) {
      final problem = _problems[problemIndex];
      // Delete the image file
      if (problem.imageFile.existsSync()) {
        problem.imageFile.deleteSync();
      }
      _problems.removeAt(problemIndex);
      notifyListeners();
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