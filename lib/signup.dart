import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognitive_app/user/Dashboard.dart';
import 'package:cognitive_app/user/user_main.dart';

class Player {
  String name;
  String email;
  String password;
  List<int> scores;

  Player({
    required this.name,
    required this.email,
    required this.password,
    required this.scores,
  });
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _passwordVisible = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signup(String username, String email, String password) async {
    // Perform validation
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill all fields.');
      return;
    }

    // Assuming no scores initially
    List<int> scores = [];

    // Create Player instance
    Player player = Player(
      name: username,
      email: email,
      scores: scores,
      password: password,
    );

    // Save Player instance using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(username, password);
    // Convert scores list to String before saving
    await prefs.setStringList(
        '${username}_scores', scores.map((score) => score.toString()).toList());

    // After successful signup, navigate to another screen
    // For example, navigate to the dashboard
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
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
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
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
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
              onPressed: () {
                // Sign up logic here
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                _signup(username, email, password);
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignupScreen(),
  ));
}
