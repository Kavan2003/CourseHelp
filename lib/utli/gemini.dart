import 'package:coursehelp/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash-latest',
  apiKey: geminikey!,
);

// class GeminiWrapper {
//   // final GenerativeModel model;

//   // GeminiWrapper(this._model);

//   // Method to generate text
//   Future<String> generateText(String prompt) async {
//     try {
//       final response = await model.generateText(prompt: prompt);
//       return response.text;
//     } catch (e) {
//       // Handle errors appropriately
//       print('Error generating text: $e');
//       return 'Error generating text';
//     }
//   }

//   // Additional methods can be added here as needed
// }