import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/math_problem.dart';
import '../services/problem_service.dart';

class ProblemDetailScreen extends StatefulWidget {
  final String problemId;

  const ProblemDetailScreen({super.key, required this.problemId});

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProblemService>(
      builder: (context, problemService, child) {
        final problem = problemService.getProblemById(widget.problemId);

        if (problem == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Problem Not Found')),
            body: const Center(
              child: Text('Problem not found'),
            ),
          );
        }

        final solutions = problemService.getSolutionsForProblem(widget.problemId);

        return Scaffold(
          appBar: AppBar(
            title: Text(problem.title),
            actions: [
              if (problem.status == ProblemStatus.completed)
                IconButton(
                  icon: const Icon(Icons.calculate),
                  tooltip: 'Solve Problem',
                  onPressed: () => _solveProblem(context, problemService),
                ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () => _deleteProblem(context, problemService),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              // Reload problem data
              setState(() {});
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(problem),
                  const SizedBox(height: 16),
                  if (problem.imageFile != null) _buildImageSection(problem),
                  if (problem.pdfPath != null) _buildPDFSection(problem),
                  const SizedBox(height: 16),
                  if (problem.extractedText != null && problem.extractedText!.isNotEmpty)
                    _buildExtractedTextSection(problem),
                  const SizedBox(height: 16),
                  if (problem.mathExpressions != null && problem.mathExpressions!.isNotEmpty)
                    _buildMathExpressionsSection(problem),
                  const SizedBox(height: 16),
                  if (solutions.isNotEmpty) _buildSolutionsSection(solutions),
                  if (problem.errorMessage != null)
                    _buildErrorSection(problem.errorMessage!),
                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ),
          floatingActionButton: problem.status == ProblemStatus.completed && solutions.isEmpty
              ? FloatingActionButton.extended(
                  onPressed: () => _solveProblem(context, problemService),
                  icon: const Icon(Icons.calculate),
                  label: const Text('Solve Problem'),
                  backgroundColor: Colors.green,
                )
              : null,
        );
      },
    );
  }

  Widget _buildStatusCard(MathProblem problem) {
    return Card(
      color: _getStatusColor(problem.status).withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(problem.status),
              color: _getStatusColor(problem.status),
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${_getStatusText(problem.status)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(problem.status),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created: ${_formatDateTime(problem.createdAt)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (problem.pageNumber != null)
                    Text(
                      'PDF Page: ${problem.pageNumber}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
            ),
            if (problem.status == ProblemStatus.processing)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(MathProblem problem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Captured Image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(problem.imageFile!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFSection(MathProblem problem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.picture_as_pdf, color: Colors.red[700]),
                const SizedBox(width: 8),
                const Text(
                  'PDF Document',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File: ${problem.pdfPath!.split('/').last}',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  if (problem.pageNumber != null)
                    Text(
                      'Page: ${problem.pageNumber}',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractedTextSection(MathProblem problem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Extracted Text',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: SelectableText(
                problem.extractedText!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMathExpressionsSection(MathProblem problem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.functions, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  'Math Expressions (${problem.mathExpressions!.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...problem.mathExpressions!.asMap().entries.map((entry) {
              final index = entry.key;
              final expression = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SelectableText(
                        expression,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionsSection(List<Solution> solutions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  'Solutions (${solutions.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...solutions.asMap().entries.map((entry) {
              final index = entry.key;
              final solution = entry.value;
              return _buildSolutionCard(index, solution);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard(int index, Solution solution) {
    final isCompleted = solution.status == SolutionStatus.completed;
    final isFailed = solution.status == SolutionStatus.failed;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [Colors.green[50]!, Colors.green[100]!]
              : isFailed
                  ? [Colors.red[50]!, Colors.red[100]!]
                  : [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withOpacity(0.5)
              : isFailed
                  ? Colors.red.withOpacity(0.5)
                  : Colors.blue.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green[700]
                        : isFailed
                            ? Colors.red[700]
                            : Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    solution.expression,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                if (solution.status == SolutionStatus.processing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            if (solution.steps != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Steps:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  solution.steps!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
            if (solution.result != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[600]!, Colors.green[700]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Answer: ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: SelectableText(
                        solution.result!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (solution.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        solution.errorMessage!,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(String errorMessage) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _solveProblem(BuildContext context, ProblemService problemService) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('🧮 Solving problem...'),
            ],
          ),
        ),
      );

      await problemService.solveProblem(widget.problemId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Solutions generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProblem(BuildContext context, ProblemService problemService) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Problem'),
        content: const Text('Are you sure you want to delete this problem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      problemService.deleteProblem(widget.problemId);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Problem deleted')),
      );
    }
  }

  Color _getStatusColor(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return Colors.orange;
      case ProblemStatus.processing:
        return Colors.blue;
      case ProblemStatus.completed:
        return Colors.green;
      case ProblemStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return Icons.schedule;
      case ProblemStatus.processing:
        return Icons.sync;
      case ProblemStatus.completed:
        return Icons.check_circle;
      case ProblemStatus.failed:
        return Icons.error;
    }
  }

  String _getStatusText(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return 'Pending';
      case ProblemStatus.processing:
        return 'Processing';
      case ProblemStatus.completed:
        return 'Completed';
      case ProblemStatus.failed:
        return 'Failed';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
