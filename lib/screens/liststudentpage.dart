// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudeeg/screens/update_student_page.dart';

import 'package:flutter/material.dart';

class ListStudentPage extends StatefulWidget {
  const ListStudentPage({Key? key}) : super(key: key);

  @override
  //creating state for changes
  State<ListStudentPage> createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {
  //here streaming object created with stream in query of snapshot datatypes named studentsstream whic has the
  //value from firebasefirestorewith instance of coleection form table students with snapshots

  //for fetching or showing table data
  final Stream<QuerySnapshot> studentsStream =
      FirebaseFirestore.instance.collection('students').snapshots();
  //collection(students is the table name of firebase)

//for deleting
//first refrence taken frome fire store
//code meaning collection refrence named std means firebase's firestore's instance colection ('named collec')
  CollectionReference std = FirebaseFirestore.instance.collection('students');
  //making futuredelete event
  Future<void> deleteUser(id) {
    return std
        //docid
        .doc(id)
        //delete doc id
        .delete()
        //then print here value must be assigned in fucntion s of future
        .then(((value) => print('User $id deleted')))
        //if not deleted catch  error and print
        .catchError((e) => print('failed to delete user:$e'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: studentsStream,
        //async since will come form fire store biulding context with async
        //snapshot with type query of snapshot
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //if error
          if (snapshot.hasError) {
            print('Something went wrong');
          }
          //if waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //aray created
          final List storedocs = [];
          //since data cannot be null so snapshit.data! exclamination means cannot be null
          //The property 'docs' can't be unconditionally accessed because the receiver can be 'null'.
          // Try making the access conditional (using '?.') or adding a null check to the target ('!  ').

          snapshot.data!.docs.map((DocumentSnapshot document)
              //mapping data documents snapshot with  document named a
              {
            Map a = document.data() as Map<String, dynamic>;
            //add mapp docs to array storedocs
            storedocs.add(a);
            print(storedocs);
            //assigning id in  array list 'a'
            a['id'] = document.id;
          }).toList();

          //else return program
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(140),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  //first row for table header
                  const TableRow(children: [
                    Center(child: TableCell(child: Text('Name'))),
                    Center(child: TableCell(child: Text('email'))),
                    Center(child: TableCell(child: Text('Actions'))),
                  ]),

                  //data row starts
                  //here for()... dot stands for multe in array it can  also be done with map

                  for (var i = 0; i < storedocs.length; i++) ...[
                    TableRow(children: [
                      TableCell(
                          child: Center(
                        child: Text(
                          storedocs[i]['name'],
                        ),
                      )),
                      TableCell(
                          child: Center(
                        child: Text(storedocs[i]['email']),
                      )),
                      TableCell(
                          child: Center(
                        child: Row(
                          children: [
                            //update button
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateStudentPage(
                                            id: storedocs[i]['id'])));
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            //delete button
                            IconButton(
                              onPressed: () {
                                deleteUser(storedocs[i]['id']);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      )),
                    ]),
                  ],
                ],
              ),
            ),
          );
        });
  }
}
