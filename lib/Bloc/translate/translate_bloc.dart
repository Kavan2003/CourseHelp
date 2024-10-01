import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coursehelp/Models/course_outine_model.dart';
import 'package:coursehelp/Models/modules_details_model.dart';
import 'package:coursehelp/main.dart';
import 'package:coursehelp/utli/translate_service.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'translate_event.dart';
part 'translate_state.dart';

class TranslateBloc extends Bloc<TranslateEvent, TranslateState> {
  final TranslateService translateService;

  TranslateBloc(this.translateService) : super(TranslateInitial()) {
    on<TranslateText>(
      (event, emit) async {
        emit(TranslateLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          late Course coursedata;
          List<Lessons> moduledata = [];

          // Load data from SharedPreferences
          print(courseOutline.first);
          for (var course in courseOutline) {
            final cachedCourse = prefs.getString(course);
            if (cachedCourse != null) {
              final json = jsonDecode(cachedCourse);
              coursedata = Course.fromJson(json);
            } else {}
          }
          for (var module in moduleDetails) {
            final cachedModule = prefs.getString(module);
            if (cachedModule != null) {
              final json = jsonDecode(cachedModule);
              moduledata.add(Lessons.fromJson(json));
            }
          }

          // print(event.targetLanguage);
          // Extract text fields to translate
          List<String> textsToTranslate = [
            coursedata.title,
            coursedata.description,
            ...coursedata.modules.map((m) => m.title),
            ...coursedata.modules.map((m) => m.description),
            ...moduledata.map((m) => m.title),
            ...moduledata.map((m) => m.description),
            ...moduledata
                .expand((m) => m.submodules.map((s) => s.submoduleTitle)),
            ...moduledata
                .expand((m) => m.submodules.map(
                    (s) => s.subsubmodules.map((ss) => ss.subsubmoduleTitle)))
                .expand((x) => x),
            ...moduledata
                .expand((m) => m.submodules
                    .map((s) => s.subsubmodules.map((ss) => ss.content)))
                .expand((x) => x),
          ];

          // Translate text fields
          List<String> translatedTexts = await Future.wait(
            textsToTranslate.map((text) =>
                translateService.translateText(text, event.targetLanguage)),
          );

          // translatedTexts.forEach((element) {
          //   element = translateService.decodeUnicode(element);
          // });

          // Reconstruct translated Course and Lessons objects
          int index = 0;
          coursedata = Course(
            title: translatedTexts[index++],
            description: translatedTexts[index++],
            modules: coursedata.modules.map((m) {
              return Module(
                title: translatedTexts[index++],
                description: translatedTexts[index++],
                duration: m.duration,
                isAccepted: m.isAccepted,
              );
            }).toList(),
          );

          moduledata = moduledata.map((m) {
            return Lessons(
              title: translatedTexts[index++],
              description: translatedTexts[index++],
              duration: m.duration,
              submodules: m.submodules.map((s) {
                return Submodule(
                  submoduleNumber: s.submoduleNumber,
                  submoduleTitle: translatedTexts[index++],
                  submoduleDuration: s.submoduleDuration,
                  subsubmodules: s.subsubmodules.map((ss) {
                    return Subsubmodule(
                      subsubmoduleNumber: ss.subsubmoduleNumber,
                      subsubmoduleTitle: translatedTexts[index++],
                      subsubmoduleDuration: ss.subsubmoduleDuration,
                      content: translatedTexts[index++],
                      diagram: ss.diagram,
                    );
                  }).toList(),
                );
              }).toList(),
            );
          }).toList();

          emit(TranslateLoaded(coursedata, moduledata));
        } catch (e) {
          emit(TranslateError(e.toString()));
        }
      },
    );
  }
}
