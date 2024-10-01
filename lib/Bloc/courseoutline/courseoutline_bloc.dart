import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coursehelp/Models/course_outine_model.dart';
import 'package:coursehelp/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'courseoutline_event.dart';
part 'courseoutline_state.dart';

class CourseoutlineBloc extends Bloc<CourseoutlineEvent, CourseoutlineState> {
  CourseoutlineBloc() : super(CourseoutlineInitial()) {
    on<GenerateCourseOutline>((event, emit) async {
      emit(CourseoutlineLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedCourse =
            prefs.getString('course_${event.title}_${event.description}');
        if (cachedCourse != null) {
          final json = jsonDecode(cachedCourse);
          final course = Course.fromJson(json);
          emit(CourseoutlineLoaded(course));
          return;
        } else {
          prefs.clear();
        }

        final String prompt =
            '''Generate Course Outline for given title and description.
title:"${event.title}"
description:"${event.description}"
for output the Duration of each module should be in Minutes. 
I want output in JSON format only. and english language. 
follow format just like given example
{"title": "Intro to Blockchain for College Students", "description": "Intro to Blockchain for College Students", "modules": [{"title": "Introduction to Blockchain", "description": "What is Blockchain? How does it work? Key concepts: decentralization, immutability, transparency.", "duration": 20}, {"title": "Blockchain Technology Fundamentals", "description": "Cryptographic Hash Functions, Digital Signatures, Merkle Trees, Consensus Mechanisms (Proof-of-Work, Proof-of-Stake).", "duration": 30}, {"title": "Cryptocurrencies & Bitcoin", "description": "History of Bitcoin, Bitcoin as a cryptocurrency, Understanding Bitcoin transactions, Bitcoin mining.", "duration": 25}, {"title": "Blockchain Applications", "description": "Exploring various use cases of Blockchain: Supply Chain Management, Healthcare, Voting, Finance, NFTs.", "duration": 25}, {"title": "Blockchain Platforms & Smart Contracts", "description": "Introduction to Ethereum, Smart contracts and their applications, Decentralized applications (DApps), Building simple smart contracts.", "duration": 30}, {"title": "Blockchain and the Future", "description": "Challenges and opportunities in Blockchain,  Impact on various industries, Career paths in Blockchain.", "duration": 20}]}
''';
        final response = await model.generateContent([Content.text(prompt)],
            generationConfig:
                GenerationConfig(responseMimeType: "application/json"));

        print(response.text);
        if (response.text != null || response.text != "") {
          final json = jsonDecode(response.text!);
          final course = Course.fromJson(json);
          prefs.setString('course_${event.title}_${event.description}',
              response.text!.toString());
          courseOutline.add('course_${event.title}_${event.description}');

          emit(CourseoutlineLoaded(course));
        } else {
          emit(CourseoutlineError('Error generating course outline'));
        }
      } catch (e) {
        emit(CourseoutlineError('Error generating course outline  $e'));
      }
    });
    on<EditCourseOutline>((event, emit) {
      emit(CourseoutlineLoading());
      emit(CourseoutlineLoaded(event.course));
    });
    on<ManualCourseOutline>(
      (event, emit) {
        emit(CourseoutlineLoading());

        Course course = Course(
            title: event.title, description: event.description, modules: []);
        emit(CourseoutlineLoaded(course));
      },
    );
  }
}
