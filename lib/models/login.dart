import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    final String token;
    final String type;
    final int expiresAt;

    Login({
        required this.token,
        required this.type,
        required this.expiresAt,
    });

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        token: json["token"],
        type: json["type"],
        expiresAt: json["expires_at"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "type": type,
        "expires_at": expiresAt,
    };
}