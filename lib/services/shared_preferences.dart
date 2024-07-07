import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAuthToken(String authToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('authToken', authToken);
}

Future<String?> getAuthToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

Future<void> saveIds(String thesisId, String seminarId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('thesisId', thesisId);
  await prefs.setString('seminarId', seminarId);
}

Future<Map<String, String?>> getIds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? thesisId = prefs.getString('thesisId');
  String? seminarId = prefs.getString('seminarId');
  return {'thesisId': thesisId, 'seminarId': seminarId};
}

Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}