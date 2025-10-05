import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../services/problem_service.dart';
import '../widgets/problem_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pythagon'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildProblemsList(),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.calculate,
            size: 48,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Text(
            'Math Homework Solver',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Capture your math problems and get help solving them',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
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
        if (problemService.problems.isEmpty) {
          return _buildEmptyState(context);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: problemService.problems.length,
          itemBuilder: (context, index) {
            final problem = problemService.problems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProblemCard(
                problem: problem,
                onTap: () => _navigateToProblemViewer(context, problem.id),
                onDelete: () => _deleteProblem(context, problem.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera,
            size: 64,
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
          Text(
            'Tap the camera button to capture your first math problem',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "gallery",
          onPressed: () => _pickFromGallery(context),
          child: const Icon(Icons.photo_library),
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          heroTag: "camera",
          onPressed: () => context.push('/camera'),
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
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

  void _navigateToProblemViewer(BuildContext context, String problemId) {
    context.push('/problem-viewer?problemId=$problemId');
  }

  void _deleteProblem(BuildContext context, String problemId) {
    final problemService = Provider.of<ProblemService>(context, listen: false);
    problemService.deleteProblem(problemId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Problem deleted')),
    );
  }
}