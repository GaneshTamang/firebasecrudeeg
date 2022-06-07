// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStudentPage extends StatefulWidget {
  //class parameter area
  //state value for string
  final String id;

  const UpdateStudentPage({Key? key, required this.id
      //after declared parameter  should be passed for key required for fuction here
      })
      : super(key: key);

  @override
  State<UpdateStudentPage> createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  bool hide = true;
  void showhide() {
    hide = !hide;
    setState(() {});
  }

  final _formkey = GlobalKey<FormState>();
  //adding student but first takeing ref on firesore
  //updating
  CollectionReference std = FirebaseFirestore.instance.collection('students');
//creating future function that will be called
  Future<void> editUser(id, name, email, password) {
    return std
        .doc(id)
        .update({'name': name, 'email': email, 'password': password})
        .then((value) => print('user updated'))
        .catchError((error) => print('Failed to upload:$error'));
  }

  // updateUser() {
  //   print('userupdated');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update student details'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
            key: _formkey,
            //getting specific data by id
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('students')
                  .doc(widget.id)
                  .get(),
              builder: (_, snapshot) {
                //if errot
                if (snapshot.hasError) {
                  print('something went wrog');
                }
                //if wating
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //creating data
                var data = snapshot.data!.data();
                var name = data!['name'];
                //once recieved no need to declare not null
                var email = data['email'];
                var password = data['password'];
                //then return

                return ListView(
                  children: [
                    //name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        initialValue: name,
                        //value to send after change
                        onChanged: (value) => name = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'name',
                            labelText: 'Name',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),

                    //email
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        initialValue: email,
                        //value to send after change
                        onChanged: (value) => email = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter email';
                          } else if (!value.contains('@')) {
                            return 'enter valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),

                    //password

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: false,
                        obscureText: hide,
                        initialValue: password,
                        //value to send after change
                        //here value is temporary stored data

                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'password',
                            labelText: 'password',
                            suffixIcon: IconButton(
                                onPressed: showhide,
                                icon: Icon(hide
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    //buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              //checking validation
                              if (_formkey.currentState!.validate()) {
                                editUser(widget.id, name, email, password);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('update')),
                        ElevatedButton(
                            onPressed: () => {}, child: const Text('reset')),
                      ],
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}
