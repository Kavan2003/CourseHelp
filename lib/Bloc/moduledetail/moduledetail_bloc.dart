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
types of possible Diagram: Pie chart, Flow chart, Mind Map.
"title": "${event.title}", "description": "${event.description}", "duration": ${event.duration}


Foramt example is given below
{
  "title": "Introduction to Blockchain",
  "description": "What is Blockchain? How does it work? Key concepts: decentralization, immutability, transparency.",
  "duration": 20,
  "modules": [
    {
      "module_number": 1,
      "module_title": "Understanding Blockchain Fundamentals",
      "module_duration": 10,
      "submodules": [
        {
          "submodule_number": 1.1,
          "submodule_title": "What is Blockchain?",
          "submodule_duration": 3,
          "content": "Define blockchain as a distributed ledger technology. Explain its core function of recording transactions securely and transparently. Provide relatable examples like a digital record book shared across a network.",
          "Diagram": "Flow chart showing the process of recording transactions on a blockchain"
        },
        {
          "submodule_number": 1.2,
          "submodule_title": "Key Characteristics of Blockchain",
          "submodule_duration": 4,
          "content": "Explain Decentralization: Data not stored in a single location, but across multiple nodes, enhancing security and resilience. Illustrate with a network diagram showing interconnected nodes. Explain Immutability: Once a transaction is added to the blockchain, it cannot be altered. Describe its significance in building trust and preventing fraud. Explain Transparency: All transactions are viewable by anyone on the network. Discuss the benefits and drawbacks of this open nature."
       ,"Diagram": "Mind Map showing Key Characteristics of Blockchain: Decentralization, Immutability, Transparency"
        },
        {
          "submodule_number": 1.3,
          "submodule_title": "How Blockchain Works: A Simplified View",
          "submodule_duration": 3,
          "content": "Explain the basic process: transaction initiation, verification by nodes, grouping into blocks, adding blocks to the chain. Use a simple diagram to illustrate the chaining process: Block 1 -> Block 2 -> Block 3, each linked and secured by cryptography."
        ,"Diagram": "NULL"
        }
      ]
    },
    {
      "module_number": 2,
      "module_title": "Deep Dive into Key Concepts",
      "module_duration": 10,
      "submodules": [
        {
          "submodule_number": 2.1,
          "submodule_title": "Decentralization: Benefits and Challenges",
          "submodule_duration": 3,
          "content": "Discuss the advantages of decentralization: increased security, fault tolerance, censorship resistance. Highlight its potential to democratize various sectors. Address the challenges: scalability issues, potential for disagreements among nodes, regulatory uncertainties."
        ,"Diagram": "NULL"
        },
        {
          "submodule_number": 2.2,
          "submodule_title": "Immutability: Ensuring Data Integrity",
          "submodule_duration": 3,
          "content": "Explain how cryptographic hashing ensures immutability. Describe the concept of a hash function and its role in creating a unique fingerprint for each block. Briefly mention how tampering with data would change the hash, making it evident."
       ,"Diagram": "NULL"
        },
        {
          "submodule_number": 2.3,
          "submodule_title": "Transparency: A Double-Edged Sword",
          "submodule_duration": 2,
          "content": "Discuss the advantages of transparency: increased accountability, reduced risk of fraud, building trust in the system. Highlight the concerns: privacy issues, potential for misuse of publicly available information. Mention privacy-enhancing techniques being developed for blockchains."
        ,"Diagram": "NULL"
        },
        {
          "submodule_number": 2.4,
          "submodule_title": "Real-world Applications",
          "submodule_duration": 2,
          "content": "Provide brief examples of blockchain use cases: cryptocurrency (Bitcoin, Ethereum), supply chain management, digital identity, voting systems. Discuss the potential impact of blockchain technology on various industries."
        ,"Diagram": "NULL"
        }
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
