import 'package:flutter/material.dart';
import 'package:mobile_tugas3/pages/clothes_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isError = false;
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: [
            Text(
              "Welcome Back,",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Log in now to continue",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/images/image-login.png",
              height: 250,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Username",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _username,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.supervised_user_circle_sharp,
                  color: Colors.grey,
                ),
                hintText: "Enter your username",
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Color(0xFF0079FB),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Password",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: _password,
              obscureText: !isObscure,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.security_rounded,
                  color: Colors.grey,
                ),
                hintText: "Enter your password",
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isError ? Colors.red : Color(0xFF0079FB),
                    width: 2,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  child: Icon(
                    isObscure ? Icons.remove_red_eye : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                String msg = "";
                if (_username.text == "Shinta Nursobah" &&
                    _password.text == "123220074") {
                  msg = "Login Success";
                  setState(() {
                    isError = false;
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ClothesListPage(),
                  ));
                } else {
                  msg = "Username or Password is failed";
                  setState(() {
                    isError = true;
                  });
                }
                SnackBar snackbar = SnackBar(content: Text(msg));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
