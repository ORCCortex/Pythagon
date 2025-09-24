import 'dart:io';
import 'package:flutter/material.dart';
import '../models/math_problem.dart';

class ProblemCard extends StatelessWidget {
  final MathProblem problem;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProblemCard({
    super.key,
    required this.problem,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildThumbnail(),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContent(context),
              ),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.file(
          problem.imageFile,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.broken_image,
                color: Colors.grey,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          problem.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          _formatDateTime(problem.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(problem.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(problem.status).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(problem.status),
            size: 12,
            color: _getStatusColor(problem.status),
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(problem.status),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(problem.status),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
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
        return 'Pending';
      case ProblemStatus.analyzing:
        return 'Analyzing';
      case ProblemStatus.solved:
        return 'Solved';
      case ProblemStatus.error:
        return 'Error';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day(s) ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour(s) ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }
}