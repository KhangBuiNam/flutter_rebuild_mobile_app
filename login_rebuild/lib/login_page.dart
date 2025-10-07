import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> writeCache() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('username');
    final savedPass = prefs.getString('password');

    print("📦 PREF LOADED:");
    print("Username: $savedUser");
    print("Password: $savedPass");

    if (_usernameController.text == savedUser &&
        _passwordController.text == savedPass) {
      print("✅ Login successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      print("❌ Wrong username or password!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu!')),
      );
    }
  }

  Future<void> _signUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);

    print("🔥 PREF IS SAVED!");
    print("Username: ${_usernameController.text}");
    print("Password: ${_passwordController.text}");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tạo tài khoản thành công!')));
  }

  Future<void> _forgotPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final pass = prefs.getString('password') ?? 'Chưa có mật khẩu nào được lưu';
    print("🔍 Forgot password requested → $pass");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Mật khẩu của bạn: $pass')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 45),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Tài khoản",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Mật khẩu",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: writeCache,
                  child: const Text("Đăng nhập"),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _signUp,
                  child: const Text("Tạo tài khoản mới"),
                ),
                TextButton(
                  onPressed: _forgotPassword,
                  child: const Text("Quên mật khẩu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
