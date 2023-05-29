import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_dept_app/screens/loading_screen.dart';
import 'package:tourism_dept_app/screens/login_screen.dart';
import 'package:tourism_dept_app/widgets/categories.dart';
import 'package:tourism_dept_app/widgets/post_card.dart';
import 'package:tourism_dept_app/widgets/search_box.dart';

import '../widgets/bottom_bar.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loggedIn = false;
  String username = "";
  String email = "";

  void initState() {
    super.initState();

    // Check if the user is signed in
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          loggedIn = true;
          getUserData(user.uid).then((userData) {
            username = userData?['username'];
            email = userData?['email'];
          });
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    // Get the user's data from Firestore
    var userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userDoc.data();
  }

  @override
  Widget build(BuildContext context) {
    var postsInstance = FirebaseFirestore.instance.collection('posts');
    var stream = postsInstance.snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text("Tourism Travel app"),
          actions: [
            if (loggedIn)
              Padding(
                padding: EdgeInsets.only(right: 7.0),
                child: GestureDetector(
                  onTap: () {
                    // Show popup menu when the user taps on the avatar icon
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width - 100,
                          80.0,
                          0.0,
                          0.0),
                      items: [
                        PopupMenuItem(
                          height: 18.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Welcome  " + username),
                              Row(children: [
                                Text("Email : " + email),
                              ]),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the user's profile page
                                  Navigator.pushNamed(context, '/profile',
                                      arguments: {
                                        'username': username,
                                        'email': email
                                      });
                                },
                                child: Text('Go to Profile'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  child: CircleAvatar(
                    child: Text(username[0]),
                  ),
                ),
              ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              InkWell(
                child: ListTile(
                  leading: (user == null)
                      ? const Icon(Icons.login_rounded)
                      : const Icon(Icons.logout_rounded),
                  title: (user == null)
                      ? const Text('Create Account')
                      : const Text('Log Out'),
                  onTap: () {
                    if (user != null) {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hi there 👋', style: TextStyle(fontSize: 20.0)),
                  const Text(
                    'Take a virtual museum tour',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  const SearchBox(),
                  const Categories(),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingScreen();
                              }
                              if (!snapshot.hasData) {
                                return LoadingScreen();
                              }
                              var posts = snapshot.data!.docs;
                              return posts.isEmpty
                                  ? const Center(child: Text('No posts found'))
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        var document =
                                            posts[index].data() as Map;
                                        return PostCard(
                                          title: document['name'],
                                          location: document['location'],
                                          imageUrl: document['imageUrl'],
                                          category: document['type'],
                                        );
                                      },
                                      itemCount: posts.length,
                                    );
                            }),
                      ),
                    ),
                  )
                ],
              )),
        ),
        bottomNavigationBar: const BottomBar());
  }
}
