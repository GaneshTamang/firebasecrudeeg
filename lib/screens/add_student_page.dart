// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  bool hide = true;
  void showhide() {
    hide = !hide;
    setState(() {});
  }

  var name = "";
  var email = "";
  var password = "";

  //global key
  final _formkey = GlobalKey<FormState>();
  //controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  disposed() {
    //clean up the controller when widget is disposed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  clearText() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  //adding student first takeing ref on firesore
  CollectionReference std = FirebaseFirestore.instance.collection('students');
  //creating future event add fncion
  // addUser() {
  //   return null;
  // }
  Future<void> addUser() {
    print('added user');
    return std
        .add({'name': name, 'email': email, 'password': password})
        .then((value) => print('useradded $name,$password,$email'))
        .catchError((e) => print('failed to delete user:$e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add student details'),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                //name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    autofocus: false,
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
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter email';
                      } else if (!value.contains('@') && !value.contains('.')) {
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
                    controller: passwordController,
                    autofocus: false,
                    obscureText: hide,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: showhide,
                            //here if hide is true return icon 1 else return icon 2
                            //that is hide?Ic? Icons.visibility: Icons.visibility_off
                            icon: Icon(hide
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        hintText: 'password',
                        labelText: 'password',
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
//buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //register button
                    ElevatedButton(
                        onPressed: () {
                          //checking validation here current state not null then validate that is cant be null
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              //changing controllers to text
                              name = nameController.text;
                              email = emailController.text;
                              password = passwordController.text;
                              addUser();
                              clearText();
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Text('register')),
                    ElevatedButton(
                        onPressed: () => {clearText()},
                        child: const Text('reset')),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
