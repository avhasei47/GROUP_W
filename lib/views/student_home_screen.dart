// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602
// 5.  Mchunu Precious  – 222078878
// File: student_home_screen.dart
// Description: Student dashboard - displays application status and allows navigation.
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_manager.dart';
import '../theme/app_colors.dart';
import '../viewmodels/application_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<ApplicationViewModel>().fetchMyApplication();
    });
  }

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

  Future<void> _logout() async {
    await context.read<AuthViewModel>().logout();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, RouteManager.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<ApplicationViewModel>(
        builder: (context, applicationViewModel, child) {
          final application = applicationViewModel.application;
          final status = application?.status ?? 'Not Submitted';

          final statusColor = application == null
              ? AppColors.textGrey
              : _statusColor(application.status);

          if (applicationViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (applicationViewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  applicationViewModel.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return context.read<ApplicationViewModel>().fetchMyApplication();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Manage your assistant application in one place.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.insights, color: statusColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Application Status',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                status,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        _StatusBadge(status: status, color: statusColor),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                if (application == null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            height: 78,
                            width: 78,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_outlined,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'No application yet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Submit your Student Assistant application and track its progress here.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteManager.applicationForm,
                                );

                                if (!context.mounted) return;

                                context
                                    .read<ApplicationViewModel>()
                                    .fetchMyApplication();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Submit Application'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          RouteManager.applicationDetail,
                        );

                        if (!context.mounted) return;

                        context
                            .read<ApplicationViewModel>()
                            .fetchMyApplication();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              height: 54,
                              width: 54,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.school,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    application.firstModule,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    application.firstAcademicLevel,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  _StatusBadge(
                                    status: application.status,
                                    color: statusColor,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.textGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  'Note: You can only manage your application while it is still Pending.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.color});

  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
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
