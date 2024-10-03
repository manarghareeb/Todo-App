import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Shared/Bloc/todoProvider.dart';
import '../Shared/Component/component.dart';
import '../Shared/Component/model.dart';
import '../Shared/Component/sqfliteHelper.dart';
import '../Shared/Constants/constants.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return FutureBuilder(
            future: SqliteHelper().getDataFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.separated(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: buildTaskItem(
                      //model: tasks[index],
                      context: context,
                      formKey: formKey,
                      time: snapshot.data![index]['time'],
                      title: snapshot.data![index]['title'],
                      date: snapshot.data![index]['date'],
                      checkBoxFunction: (){
                        if(isChangeButton == false){
                          context.read<DatabaseProvider>().changeCheckBoxIcon(
                              isShow: false,
                              icon: Icons.check_box_outline_blank,
                              color: Colors.black,
                              id: snapshot.data![index]['id']
                          );
                          isChangeButton = true;
                        }
                        else {
                          context.read<DatabaseProvider>().changeCheckBoxIcon(
                              isShow: true,
                              icon: Icons.check_box,
                              color: Colors.green,
                              id: snapshot.data![index]['id']
                          );
                          isChangeButton = false;
                        }
                      },
                      checkBoxIcon: context.read<DatabaseProvider>().checkIcon,
                      checkBoxColor: context.read<DatabaseProvider>().iconColor,
                      timeController: timeController,
                      taskController: taskController,
                      dateController: dateController,
                      updateFunction: () async {
                        context.read<DatabaseProvider>().updateData(
                          ModelDatabase(
                            id: snapshot.data![index]['id'],
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
                      deleteFunction: () {
                        value.deleteData(snapshot.data![index]['id']);
                        Navigator.pop(context);
                      },
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
