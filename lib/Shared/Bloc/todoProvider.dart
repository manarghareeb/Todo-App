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

  Future updateStatus(int id, String status) async {
    await sqliteHelper.updateStatus(id, status);
    notifyListeners();
  }

  Future updateArchived(int id, String archived) async {
    await sqliteHelper.updateArchived(id, archived);
    notifyListeners();
  }

  int currentIndex = 0;
  changeIndex (int index){
    currentIndex = index;
    notifyListeners();
  }

  bool isChecked = false;
  bool isArchived = false;
  List<int> doneIndex = [];
  List<int> archivedIndex = [];

  changeCheckBoxIcon ({
    required int index,
}){
    isChecked = !isChecked;
    doneIndex.add(index);
    updateStatus(index, 'done');
    updateArchived(index, 'new');
    notifyListeners();
  }

  changeArchived ({required int index}){
    isArchived = !isArchived;
    archivedIndex.add(index);
    if(isArchived == true) {
      updateArchived(index, 'archived');
      notifyListeners();
    }
    else {
      updateArchived(index, 'new');
      notifyListeners();
    }
  }
}