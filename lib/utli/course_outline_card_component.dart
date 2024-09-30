import 'package:coursehelp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseOutlineCard extends StatefulWidget {
  final String title;
  final String description;
  final int duration;
  final bool isTextField;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController durationController;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final bool boxtheme;
  final bool isCompleted;
  const CourseOutlineCard(
      {super.key,
      required this.title,
      required this.description,
      required this.duration,
      this.isTextField = false,
      required this.titleController,
      required this.descriptionController,
      required this.durationController,
      required this.onSubmit,
      required this.onCancel,
      this.boxtheme = true,
      this.isCompleted = false});

  @override
  _CourseOutlineCardState createState() => _CourseOutlineCardState();
}

class _CourseOutlineCardState extends State<CourseOutlineCard> {
  bool editModule = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration:
          widget.boxtheme ? AppTheme.modalDecoration : AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: widget.isTextField || editModule
                      ? TextField(
                          controller: widget.titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                          ),
                        )
                      : Text(widget.title, style: AppTheme.heading2),
                ),
                const SizedBox(width: 8),
                if (widget.isCompleted)
                  const CircleAvatar(
                    backgroundColor: AppTheme.teal,
                    child: Icon(
                      Icons.check_circle,
                      color: AppTheme.offWhite,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 8),
            widget.isTextField || editModule
                ? TextField(
                    controller: widget.descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                    ),
                  )
                : Text(widget.description, style: AppTheme.bodyText),
            const SizedBox(height: 8),
            widget.isTextField || editModule
                ? TextField(
                    controller: widget.durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter duration in mins',
                    ),
                  )
                : Text('Duration: ${widget.duration} mins',
                    style: AppTheme.bodyText),
            const SizedBox(height: 8),
            if (widget.isTextField || editModule)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.onSubmit!();
                      widget.titleController.clear();
                      widget.descriptionController.clear();
                      widget.durationController.clear();
                      if (editModule) {
                        setState(() {
                          editModule = false;
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (editModule) {
                        setState(() {
                          editModule = false;
                        });
                      }
                      widget.onCancel!();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            else
              widget.isCompleted
                  ? const SizedBox()
                  : OutlinedButton(
                      onPressed: () {
                        setState(() {
                          editModule = true;
                          widget.titleController.text = widget.title;
                          widget.descriptionController.text =
                              widget.description;
                          widget.durationController.text =
                              widget.duration.toString();

                          // = widget.duration.toString()
                        });
                      },
                      child: const Text('Edit Module'),
                    ),
          ],
        ),
      ),
    );
  }
}
