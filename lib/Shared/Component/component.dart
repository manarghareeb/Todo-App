import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Shared/Component/sqfliteHelper.dart';

import '../Bloc/todoProvider.dart';
import 'model.dart';

Widget textFormField({
  required String label,
  required IconData icon,
  required TextEditingController controller,
  required TextInputType type,
  required var validate,
  var onTap,
  var isClickable = true,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: isClickable,
        controller: controller,
        keyboardType: type,
        validator: validate,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          label: Text(label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );

Widget buildTaskItem({
  //required Map model,
  required BuildContext context,
  var time,
  var title,
  var date,
  var checkBoxFunction,
  //required IconData checkBoxIcon,
  //required Color checkBoxColor,
  required Key formKey,
  required TextEditingController taskController,
  required TextEditingController timeController,
  required TextEditingController dateController,
  var updateFunction,
  var deleteFunction,
}) => Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.purple,
            child: Text(
              time,
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
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: checkBoxFunction,
            icon: Icon(
              Icons.check_box_outline_blank,
              //checkBoxIcon,
              //color: checkBoxColor,
            ),
          ),
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
                                  onPressed: updateFunction,
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
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Are you sure you want to delete this task?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                            TextButton(
                              onPressed: deleteFunction,
                              child: const Text('Delete', style: TextStyle(color: Colors.red),),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //context.read<DatabaseProvider>().deleteData(snapshot.data![index].id!);
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );

Widget taskScreen ({
  required TextEditingController taskController,
  required TextEditingController timeController,
  required TextEditingController dateController,
  required BuildContext context,
}) {
  return FutureBuilder(
      future: SqliteHelper().getDataFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.separated(
            itemBuilder: (context, index) => Padding(
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
                    onPressed: (){
                      //isChanged =! isChanged;
                    },
                    icon: /*isChanged ? Icon(Icons.check_box_outline_blank) : */Icon(Icons.check_box),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Form(
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
                                                id: snapshot.data![index]['id'],
                                                title: taskController.text,
                                                time: timeController.text,
                                                date: dateController.text,
                                                status: 'new',
                                                archived: 'new'
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
                  IconButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Are you sure you want to delete this task?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<DatabaseProvider>().deleteData(snapshot.data![index]['id']);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red),),
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
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
}

