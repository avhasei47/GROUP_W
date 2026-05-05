import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/route_manager.dart';
import '../theme/app_colors.dart';
import '../viewmodels/application_viewmodel.dart';

class EditApplicationScreen extends StatefulWidget {
  const EditApplicationScreen({super.key});

  @override
  State<EditApplicationScreen> createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _studentNameController;

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

  @override
  void initState() {
    super.initState();

    final application = context.read<ApplicationViewModel>().application;

    _studentNameController = TextEditingController(
      text: application?.studentName ?? '',
    );

    _yearOfStudy = application?.yearOfStudy;
    _firstAcademicLevel = application?.firstAcademicLevel;
    _firstModule = application?.firstModule;
    _secondAcademicLevel = application?.secondAcademicLevel;
    _secondModule = application?.secondModule;
    _confirmedEligibility = application?.confirmedEligibility ?? false;

    _applyForSecondModule = application?.secondModule != null;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
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

      context.read<ApplicationViewModel>().updateApplication(
        studentName: _studentNameController.text.trim(),
        yearOfStudy: _yearOfStudy,
        firstAcademicLevel: _firstAcademicLevel,
        firstModule: _firstModule,
        secondAcademicLevel: _applyForSecondModule
            ? _secondAcademicLevel
            : null,
        secondModule: _applyForSecondModule ? _secondModule : null,
        confirmedEligibility: _confirmedEligibility,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application updated successfully.')),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteManager.studentHome,
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final application = context.watch<ApplicationViewModel>().application;

    if (application == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Application')),
        body: const _MessageState(message: 'No application found.'),
      );
    }

    if (application.status != 'Pending') {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Application')),
        body: const _MessageState(
          message:
              'This application can no longer be edited because it is not pending.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Application')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_document, color: Colors.white, size: 36),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Student Assistant Application',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Update your pending application details.',
                          style: TextStyle(color: Colors.white70),
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
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Student name is required';
                    }

                    if (value.length < 3) {
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
                    return DropdownMenuItem(value: year, child: Text(year));
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
                    return DropdownMenuItem(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _firstAcademicLevel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select academic level';
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
                    return DropdownMenuItem(value: module, child: Text(module));
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
                      return DropdownMenuItem(value: level, child: Text(level));
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
                    'I confirm that I meet the minimum requirements for the selected module(s).',
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
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
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
  });

  final IconData icon;
  final String title;
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
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
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

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
