import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/components/text_box.dart';

import '../components/my_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // current logged in user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("users");
  var currentPass = TextEditingController();
  var newPass = TextEditingController();
  bool login = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          login = true;
        });
      }
    });
    super.initState();
  }

  // edit field
  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Edit $field",
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey)
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),
          actions: [
            // cancel button
            TextButton(
                onPressed: () => Navigator.of(context).pop(newValue),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
            ),
            // save button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
    );

    try {
      // update in firestore
      if (newValue.trim().length > 0) {
        if (field == 'Email') {
          // update email field
          await usersCollection.doc(currentUser.email).update({field: newValue});

          // Create a new document with the updated email
          await usersCollection.doc(newValue).set({});

          // Copy data from the old document to the new one
          DocumentSnapshot oldDocument =
          await usersCollection.doc(currentUser.email).get();
          if (oldDocument.exists) {
            await usersCollection.doc(newValue)
                .set(oldDocument.data() as Map<String, dynamic>);
          }

          // Delete the old document
          await usersCollection.doc(currentUser.email).delete();

          // update new email
          await currentUser.updateEmail(newValue);
          FirebaseAuth.instance.currentUser!
              .updateEmail(newValue);

          // Navigate back to the home page
          Navigator.pop(context);
        } else if (field != 'Email') {
          await usersCollection.doc(currentUser.email).update({field: newValue});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("P R O F I L E"),
        backgroundColor: Colors.grey[1000],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if(snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
                children: [
                  const SizedBox(height: 50),
                  // profile pic
                  const Icon(
                    Icons.person,
                    size: 72,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  // user email
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 50),

                  //user detials
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  // User's Full Name
                  MyTextBox(
                    text: userData['Name'],
                    sectionName: 'Name',
                    onPressed: () => editField('Name'),
                  ),

                  // Email
                  MyTextBox(
                    text: currentUser.email!,
                    sectionName: 'Email',
                    onPressed: () => editField('Email'),
                  ),

                  const SizedBox(height: 25),

                  //user password
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Password',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MyTextField(
                      controller: currentPass,
                      hintText: 'Current Password',
                      obscureText: true,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MyTextField(
                      controller: newPass,
                      hintText: 'New Password',
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: 120,
                        child: MaterialButton(
                          onPressed: () async {
                            if (currentPass.value.text.isNotEmpty &&
                                newPass.value.text.isNotEmpty) {
                              try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: FirebaseAuth
                                    .instance.currentUser!.email!,
                                    password: currentPass.text);
                                FirebaseAuth.instance.currentUser!
                                .updatePassword(newPass.text);

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Success",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      "Your Password is Updated!",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (error) {

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Error",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      "Error updating password: $error",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            newPass.clear();
                            currentPass.clear();
                          },
                          color: Colors.black,
                          height: 50,
                          minWidth: 120,
                          child: const Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
