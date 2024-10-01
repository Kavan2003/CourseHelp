import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coursehelp/Models/modules_details_model.dart';
import 'package:coursehelp/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'moduledetail_event.dart';
part 'moduledetail_state.dart';

class ModuledetailBloc extends Bloc<ModuledetailEvent, ModuledetailState> {
  ModuledetailBloc() : super(ModuledetailInitial()) {
    on<GenerateModuleDetail>((event, emit) async {
      emit(ModuledetailLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedModule = prefs.getString(
            'module_${event.title}_${event.description}_${event.duration}');
        if (cachedModule != null) {
          final json = jsonDecode(cachedModule);
          final module = Lessons.fromJson(json);
          emit(ModuledetailLoaded(module));
          return;
        }
        final String prompt = '''


Create Detailed Lesson according to given Title , Description , Duration (given in minutes) and number. First divide lessons into sub lessons then give output for details of each modules. content in sub lesson and no of lessons should be according to durations.
for each number.division give explanations that can be directly spoken to audiance or read and understood, if require suggestion of Diagram in text format Like example "Flow chart for API call having Client and Server".
types of possible Diagram: Pie chart, Flow chart, Mind Map Give full details Dont ask or tell to explain take it Like Notes for Students.
"title": "${event.title}", "description": "${event.description}", "duration": ${event.duration}


Foramt example is given below
{
  "title": "",
  "description": "",
  "duration": 20,
  "modules": [
    {
      "module_number": 1,
      "module_title": "",
      "module_duration": 10,
      "submodules": [
        {
          "submodule_number": 1.1,
          "submodule_title": "",
          "submodule_duration": 3,
          "content": "",
          "Diagram": ""
        },
        
      ]
    },
    {
      "module_number": 2,
      "module_title": "",
      "module_duration": 10,
      "submodules": [
        {
          "submodule_number": 2.1,
          "submodule_title": "",
          "submodule_duration": 3,
          "content": ""
        ,"Diagram": "NULL"
        },
        {
          "submodule_number": 2.2,
          "submodule_title": "",
          "submodule_duration": 3,
          "content": ""
       ,"Diagram": "NULL"
        },
        
      ]
    }
  ]
}



''';
        final response = await model.generateContent([Content.text(prompt)],
            generationConfig:
                GenerationConfig(responseMimeType: "application/json"));

        print(response.text);
        if (response.text != null || response.text != "") {
          final json = jsonDecode(response.text!);
          final module = Lessons.fromJson(json);
          prefs.setString(
              'module_${event.title}_${event.description}_${event.duration}',
              response.text!);
          moduleDetails.add(
              'module_${event.title}_${event.description}_${event.duration}');

          emit(ModuledetailLoaded(module));
        } else {
          emit(ModuledetailError(
              'Error generating course outline response was empty'));
        }
      } catch (e) {
        emit(ModuledetailError('Error generating course outline  $e'));
      }
    });
    on<EditGeneratedModuleDetails>(
      (event, emit) async {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove(
            'module_${event.title}_${event.description}_${event.duration}');
        final cashed = prefs.setString(
            'module_${event.title}_${event.description}_${event.duration}',
            event.module.toJson().toString());
        emit(ModuledetailLoading());
        emit(ModuledetailLoaded(event.module));
      },
    );
  }
}
