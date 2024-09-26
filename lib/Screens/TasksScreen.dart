import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Shared/Bloc/todoProvider.dart';
import 'package:todo_app/Shared/Component/sqfliteHelper.dart';

import '../Shared/Component/component.dart';
import '../Shared/Component/model.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  var taskController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return FutureBuilder(
            future: SqliteHelper().getDataFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.separated(
                  itemBuilder: (context, index) => Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      value.deleteData(snapshot.data![index]['id']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.purple,
                            child: Text(
                              snapshot.data![index]['time'],
                              style:
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index]['title'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data![index]['date'],
                                style: const TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Form(
                                    key: formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Update Task',
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          textFormField(
                                            label: 'Task Name',
                                            icon: Icons.title,
                                            controller: taskController,
                                            type: TextInputType.name,
                                            onTap: () {
                                              print('Ok');
                                            },
                                            validate: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Task Name';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          textFormField(
                                            label: 'Task Time',
                                            icon: Icons.access_time,
                                            controller: timeController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              ).then((value) {
                                                timeController.text = value!.format(context);
                                              });
                                            },
                                            validate: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Task Time';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          textFormField(
                                            label: 'Task Date',
                                            icon: Icons.calendar_month,
                                            controller: dateController,
                                            type: TextInputType.datetime,
                                            onTap: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse('2025-01-01'),
                                              ).then((value) {
                                                //dateController.text = DateFormat('yyyy-MM-dd').format(value!);
                                                dateController.text = DateFormat.yMMMd().format(value!);
                                              });
                                            },
                                            validate: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Task Date';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    context.read<DatabaseProvider>().updateData(
                                                      ModelDatabase(
                                                        title: taskController.text,
                                                        time: timeController.text,
                                                        date: dateController.text,
                                                        status: 'new',
                                                      ),
                                                    );
                                                    taskController.clear();
                                                    timeController.clear();
                                                    dateController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Update')
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemCount: snapshot.data!.length,
                );
              }
              else{
                return const Center(child: CircularProgressIndicator(),);
              }
            }
        );
      },
    );
  }
}
