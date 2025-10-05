import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../services/problem_service.dart';
import '../widgets/problem_card.dart';
import '../models/math_problem.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORCCortex - Math Solver'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => _refreshProblems(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildProblemsList(),
          ),
        ],
      ),
      floatingActionButton: _buildFABMenu(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.purple.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calculate,
            size: 56,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            'PDF Math Problem Solver',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload PDF or capture images to extract and solve math problems',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProblemsList() {
    return Consumer<ProblemService>(
      builder: (context, problemService, child) {
        if (problemService.isLoading && problemService.problems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading problems...'),
              ],
            ),
          );
        }

        if (problemService.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading problems',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    problemService.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _refreshProblems(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (problemService.problems.isEmpty) {
          return _buildEmptyState(context);
        }
        
        return RefreshIndicator(
          onRefresh: () => _refreshProblems(context),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: problemService.problems.length,
            itemBuilder: (context, index) {
              final problem = problemService.problems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildEnhancedProblemCard(context, problem),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEnhancedProblemCard(BuildContext context, MathProblem problem) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToProblemViewer(context, problem.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(problem.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(problem.status),
                ],
              ),
              if (problem.pageNumber != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Page ${problem.pageNumber}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
              if (problem.extractedText != null && problem.extractedText!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.text_fields, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 6),
                          Text(
                            'Extracted Text',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        problem.extractedText!.length > 150
                            ? '${problem.extractedText!.substring(0, 150)}...'
                            : problem.extractedText!,
                        style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
              if (problem.mathExpressions != null && problem.mathExpressions!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.functions, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 6),
                          Text(
                            'Math Expressions (${problem.mathExpressions!.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...problem.mathExpressions!.take(3).map((expr) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $expr',
                          style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                        ),
                      )),
                      if (problem.mathExpressions!.length > 3)
                        Text(
                          '... and ${problem.mathExpressions!.length - 3} more',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (problem.status == ProblemStatus.completed)
                    TextButton.icon(
                      onPressed: () {
                        _solveProblem(context, problem.id);
                      },
                      icon: const Icon(Icons.calculate, size: 18),
                      label: const Text('Solve'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green[700],
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () => _navigateToProblemViewer(context, problem.id),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[400],
                    onPressed: () => _deleteProblem(context, problem.id),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProblemStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case ProblemStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case ProblemStatus.processing:
        color = Colors.blue;
        text = 'Processing';
        icon = Icons.sync;
        break;
      case ProblemStatus.analyzing:
        color = Colors.purple;
        text = 'Analyzing';
        icon = Icons.analytics;
        break;
      case ProblemStatus.solved:
        color = Colors.teal;
        text = 'Solved';
        icon = Icons.check_circle_outline;
        break;
      case ProblemStatus.completed:
        color = Colors.green;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      case ProblemStatus.failed:
        color = Colors.red;
        text = 'Failed';
        icon = Icons.error;
        break;
      case ProblemStatus.error:
        color = Colors.red;
        text = 'Error';
        icon = Icons.error_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No problems yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Upload a PDF or capture an image to extract and solve math problems',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _pickPDF(context),
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFABMenu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "pdf",
          onPressed: () => _pickPDF(context),
          backgroundColor: Colors.red,
          tooltip: 'Upload PDF',
          child: const Icon(Icons.picture_as_pdf),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "gallery",
          onPressed: () => _pickFromGallery(context),
          backgroundColor: Colors.purple,
          tooltip: 'Pick from Gallery',
          child: const Icon(Icons.photo_library),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "camera",
          onPressed: () => context.push('/camera'),
          backgroundColor: Colors.blue,
          tooltip: 'Take Photo',
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }

  Future<void> _pickPDF(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        if (!context.mounted) return;
        
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading PDF...'),
                    SizedBox(height: 8),
                    Text(
                      'This may take a moment',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        final problemService = Provider.of<ProblemService>(context, listen: false);
        
        try {
          final problems = await problemService.uploadPDF(file);
          
          if (!context.mounted) return;
          Navigator.pop(context); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ PDF uploaded! ${problems.length} problem(s) found'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'View',
                textColor: Colors.white,
                onPressed: () {
                  if (problems.isNotEmpty) {
                    _navigateToProblemViewer(context, problems.first.id);
                  }
                },
              ),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;
          Navigator.pop(context); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error uploading PDF: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking PDF: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final problemService = Provider.of<ProblemService>(context, listen: false);
        final problem = await problemService.addProblem(
          File(image.path),
          title: 'Problem from Gallery',
        );
        if (context.mounted) {
          _navigateToProblemViewer(context, problem.id);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _refreshProblems(BuildContext context) async {
    final problemService = Provider.of<ProblemService>(context, listen: false);
    await problemService.loadProblems();
  }

  Future<void> _solveProblem(BuildContext context, String problemId) async {
    final problemService = Provider.of<ProblemService>(context, listen: false);
    
    try {
      // Show loading indicator
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
          duration: Duration(seconds: 2),
        ),
      );
      
      await problemService.solveProblem(problemId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Solutions generated!'),
            backgroundColor: Colors.green,
          ),
        );
        _navigateToProblemViewer(context, problemId);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error solving: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToProblemViewer(BuildContext context, String problemId) {
    context.push('/problem-viewer?problemId=$problemId');
  }

  void _deleteProblem(BuildContext context, String problemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Problem'),
        content: const Text('Are you sure you want to delete this problem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final problemService = Provider.of<ProblemService>(context, listen: false);
              problemService.deleteProblem(problemId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Problem deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}