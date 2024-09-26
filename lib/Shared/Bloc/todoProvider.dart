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
}