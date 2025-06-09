import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strokeprediction/models/Reminder_Model.dart';

class ReminderService {
  final String baseUrl = 'https://strokepredictionai.runasp.net/api/Reminders';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }


  Future<List<MedicineReminder>> fetchReminders() async {
    final token = await _getToken();
    if (token == null) {
      print(' Token is null');
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(' Fetch reminders status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body;
        if (body.isEmpty) {
          print('Response body is empty');
          return [];
        }

        final List<dynamic> jsonData = json.decode(body);
        return jsonData
            .map((e) => MedicineReminder.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print(' Failed to fetch reminders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(' Error fetching reminders: $e');
      return [];
    }
  }



  Future<bool> addReminder(MedicineReminder reminder) async {
    final token = await _getToken();
    if (token == null) {
      print('⚠ Token is null');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(reminder.toJson()),
      );

      print(' Add reminder status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print(' Error adding reminder: $e');
      return false;
    }
  }

  Future<bool> updateReminder(int id, MedicineReminder reminder) async {
    final token = await _getToken();
    if (token == null) {
      print('️ Token is null');
      return false;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(reminder.toJson()),
      );

      print('️ Update reminder status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print(' Error updating reminder: $e');
      return false;
    }
  }


  Future<bool> deleteReminder(int id) async {
    final token = await _getToken();
    if (token == null) {
      print(' Token is null');
      return false;
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(' Delete reminder status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print(' Error deleting reminder: $e');
      return false;
    }
  }
}
