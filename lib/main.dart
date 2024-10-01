import 'package:coursehelp/Bloc/moduledetail/moduledetail_bloc.dart';
import 'package:coursehelp/Screens/course_outline_screen.dart';
import 'package:coursehelp/bloc/courseoutline/courseoutline_bloc.dart';
import 'package:coursehelp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

late final String? geminikey;
late final GenerativeModel model;
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  geminikey = dotenv.get('API_KEY', fallback: "");

  if (geminikey == "") {
    print('No \$API_KEY environment variable');
    return;
  }
  model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: geminikey!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CourseoutlineBloc()),
        BlocProvider(create: (context) => ModuledetailBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.themeData,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Creation Copilot"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        color: AppTheme.offWhite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Get Started by entering your course title & details",
                style: AppTheme.heading1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                cursorOpacityAnimates: true,
                enableSuggestions: true,
                decoration: AppTheme.inputDecoration.copyWith(
                  labelText: "Course Title",
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                cursorOpacityAnimates: true,
                enableSuggestions: true,
                decoration: AppTheme.inputDecoration.copyWith(
                  labelText: "Course Description",
                ),
                maxLines: 10,
                minLines: 2,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                cursorOpacityAnimates: true,
                enableSuggestions: true,
                decoration: AppTheme.inputDecoration.copyWith(
                  labelText: "Alternate Language for Course",
                ),
                maxLines: 10,
                minLines: 2,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseOutlineScreen(
                            title: titleController.text,
                            description: descriptionController.text,
                            isManual: false,
                          ),
                        ),
                      );
                    },
                    style: AppTheme.primaryButton,
                    child: const Text("Generate Outline",
                        style: AppTheme.buttonText),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseOutlineScreen(
                            title: titleController.text,
                            description: descriptionController.text,
                            isManual: true,
                          ),
                        ),
                      );
                    },
                    style: AppTheme.secondaryButton,
                    child: const Text("Manually", style: AppTheme.buttonText),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class CourseOutlineScreen extends StatelessWidget {
//   final String title;
//   final String description;

//   const CourseOutlineScreen({
//     super.key,
//     required this.title,
//     required this.description,
//   });

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: Text(title),
//   //       backgroundColor: AppTheme.deepBlue,
//   //     ),
//   //     body: Padding(
//   //       padding: const EdgeInsets.all(16.0),
//   //       child: Text(description),
//   //     ),
//   //   );
//   // }
// }
