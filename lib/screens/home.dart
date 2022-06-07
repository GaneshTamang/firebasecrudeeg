import 'package:flutter/material.dart';

import 'add_student_page.dart';
import 'liststudentpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text('Crud'),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStudentPage()));
                },
                child: const Text(
                  'add',
                  style: TextStyle(color: Colors.amber),
                )),
          ],
        ),
      ),
      //call the list with firebase
      body: const ListStudentPage(),
    );
  }
}
