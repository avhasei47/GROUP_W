import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student_application.dart';
import '../routes/route_manager.dart';
import '../viewmodels/admin_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<AdminViewModel>().fetchApplications();
    });
  }

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      RouteManager.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminVM = context.watch<AdminViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AdminViewModel>().fetchApplications();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: adminVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adminVM.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      adminVM.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : adminVM.applications.isEmpty
                  ? const Center(
                      child: Text('No applications found.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: adminVM.applications.length,
                      itemBuilder: (context, index) {
                        final application = adminVM.applications[index];

                        return ApplicationCard(
                          application: application,
                        );
                      },
                    ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final StudentApplication application;

  const ApplicationCard({
    super.key,
    required this.application,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminVM = context.read<AdminViewModel>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application.studentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(application.status)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    application.status,
                    style: TextStyle(
                      color: _statusColor(application.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text('Year of Study: ${application.yearOfStudy}'),
            Text('Academic Level: ${application.firstAcademicLevel}'),
            Text('Module: ${application.firstModule}'),

            if (application.secondModule != null &&
                application.secondModule!.isNotEmpty)
              Text('Second Module: ${application.secondModule}'),

            const SizedBox(height: 8),

            Text(
              application.confirmedEligibility
                  ? 'Eligibility confirmed'
                  : 'Eligibility not confirmed',
              style: TextStyle(
                color: application.confirmedEligibility
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 16),

            if (application.status == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await adminVM.approveApplication(application.id);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application approved'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await adminVM.rejectApplication(application.id);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application rejected'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Application already reviewed.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}