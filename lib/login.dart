import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognitive_app/user/user_main.dart';
import 'package:cognitive_app/signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Perform login
                await _login();
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                // Navigate to the signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                );
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    bool isValid = await _authenticate(username, password);

    if (isValid) {
      // Clear text fields
      _usernameController.clear();
      _passwordController.clear();

      // Save login status and navigate to another screen
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Retrieve and store user scores
      List<int> scores =
          prefs.getStringList('${username}_scores')?.map(int.parse).toList() ??
              [];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserMain(
            baseUri:
                'https://d16a-34-69-129-189.ngrok-free.app/generate-dictionary/',
            username: username,
            scores: scores,
          ),
        ),
      );
    } else {
      // Handle invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Credentials'),
            content: const Text('Please enter valid username and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _authenticate(String username, String password) async {
    // Bypass logic: if the username and password match the bypass credentials, return true
    if ((username == 'admin' && password == 'admin123') ||
        (username == 'bypassUser' && password == 'bypassPassword')) {
      return true;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString(username);

    // Check if username exists and password matches
    return storedPassword != null && storedPassword == password;
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
