import 'package:coursehelp/Bloc/moduledetail/moduledetail_bloc.dart';
import 'package:coursehelp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModuleDetailScreen extends StatefulWidget {
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
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ModuledetailBloc()
              ..add(GenerateModuleDetail(
                  widget.title, widget.description, widget.duration)),
          ),
        ],
        child: BlocBuilder<ModuledetailBloc, ModuledetailState>(
          builder: (context, state) {
            if (state is ModuledetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ModuledetailLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: state.module.submodules.map((submodule) {
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
                      ...submodule.subsubmodules.map((subsubmodule) {
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
                                    child: Text(
                                      'Diagram: ${subsubmodule.diagram}',
                                      style: AppTheme.bodyText.copyWith(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              );
            } else if (state is ModuledetailError) {
              return Center(
                child: Text(state.message, style: AppTheme.bodyText),
              );
            } else {
              return const Center(
                child: Text('Unknown state', style: AppTheme.bodyText),
              );
            }
          },
        ),
      ),
    );
  }
}
