import 'package:flutter/material.dart';
import 'package:todo_app/Shared/Component/sqfliteHelper.dart';

import '../Component/model.dart';

class DatabaseProvider with ChangeNotifier {
  final SqliteHelper sqliteHelper = SqliteHelper();

  Future insertToDatabase(ModelDatabase model) async {
    await sqliteHelper.insertToDatabase(model);
    notifyListeners();
  }

  Future<List<ModelDatabase>> getDataFromDatabase() async {
    return await sqliteHelper.getDataFromDatabase();
  }

  Future deleteAllData() async {
    await sqliteHelper.deleteAllData();
    notifyListeners();
  }

  Future deleteData(int id) async {
    await sqliteHelper.deleteData(id);
    notifyListeners();
  }

  Future updateData(ModelDatabase model) async {
    await sqliteHelper.updateData(model);
    notifyListeners();
  }

  Future updateStatus(ModelDatabase model) async {
    await sqliteHelper.updateStatus(model);
    notifyListeners();
  }

  int currentIndex = 0;
  changeIndex (int index){
    currentIndex = index;
    notifyListeners();
  }

  bool isCheckIcon = false;
  IconData checkIcon = Icons.check_box_outline_blank;
  Color iconColor = Colors.black;
  int idOfList = 0;
  changeCheckBoxIcon ({
    required bool isShow,
    required IconData icon,
    required Color color,
    required int id
}){
    isCheckIcon = isShow;
   checkIcon = icon;
   iconColor = color;
   notifyListeners();
  }
}