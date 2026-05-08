import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student_application.dart';
import '../theme/app_colors.dart';
import '../viewmodels/application_viewmodel.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _studentNameController = TextEditingController();

  String? _yearOfStudy;
  String? _firstAcademicLevel;
  String? _firstModule;
  String? _secondAcademicLevel;
  String? _secondModule;

  bool _applyForSecondModule = false;
  bool _confirmedEligibility = false;

  final List<String> _yearsOfStudy = [
    'First Year',
    'Second Year',
    'Third Year',
  ];

  final List<String> _academicLevels = [
    'First Year Module',
    'Second Year Module',
    'Third Year Module',
  ];

  final List<String> _modules = [
    'TPG316C',
    'SOD316C',
    'CMN316C',
    'ITS316C',
    'SOE316C',
  ];

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_confirmedEligibility) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You must confirm that you meet the minimum requirements.',
          ),
        ),
      );
      return;
    }

    final newApplication = StudentApplication(
      userId: '',
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentName: _studentNameController.text.trim(),
      yearOfStudy: _yearOfStudy!,
      firstAcademicLevel: _firstAcademicLevel!,
      firstModule: _firstModule!,
      secondAcademicLevel: _applyForSecondModule ? _secondAcademicLevel : null,
      secondModule: _applyForSecondModule ? _secondModule : null,
      confirmedEligibility: true,
      status: 'Pending',
    );

    await context.read<ApplicationViewModel>().createApplication(newApplication);

    if (!mounted) return;

    final errorMessage = context.read<ApplicationViewModel>().errorMessage;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Application submitted successfully.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasApplication = context.watch<ApplicationViewModel>().hasApplication;

    return Scaffold(
      appBar: AppBar(title: const Text('Application Form')),
      body: hasApplication
          ? const _BlockedApplicationState()
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.assignment_add,
                          color: Colors.white,
                          size: 38,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Assistant Application',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Complete each section to submit your application.',
                                style: TextStyle(
                                  color: Colors.white70,
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

                  _SectionCard(
                    icon: Icons.person,
                    title: '1. Student Details',
                    children: [
                      TextFormField(
                        controller: _studentNameController,
                        decoration: const InputDecoration(
                          labelText: 'Student Full Name',
                          hintText: 'Example: Mpho Ramabulana',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Student name is required';
                          }

                          if (value.trim().length < 3) {
                            return 'Name is too short';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _yearOfStudy,
                        decoration: const InputDecoration(
                          labelText: 'Current Year of Study',
                          prefixIcon: Icon(Icons.calendar_month),
                        ),
                        items: _yearsOfStudy.map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _yearOfStudy = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select your current year of study';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),

                  _SectionCard(
                    icon: Icons.menu_book,
                    title: '2. First Module Application',
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _firstAcademicLevel,
                        decoration: const InputDecoration(
                          labelText: 'Academic Level',
                          prefixIcon: Icon(Icons.layers),
                        ),
                        items: _academicLevels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _firstAcademicLevel = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select the academic level';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _firstModule,
                        decoration: const InputDecoration(
                          labelText: 'Module',
                          prefixIcon: Icon(Icons.book),
                        ),
                        items: _modules.map((module) {
                          return DropdownMenuItem(
                            value: module,
                            child: Text(module),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _firstModule = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a module';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),

                  _SectionCard(
                    icon: Icons.add_task,
                    title: '3. Second Module Application',
                    subtitle:
                        'This section is optional. You may apply for one extra module only.',
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Apply for a second module?'),
                        value: _applyForSecondModule,
                        activeThumbColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _applyForSecondModule = value;

                            if (!_applyForSecondModule) {
                              _secondAcademicLevel = null;
                              _secondModule = null;
                            }
                          });
                        },
                      ),

                      if (_applyForSecondModule) ...[
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          initialValue: _secondAcademicLevel,
                          decoration: const InputDecoration(
                            labelText: 'Second Academic Level',
                            prefixIcon: Icon(Icons.layers_outlined),
                          ),
                          items: _academicLevels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _secondAcademicLevel = value;
                            });
                          },
                          validator: (value) {
                            if (_applyForSecondModule && value == null) {
                              return 'Please select second academic level';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: _secondModule,
                          decoration: const InputDecoration(
                            labelText: 'Second Module',
                            prefixIcon: Icon(Icons.book_outlined),
                          ),
                          items: _modules.map((module) {
                            return DropdownMenuItem(
                              value: module,
                              child: Text(module),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _secondModule = value;
                            });
                          },
                          validator: (value) {
                            if (_applyForSecondModule && value == null) {
                              return 'Please select second module';
                            }

                            if (_applyForSecondModule &&
                                value != null &&
                                value == _firstModule) {
                              return 'Second module cannot be the same as first module';
                            }

                            return null;
                          },
                        ),
                      ],
                    ],
                  ),

                  _SectionCard(
                    icon: Icons.verified_user,
                    title: '4. Eligibility Confirmation',
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.primary,
                        title: const Text(
                          'I confirm that I meet the minimum requirements for the module(s) selected.',
                        ),
                        value: _confirmedEligibility,
                        onChanged: (value) {
                          setState(() {
                            _confirmedEligibility = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),

                  _SectionCard(
                    icon: Icons.upload_file,
                    title: '5. Supporting Documentation',
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.18),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Supporting document upload will be added later using Supabase Storage or File Picker.',
                                style: TextStyle(color: AppColors.textGrey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Consumer<ApplicationViewModel>(
                    builder: (context, applicationVM, child) {
                      return ElevatedButton.icon(
                        onPressed:
                            applicationVM.isLoading ? null : _submitApplication,
                        icon: applicationVM.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                        label: Text(
                          applicationVM.isLoading
                              ? 'Submitting...'
                              : 'Submit Application',
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ...children,
          ],
        ),
      ),
    );
  }
}

class _BlockedApplicationState extends StatelessWidget {
  const _BlockedApplicationState();

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
                    color: AppColors.warning.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.warning,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Application already submitted',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Only one application is allowed per student.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}