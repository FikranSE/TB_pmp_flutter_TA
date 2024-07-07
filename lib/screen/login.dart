import 'package:flutter/material.dart';
import 'package:tb_pmp/services/api.dart';
import 'package:tb_pmp/models/login.dart';
import 'package:tb_pmp/screen/ListScreen.dart';
import 'package:tb_pmp/services/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    Login? login = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (login != null) {
      await saveAuthToken(login.token);
      _showAlertDialog('Login successful', true, login.token);
    } else {
      _showAlertDialog('Login failed', false, null);
    }
  }

  void _showAlertDialog(String message, bool success, String? authToken) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
          if (success && authToken != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ListScreen(authToken: authToken),
              ),
            );
          }
        });

        return AlertDialog(
          title: Text(success ? 'Success' : 'Error'),
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.9,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _emailController,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black), // Menambahkan style untuk teks
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.black), // Menambahkan style untuk label
                              prefixIcon: const Icon(Icons.person),
                            ),
                            textAlignVertical: TextAlignVertical.center, // Mengatur keselarasan vertikal teks
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _passwordController,
                            maxLines: 1,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black), // Menambahkan style untuk teks
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black), // Menambahkan style untuk label
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            textAlignVertical: TextAlignVertical.center, // Mengatur keselarasan vertikal teks
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 45,
                          width: 300,
                          child: MaterialButton(
                            color: const Color.fromARGB(255, 89, 99, 60),
                            textColor: Colors.white,
                            child: const Text('Login'),
                            onPressed: _login,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 300,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 61, 68, 41),
                                decoration: TextDecoration.none,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
