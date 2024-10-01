import 'package:coursehelp/Bloc/translate/translate_bloc.dart';
import 'package:coursehelp/Models/course_outine_model.dart';
import 'package:coursehelp/Models/modules_details_model.dart';
import 'package:coursehelp/theme.dart';
import 'package:coursehelp/utli/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSelectionDialog extends StatefulWidget {
  const LanguageSelectionDialog({super.key});

  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  String? _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: DropdownButton<String>(
        value: _selectedLanguage,
        hint: const Text('Choose a language'),
        items: [
          'hi-IN',
          'bn-IN',
          'kn-IN',
          'ml-IN',
          'mr-IN',
          'od-IN',
          'pa-IN',
          'ta-IN',
          'te-IN',
          'gu-IN',
          'None'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedLanguage = newValue;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_selectedLanguage != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      TranslatedScreen(selectedLanguage: _selectedLanguage!),
                ),
              );
            }
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }
}

class TranslatedScreen extends StatefulWidget {
  final String selectedLanguage;

  TranslatedScreen({required this.selectedLanguage});

  @override
  _TranslatedScreenState createState() => _TranslatedScreenState();
}

class _TranslatedScreenState extends State<TranslatedScreen> {
  late TranslateBloc _translateBloc;

  @override
  void initState() {
    super.initState();
    TranslateService translateService = TranslateService();
    _translateBloc = TranslateBloc(translateService);
    _translateBloc.add(TranslateText(widget.selectedLanguage));
  }

  @override
  void dispose() {
    _translateBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translated Data',
            style: AppTheme.heading1.copyWith(color: Colors.white)),
      ),
      body: BlocBuilder<TranslateBloc, TranslateState>(
        bloc: _translateBloc,
        builder: (context, state) {
          if (state is TranslateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TranslateLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // const Text('Course Data', style: AppTheme.heading2),
                // const SizedBox(height: 8.0),
                Text(state.translatedTextCourse.title,
                    style: AppTheme.heading1),
                Text(state.translatedTextCourse.description,
                    style: AppTheme.bodyText),
                const SizedBox(height: 16.0),
                ...state.translatedTextCourse.modules
                    .map((module) => _buildModule(module))
                    .toList(),
                const SizedBox(height: 16.0),
                // const Text('Lessons Data', style: AppTheme.heading2),
                // const SizedBox(height: 8.0),
                ...state.translatedTextLesson
                    .map((lesson) => _buildLesson(lesson))
                    .toList(),
              ],
            );
          } else if (state is TranslateError) {
            return Center(
                child: Text(state.message,
                    style: AppTheme.bodyText.copyWith(color: Colors.red)));
          } else {
            return const Center(
                child: Text('Unknown state', style: AppTheme.bodyText));
          }
        },
      ),
    );
  }

  Widget _buildModule(Module module) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(module.title, style: AppTheme.heading2),
        Text(module.description, style: AppTheme.bodyText),
        Text('Duration: ${module.duration} mins', style: AppTheme.bodyText),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildLesson(Lessons lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.title, style: AppTheme.heading2),
        Text(lesson.description, style: AppTheme.bodyText),
        Text('Duration: ${lesson.duration} mins', style: AppTheme.bodyText),
        const SizedBox(height: 8.0),
        ...lesson.submodules
            .map((submodule) => _buildSubmodule(submodule))
            .toList(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSubmodule(Submodule submodule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Submodule ${submodule.submoduleNumber}: ${submodule.submoduleTitle}',
            style: AppTheme.heading1),
        Text('Duration: ${submodule.submoduleDuration} mins',
            style: AppTheme.bodyText),
        // Text(submodule.content, style: AppTheme.bodyText),
        const SizedBox(height: 8.0),
        ...submodule.subsubmodules
            .map((subsubmodule) => _buildSubsubmodule(subsubmodule))
            .toList(),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSubsubmodule(Subsubmodule subsubmodule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Subsubmodule ${subsubmodule.subsubmoduleNumber}: ${subsubmodule.subsubmoduleTitle}',
            style: AppTheme.heading2),
        Text('Duration: ${subsubmodule.subsubmoduleDuration} mins',
            style: AppTheme.bodyText),
        Text(subsubmodule.content, style: AppTheme.bodyText),
        subsubmodule.diagram == 'NULL'
            ? const SizedBox()
            : Text('Diagram: ${subsubmodule.diagram}',
                style: AppTheme.bodyText),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
