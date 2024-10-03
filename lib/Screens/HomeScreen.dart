import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Shared/Bloc/todoProvider.dart';
import 'package:todo_app/Shared/Component/model.dart';
import '../Shared/Component/component.dart';
import 'ArchivedScreen.dart';
import 'DoneScreen.dart';
import 'TasksScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var taskController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  List<Widget> screens = <Widget>[
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  List titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];

  @override
  Widget build(BuildContext context) {
    int index = context.watch<DatabaseProvider>().currentIndex;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        //centerTitle: true,
        title: Text(
          '${titles[index]}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: (){
                context.read<DatabaseProvider>().deleteAllData();
              },
              icon: const Icon(Icons.delete),color: Colors.white,
          ),
        ],
      ),
      body: screens[index],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showValidationDialog(context);
          //insertDatabase();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.read<DatabaseProvider>().currentIndex,
        onTap: (index) {
          context.read<DatabaseProvider>().changeIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  void showValidationDialog(BuildContext context) {
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
                  'Add Task',
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
                          if (formKey.currentState!.validate()) {
                            context.read<DatabaseProvider>().insertToDatabase(
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
                          }
                        },
                        child: const Text('Add')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
