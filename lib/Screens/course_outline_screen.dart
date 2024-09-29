import 'package:coursehelp/Models/course_outine_model.dart';
import 'package:coursehelp/Screens/modue_details_screen.dart';
import 'package:coursehelp/bloc/courseoutline/courseoutline_bloc.dart';
import 'package:coursehelp/utli/course_outline_card_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coursehelp/theme.dart';

class CourseOutlineScreen extends StatefulWidget {
  final String title;
  final String description;
  final bool isManual;

  const CourseOutlineScreen({
    super.key,
    required this.title,
    required this.description,
    required this.isManual,
  });

  @override
  _CourseOutlineScreenState createState() => _CourseOutlineScreenState();
}

class _CourseOutlineScreenState extends State<CourseOutlineScreen> {
  void editCourseOutline(Course course) {
    context.read<CourseoutlineBloc>().add(EditCourseOutline(course));
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  bool isPlusClick = false;
  bool reorder = false;
  bool isOutlineComplete = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isManual) {
      context
          .read<CourseoutlineBloc>()
          .add(GenerateCourseOutline(widget.title, widget.description));
    } else {
      context
          .read<CourseoutlineBloc>()
          .add(ManualCourseOutline(widget.title, widget.description));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hold and Drag to reorder'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modules Confirmed'),
          content: const Text('Now Click On Each Module to Complete it'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton(
        style: AppTheme.primaryButton.copyWith(
            padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
            elevation: WidgetStateProperty.all(7)),
        onPressed: () {
          final state = context.read<CourseoutlineBloc>().state;
          if (state is CourseoutlineLoaded) {
            _showDialog(context);
            setState(() {
              isOutlineComplete = true;
              state.course.modules.forEach((module) {
                if (module.title.isEmpty ||
                    module.description.isEmpty ||
                    module.duration == 0) {
                  isOutlineComplete = false;
                } else {
                  module.isAccepted = true;
                }
              });
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: const Text(
          "Confirm Course Outline >",
          style: AppTheme.buttonText,
        ),
      ),
      appBar: AppBar(
        title: const Text("Course Outline"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<CourseoutlineBloc, CourseoutlineState>(
              builder: (context, state) {
            if (state is CourseoutlineLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseoutlineLoaded) {
              return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CourseoutlineBloc>().add(EditCourseOutline(
                        Course(
                            title: state.course.title,
                            description: state.course.description,
                            modules: state.course.modules)));
                  },
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        !isOutlineComplete
                            ? isPlusClick
                                ? CourseOutlineCard(
                                    title: 'New Module',
                                    description: 'New Module Description',
                                    duration: 0,
                                    isTextField: true,
                                    titleController: _titleController,
                                    descriptionController:
                                        _descriptionController,
                                    durationController: _durationController,
                                    onSubmit: () {
                                      final newModule = Module(
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        duration:
                                            _durationController.text.isNotEmpty
                                                ? int.parse(
                                                    _durationController.text)
                                                : 0,
                                      );
                                      final updatedModules = List<Module>.from(
                                          state.course.modules)
                                        ..add(newModule);
                                      final updatedCourse = Course(
                                        title: state.course.title,
                                        description: state.course.description,
                                        modules: updatedModules,
                                      );
                                      editCourseOutline(updatedCourse);
                                      setState(() {
                                        isPlusClick = false;
                                      });
                                    },
                                    onCancel: () {
                                      setState(() {
                                        isPlusClick = false;
                                      });
                                    },
                                  )
                                : GestureDetector(
                                    onTap: () => setState(() {
                                      isPlusClick = true;
                                    }),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      decoration: AppTheme.cardDecoration,
                                      child: const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Icon(Icons.add,
                                              size: 40, color: AppTheme.teal),
                                        ),
                                      ),
                                    ),
                                  )
                            : const SizedBox(),
                        ReorderableListView(
                            buildDefaultDragHandles: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            onReorderStart: (index) {
                              if (!isOutlineComplete) {
                                setState(() {
                                  reorder = true;
                                });
                              }
                            },
                            onReorderEnd: (index) {
                              if (!isOutlineComplete) {
                                setState(() {
                                  reorder = false;
                                });
                              }
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              if (!isOutlineComplete) {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final module =
                                    state.course.modules.removeAt(oldIndex);
                                state.course.modules.insert(newIndex, module);
                                final updatedCourse = Course(
                                  title: state.course.title,
                                  description: state.course.description,
                                  modules: state.course.modules,
                                );
                                editCourseOutline(updatedCourse);
                              }
                            },
                            children: [
                              for (final module in state.course.modules)
                                ReorderableDelayedDragStartListener(
                                    enabled: !isOutlineComplete,
                                    key: ValueKey(module.title),
                                    index: state.course.modules.indexOf(module),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (isOutlineComplete) {
                                          // TODO:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ModuleDetailScreen(
                                                title: module.title,
                                                description: module.description,
                                                duration: module.duration,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: CourseOutlineCard(
                                        isCompleted: module.isAccepted,
                                        boxtheme: reorder,
                                        title: module.title,
                                        description: module.description,
                                        duration: module.duration,
                                        descriptionController:
                                            _descriptionController,
                                        durationController: _durationController,
                                        isTextField: false,
                                        titleController: _titleController,
                                        onCancel: () {
                                          setState(() {
                                            isPlusClick = false;
                                          });
                                        },
                                        onSubmit: () {
                                          final updatedModules =
                                              List<Module>.from(
                                                  state.course.modules);
                                          final updatedModule = Module(
                                            title: _titleController.text,
                                            description:
                                                _descriptionController.text,
                                            duration: _durationController
                                                    .text.isNotEmpty
                                                ? int.parse(
                                                    _durationController.text)
                                                : 0,
                                          );
                                          updatedModules[state.course.modules
                                              .indexOf(module)] = updatedModule;
                                          final updatedCourse = Course(
                                            title: state.course.title,
                                            description:
                                                state.course.description,
                                            modules: updatedModules,
                                          );
                                          editCourseOutline(updatedCourse);
                                          setState(() {
                                            isPlusClick = false;
                                          });
                                        },
                                      ),
                                    ))
                            ])
                      ])));
            } else if (state is CourseoutlineError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Something went wrong '));
            }
          });
        },
      ),
    );
  }
}
