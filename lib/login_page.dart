import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLightMode = false;

  @override
  void initState() {
    super.initState();
    checkThemePreference();
  }

  Future<void> checkThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLightMode = prefs.getBool('isLightMode');
    setState(() {
      this.isLightMode = isLightMode ?? false;
    });
  }

  Future<void> setThemePreference(bool isLightMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightMode', isLightMode);
  }

  Future<void> loginUser() async {
    // Perform login validation and authentication here
    String email = emailController.text;
    String password = passwordController.text;

    // Save the user information locally
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    // Navigate to the home page or any other desired page
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Light Mode'),
                Switch(
                  value: isLightMode,
                  onChanged: (value) {
                    setState(() {
                      isLightMode = value;
                    });
                    setThemePreference(value);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
