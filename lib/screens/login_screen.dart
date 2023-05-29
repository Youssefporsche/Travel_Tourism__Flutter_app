import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_dept_app/screens/home.dart';
import 'package:tourism_dept_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/*Widget BuildEmail() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Email',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    SizedBox(
      height: 10,
    ),
    Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      height: 60,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.black, fontSize: 25),
        decoration: InputDecoration(
            border: InputBorder.none,
            //contentPadding: EdgeInsets.only(top:14),
            prefixIcon: Icon(Icons.mail, color: Colors.blue),
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    )
  ]);
}*/

/*Widget BuildPassword() {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Password',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    SizedBox(
      height: 10,
    ),
    Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      height: 60,
      child: TextField(
        obscureText: true,
        style: TextStyle(color: Colors.black, fontSize: 25),
        decoration: InputDecoration(
            border: InputBorder.none,
            //contentPadding: EdgeInsets.only(top:14),
            prefixIcon: Icon(Icons.lock, color: Colors.blue),
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.black38)),
      ),
    )
  ]);
}*/

/*Widget BuildPasswordBtn() {
  return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 0),
      child: TextButton(
          onPressed: () => print('forgot password button was pressed'),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )));
}*/

/*Widget buildSignupBtn() {
  return GestureDetector(
      onTap: () => print('Sign up button was pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ));*/

/*Widget buildLoginBtn() {
  return Container(
      padding: EdgeInsets.symmetric(),
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () => print('elevated button was clicked'),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            onPrimary: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        child: Text('LOGIN'),
      ));
}*/

class _LoginScreenState extends State<LoginScreen> {
  @override
  bool LoggedIn = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final authenticationInstance = FirebaseAuth.instance;
  late UserCredential authResult;

  Widget BuildEmail() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontSize: 25),
          decoration: InputDecoration(
              border: InputBorder.none,
              //contentPadding: EdgeInsets.only(top:14),
              prefixIcon: Icon(Icons.mail, color: Colors.blue),
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ]);
  }

  Widget BuildPassword() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 60,
        child: TextField(
          controller: passwordController,
          obscureText: true,
          style: TextStyle(color: Colors.black, fontSize: 25),
          decoration: InputDecoration(
              border: InputBorder.none,
              //contentPadding: EdgeInsets.only(top:14),
              prefixIcon: Icon(Icons.lock, color: Colors.blue),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black38)),
        ),
      )
    ]);
  }

  Widget BuildPasswordBtn() {
    return Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 0),
        child: TextButton(
            onPressed: () => print('forgot password button was pressed'),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )));
  }

  Widget buildSignupBtn() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        },
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ));
  }

  Widget buildLoginBtn() {
    return Container(
        padding: const EdgeInsets.symmetric(),
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: () async {
            //   Navigator.push(context,  MaterialPageRoute(builder: (context) => const SignUpScreen()));
            // FirebaseFirestore.instance.collection('Post').add({'text': 'hi', 'userId': 'mghantous'}).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));

            authenticationInstance
                .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
                .then((value) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
              LoggedIn = true;
            });
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              onPrimary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          child: const Text('LOGIN'),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            child: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0x6621a5ff),
                Color(0x9921a5ff),
                Color(0xcc21a5ff),
                Color(0xff21a5ff),
              ])),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            physics: const AlwaysScrollableScrollPhysics(),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              BuildEmail(),
              const SizedBox(height: 20),
              BuildPassword(),
              //BuildPasswordBtn(),
              const SizedBox(height: 40),
              buildLoginBtn(),
              const SizedBox(height: 10),
              buildSignupBtn()
            ]),
          ),
        )
      ],
    )));
  }
}
