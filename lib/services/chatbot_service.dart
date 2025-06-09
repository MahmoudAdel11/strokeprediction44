import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotService {
  static const String strokeApiUrl = "https://strokepredictionai.runasp.net/api/ChatBot/ask";
  static const String geminiApiKey = "AIzaSyA1hUJ1-7QQjEDUltKUNnuh5A_yLi6_Glw";

  final GenerativeModel geminiModel = GenerativeModel(
    model: 'gemini-pro',
    apiKey: geminiApiKey,
  );


  static Future<String> askStrokeApi(String question) async {
    try {
      final response = await http.post(
        Uri.parse(strokeApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      print('🔹 API Response Status: ${response.statusCode}');
      print('🔹 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);


        if (responseData.containsKey("candidates") &&
            responseData["candidates"].isNotEmpty &&
            responseData["candidates"][0].containsKey("content") &&
            responseData["candidates"][0]["content"].containsKey("parts") &&
            responseData["candidates"][0]["content"]["parts"].isNotEmpty) {
          return responseData["candidates"][0]["content"]["parts"][0]["text"];
        } else {
          return "⚠ Unexpected API response format.";
        }
      } else {
        return "⚠ API Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      return " Error: Unable to connect to the API. Check your internet or API status.";
    }
  }

  //....................... Gemini AI as a fallback
  Future<String> askGemini(String question) async {
    try {
      final content = [Content.text(question)];
      final response = await geminiModel.generateContent(content);
      return response.text ?? "No response from Gemini AI.";
    } catch (e) {
      return "Error: Failed to get response from Gemini AI.";
    }
  }

  // .................Decides which API to use
  Future<String> getChatbotResponse(String question) async {
    String response = await askStrokeApi(question);

    // ............. use Gemini AI as fallback
    if (response.contains("Error") || response.isEmpty) {
      response = await askGemini(question);
    }

    return response;
  }
}
