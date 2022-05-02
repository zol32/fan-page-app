import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfanpage/constants/routes.dart';
import 'package:myfanpage/services/auth/auth_service.dart';
import 'package:myfanpage/services/auth/cloud_service.dart';
import '../constants/menu_action.dart';

class FanPage extends StatefulWidget {
  const FanPage({Key? key}) : super(key: key);

  @override
  State<FanPage> createState() => _FanPageState();
}

class _FanPageState extends State<FanPage> {
  late final AuthService _auth;
  late final CloudService _cloud;
  late final String _uid = _auth.currentUser!.uid;

  CollectionReference posts = FirebaseFirestore.instance.collection("posts");

  @override
  void initState() {
    _auth = AuthService();
    _cloud = CloudService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cloud.isAdmin(_uid),
        builder: (context, snapshot) {
          final String data = snapshot.data.toString();
          final bool isAdmin = data == 'true';
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Fan Page'),
                  actions: [
                    PopupMenuButton<MenuAction>(
                      onSelected: (value) async {
                        switch (value) {
                          case MenuAction.logout:
                            final shouldLogout =
                                await showLogOutDialog(context);
                            if (shouldLogout) {
                              await _auth.logOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute,
                                (_) => false,
                              );
                            }
                        }
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem<MenuAction>(
                            value: MenuAction.logout,
                            child: Text('Log out'),
                          ),
                        ];
                      },
                    )
                  ],
                ),
                body: StreamBuilder<QuerySnapshot>(
                    stream: posts.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text(
                            "Something went wrong querying users");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                          children:
                              snapshot.data!.docs.map((DocumentSnapshot doc) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(doc.get('image_url')),
                            ),
                            title: Text(
                              doc.get('caption'),
                              style: TextStyle(color: Colors.white),
                            ),
                            tileColor: Colors.lightBlue,
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 0.5),
                                borderRadius: BorderRadius.circular(5)),
                            // subtitle: Text(doc.get('post_created').toString()),
                          ),
                        );
                      }).toList());
                    }),
                floatingActionButton: isAdmin
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(createPostRoute);
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(Icons.add),
                      )
                    : null,
              );
            default:
              return const Text('ERROR');
          }
        });
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
          ],
        );
      }).then((value) => value ?? false);
}
