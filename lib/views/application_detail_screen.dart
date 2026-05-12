// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878
// File: application_detail_screen.dart
// Description: Displays full application details. Allows edit/delete only when status is Pending.
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_manager.dart';
import '../theme/app_colors.dart';
import '../viewmodels/application_viewmodel.dart';

class ApplicationDetailScreen extends StatelessWidget {
  const ApplicationDetailScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppColors.success;
      case 'Rejected':
        return AppColors.danger;
      case 'Pending':
      default:
        return AppColors.warning;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Application'),
          content: const Text(
            'Are you sure you want to delete this application?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                minimumSize: const Size(120, 46),
              ),
              onPressed: () {
                context.read<ApplicationViewModel>().deleteApplication();
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final application = context.watch<ApplicationViewModel>().application;

    if (application == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Application Details')),
        body: const _EmptyDetailState(),
      );
    }

    final canManage = application.status == 'Pending';
    final statusColor = _statusColor(application.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Application Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.studentName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _StatusBadge(
                        status: application.status,
                        color: statusColor,
                        light: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            icon: Icons.person,
            title: 'Student Details',
            rows: [
              _InfoRow(label: 'Student Name', value: application.studentName),
              _InfoRow(label: 'Year of Study', value: application.yearOfStudy),
            ],
          ),
          _InfoCard(
            icon: Icons.menu_book,
            title: 'First Module Application',
            rows: [
              _InfoRow(
                label: 'Academic Level',
                value: application.firstAcademicLevel,
              ),
              _InfoRow(label: 'Module', value: application.firstModule),
            ],
          ),
          if (application.secondModule != null)
            _InfoCard(
              icon: Icons.library_add,
              title: 'Second Module Application',
              rows: [
                _InfoRow(
                  label: 'Academic Level',
                  value: application.secondAcademicLevel ?? '',
                ),
                _InfoRow(
                  label: 'Module',
                  value: application.secondModule ?? '',
                ),
              ],
            ),
          _InfoCard(
            icon: Icons.verified_user,
            title: 'Eligibility Confirmation',
            rows: [
              _InfoRow(
                label: 'Confirmed',
                value: application.confirmedEligibility ? 'Yes' : 'No',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (canManage) ...[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, RouteManager.editApplication);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Application'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete),
              label: const Text('Delete Application'),
            ),
          ] else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'This application can no longer be edited or deleted.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.rows,
  });

  final IconData icon;
  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.status,
    required this.color,
    this.light = false,
  });

  final String status;
  final Color color;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: light ? Colors.white : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyDetailState extends StatelessWidget {
  const _EmptyDetailState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.assignment_late_outlined,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No application found.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
