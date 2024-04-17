import 'package:flutter/material.dart';
// import 'package:ui_login/Register.dart';
// import 'package:ui_login/HomeScreen.dart';
import 'package:ui_login/navbar.dart';
// import 'package:ui_login/Home.dart'; // Import the Dart file you want to navigate to

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    // Hardcoded email and password for testing
    String hardcodedEmail = 'test@example.com';
    String hardcodedPassword = 'password123';

    // Retrieve entered email and password
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;

    // Check if entered email and password match the hardcoded values
    if (enteredEmail == hardcodedEmail &&
        enteredPassword == hardcodedPassword) {
      // Successful sign-in logic
      print('Signed in successfully');

      // Navigate to another screen (Home.dart in this example)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    } else {
      // Failed sign-in logic
      print('Sign-in failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingHeight =
        screenHeight * 0.1; // 10% of screen height for padding

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: paddingHeight, horizontal: 20.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 56, 55, 57),
                borderRadius: BorderRadius.circular(50)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          "  Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      TextField(
                        controller: emailController,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 112, 103, 103),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(
                          "  Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 112, 103, 103),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '  Forgot Password?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: signIn,
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add your sign in with Google logic here
                      },
                      icon: Image.asset(
                        'assets/images/googleImage.png', // Replace 'google_logo.png' with the actual path to your Google logo image asset
                        width: 24, // Adjust the width of the image as needed
                        height: 24, // Adjust the height of the image as needed
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add your sign in with Google logic here
                      },
                      icon: Image.asset(
                        'assets/images/apple.png', // Replace 'google_logo.png' with the actual path to your Google logo image asset
                        width: 24, // Adjust the width of the image as needed
                        height: 24, // Adjust the height of the image as needed
                      ),
                      label: Text(
                        'Sign in with Apple',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '  Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
