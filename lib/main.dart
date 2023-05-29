import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_dept_app/screens/details_screen.dart';
import 'package:tourism_dept_app/screens/loading_screen.dart';
import 'package:tourism_dept_app/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tourism_dept_app/screens/login_screen.dart';
import 'package:tourism_dept_app/screens/new_post.dart';
import 'package:tourism_dept_app/screens/profilePage_screen.dart';

//import 'screens/login_screen.dart';
//import 'screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _intialized = false;
  bool _error = false;
  //
  void intializeflutterfire() async {
    try {
      await Firebase.initializeApp();
      print('awel khatwa ');
      setState(() {
        _intialized = true;
      });
      print('el intialization et3ayare = 1');
    } catch (e) {
      setState(() {
        print('el intialization et3ayare = 0');
        _error = true;
      });
    }
  }

  @override
  void initState() {
    intializeflutterfire();
    super.initState();
  }

  Widget ShowAppropriateScreen() {
    if (_intialized) {
      {
        print('el intualization b 1');
        var postsInstance = FirebaseFirestore.instance.collection('Post');
        var postsSnapshots = postsInstance.snapshots();
        postsSnapshots.listen((snapshot) {
          snapshot.docs.forEach((doc) {
            print(doc.data()['Name']);
          });
        });

        return const LoginScreen();
      }
    } else if (_error) {
      print('el error b 1');
      return const Text('Error');
    } else {
      return LoadingScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourism App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (dummyCtx) => Home(),
        '/PostDetailsScreen': (dummyCtx) => PostDetailsScreen(
              postId: 'zkJ0EsM1iYEBycuRjj32',
            ),
        '/profile': (dummyCtx) => ProfilePage(
              email: '',
              username: '',
            ),
      },
    );
  }
}
