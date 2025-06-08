import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://strokepredictionai.runasp.net";


  static Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://strokepredictionai.runasp.net/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);
          String token = responseData['token'];
          print("--------------------------------------------------");
          print(token);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
        } else {
          print("Success, but no token returned.");
          // Optionally show a success message
        }
        return true;
      } else {
        print("Registration failed");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }



  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://strokepredictionai.runasp.net/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save the accessToken
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        print("000000000\n---------------------------");
        print(prefs.getString('accessToken'));

        return true;
      } else {
        print('Login failed');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }


  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> predictStroke({
    required int age,
    required bool hypertension,
    required bool heartDisease,
    required bool everMarried,
    required bool male,
    required String workType,
    required String residenceType,
    required double avgGlucoseLevel,
    required double bmi,
    required String smokingStatus,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final url = Uri.parse('https://strokepredictionai.runasp.net/api/StrokePrediction');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      "gender": male ? "Male" : "Female",
      "age": age,
      "hypertension": hypertension ? 1 : 0,
      "hasHeartDisease": heartDisease ? 1 : 0,
      "everMarried": everMarried !,
      "workType": workType,
      "residence_type": residenceType,
      "avg_glucose_level": avgGlucoseLevel,
      "bmi": bmi,
      "smoking_status": smokingStatus,
    };

    // Debug prints
    print("Sending POST request to: $url");
    print("Headers: $headers");
    print("Body: ${jsonEncode(body)}");

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final prediction = json['prediction'][0];
      await prefs.setString('stroke_result', prediction.toString());
      print("Prediction saved to shared preferences: $prediction");
    } else {
      throw Exception('Prediction failed: ${response.statusCode}');
    }
  }

}

