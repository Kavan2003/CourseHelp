import 'package:coursehelp/Bloc/moduledetail/moduledetail_bloc.dart';
import 'package:coursehelp/Models/modules_details_model.dart';
import 'package:coursehelp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final int duration;

  const ModuleDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title,
              style: AppTheme.heading1.copyWith(color: Colors.white))),
      body: BlocProvider(
        create: (context) => ModuledetailBloc()
          ..add(GenerateModuleDetail(title, description, duration)),
        child: BlocBuilder<ModuledetailBloc, ModuledetailState>(
          builder: (context, state) {
            if (state is ModuledetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModuledetailLoaded) {
              return _buildModuleDetail(state.module);
            } else if (state is ModuledetailError) {
              return Center(
                  child: Text(state.message, style: AppTheme.bodyText));
            } else {
              return const Center(
                  child: Text('Unknown state', style: AppTheme.bodyText));
            }
          },
        ),
      ),
    );
  }

  Widget _buildModuleDetail(Lessons module) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: module.submodules
          .map((submodule) => _buildSubmoduleDetail(submodule))
          .toList(),
    );
  }

  Widget _buildSubmoduleDetail(Submodule submodule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          submodule.submoduleTitle,
          style: AppTheme.heading2,
        ),
        const SizedBox(height: 8),
        Text(
          'Duration: ${submodule.submoduleDuration} minutes',
          style: AppTheme.bodyText,
        ),
        const SizedBox(height: 8),
        ...submodule.subsubmodules
            .map((subsubmodule) => _buildSubsubmoduleDetail(subsubmodule)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubsubmoduleDetail(Subsubmodule subsubmodule) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subsubmodule.subsubmoduleTitle,
            style: AppTheme.heading2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            subsubmodule.content,
            style: AppTheme.bodyText,
          ),
          if (subsubmodule.diagram != 'NULL') ...[
            const SizedBox(height: 4),
            Container(
              decoration: AppTheme.cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Diagram: ${subsubmodule.diagram}',
                      style: AppTheme.bodyText
                          .copyWith(fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.touch_app_outlined,
                        color: AppTheme.deepBlue),
                  ],
                ),
              ),
            )
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
