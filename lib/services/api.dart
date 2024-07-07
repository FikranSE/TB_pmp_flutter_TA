import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tb_pmp/models/login.dart';
import 'package:tb_pmp/models/theses.dart';
import 'package:tb_pmp/models/detail.dart';
import 'package:tb_pmp/models/profile.dart';
import 'package:tb_pmp/models/topic.dart'; 
import 'package:tb_pmp/models/lecturer.dart'; 
import 'package:tb_pmp/services/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://backend-pmp.unand.dev';

  Future<Login?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final authorizationData = responseData['data']['authorization'];
        final loginData = Login.fromJson(authorizationData);

        final profileData = responseData['data']['profile'];
        final userId = profileData['id'];
        await saveUserId(userId);

        return loginData;
      } else {
        print('Failed to login: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  Future<bool> sendDataRequest(
      String thesisId,
      String authToken,
      String to,
      String position,
      String organization,
      String address,
      String requestData) async {
    try {
      final url = Uri.parse('$baseUrl/api/my-thesis/$thesisId/data-request');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'to': to,
          'position': position,
          'organization': organization,
          'address': address,
          'request_data': requestData,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to send data request: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

     Future<List<Theses>> fetchTheses(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/my-theses'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['theses'];
        print('Fetched Theses: $responseData');
        return responseData.map((data) => Theses.fromJson(data)).toList();
      } else {
        print('Failed to load theses: ${response.body}');
        throw Exception('Failed to load theses');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Exception occurred: $e');
    }
  }


Future<Thesis> fetchThesisDetail(String authToken, String thesisId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/my-theses/$thesisId'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('thesis')) {
        return Thesis.fromJson(responseData['thesis']);
      } else {
        throw Exception('Thesis data not found');
      }
    } else {
      throw Exception('Failed to load thesis detail: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Exception occurred: $e');
  }
}

  Future<Lecturer> fetchLecturerDetail(String authToken, String lecturerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/lecturers/$lecturerId'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return Lecturer.fromJson(responseData);
      } else {
        throw Exception('Failed to load lecturer detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception occurred: $e');
    }
  }

  Future<List<ThesisTopic>> fetchTopics(String authToken) async {
    final url = Uri.parse('$baseUrl/api/thesis-topics');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<ThesisTopic> topics = data.map((topic) {
        return ThesisTopic.fromJson(topic);
      }).toList();
      return topics;
    } else {
      throw Exception('Failed to load topics');
    }
  }

 Future<bool> registerTA(Map<String, dynamic> data, String authToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/my-theses');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Thesis Assignment registered successfully');
        return true;
      } else {
        print('Failed to register Thesis Assignment: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

   Future<bool> updateThesis(Map<String, dynamic> data, String authToken, String thesisId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/my-theses/$thesisId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update thesis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception occurred: $e');
    }
  }


  Future<Profile> fetchProfile(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/me'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body)['data'];
        return Profile.fromJson(responseData);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Exception occurred: $e');
    }
  }

  Future<bool> logout(String authToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/logout'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
