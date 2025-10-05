import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import '../services/problem_service.dart';
import '../models/math_problem.dart';

class ProblemViewerScreen extends StatelessWidget {
  final String? problemId;

  const ProblemViewerScreen({super.key, this.problemId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProblemService>(
      builder: (context, problemService, child) {
        final problem = problemService.getProblemById(problemId);
        
        if (problem == null) {
          return _buildNotFoundScreen(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(problem.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteProblem(context, problem.id),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildImageViewer(problem),
              ),
              Expanded(
                flex: 1,
                child: _buildProblemDetails(context, problem),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotFoundScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Problem not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('The requested problem could not be found.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageViewer(MathProblem problem) {
    return Container(
      color: Colors.black,
      child: PhotoView(
        imageProvider: FileImage(problem.imageFile),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3,
        heroAttributes: PhotoViewHeroAttributes(tag: problem.id),
      ),
    );
  }

  Widget _buildProblemDetails(BuildContext context, MathProblem problem) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(problem.status),
                color: _getStatusColor(problem.status),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(problem.status),
                style: TextStyle(
                  color: _getStatusColor(problem.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Created',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDateTime(problem.createdAt),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          if (problem.description != null) ...[
            Text(
              'Description',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              problem.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
          ],
          _buildActionButtons(context, problem),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, MathProblem problem) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: problem.status == ProblemStatus.analyzing
                ? null
                : () => _analyzeProblem(context, problem),
            icon: problem.status == ProblemStatus.analyzing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.analytics),
            label: Text(
              problem.status == ProblemStatus.analyzing 
                  ? 'Analyzing...' 
                  : 'Analyze Problem',
            ),
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () => _shareProblem(context, problem),
          icon: const Icon(Icons.share),
          label: const Text('Share'),
        ),
      ],
    );
  }

  IconData _getStatusIcon(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return Icons.pending;
      case ProblemStatus.analyzing:
        return Icons.hourglass_top;
      case ProblemStatus.solved:
        return Icons.check_circle;
      case ProblemStatus.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return Colors.orange;
      case ProblemStatus.analyzing:
        return Colors.blue;
      case ProblemStatus.solved:
        return Colors.green;
      case ProblemStatus.error:
        return Colors.red;
    }
  }

  String _getStatusText(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.pending:
        return 'Pending Analysis';
      case ProblemStatus.analyzing:
        return 'Analyzing...';
      case ProblemStatus.solved:
        return 'Solved';
      case ProblemStatus.error:
        return 'Error';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _analyzeProblem(BuildContext context, MathProblem problem) {
    final problemService = Provider.of<ProblemService>(context, listen: false);
    problemService.updateProblemStatus(problem.id, ProblemStatus.analyzing);
    
    // Simulate analysis process
    Future.delayed(const Duration(seconds: 3), () {
      problemService.updateProblemStatus(problem.id, ProblemStatus.solved);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analysis started! This is a demo - no actual solving occurs.'),
      ),
    );
  }

  void _shareProblem(BuildContext context, MathProblem problem) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
      ),
    );
  }

  void _deleteProblem(BuildContext context, String problemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Problem'),
        content: const Text('Are you sure you want to delete this problem? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final problemService = Provider.of<ProblemService>(context, listen: false);
              problemService.deleteProblem(problemId);
              Navigator.of(context).pop(); // Close dialog
              context.pop(); // Go back to home screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Problem deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}