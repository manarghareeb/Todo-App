import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Shared/Component/model.dart';

class SqliteHelper {

  getDatabase() async {
    Database? database;
    if (database == null) {
      database = await createDatabase();
      return database;
    } else {
      return database;
    }
  }

  createDatabase() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (database, int version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY autoincrement, title TEXT, date TEXT, time TEXT, status TEXT, archived TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
    );
  }

  Future insertToDatabase(ModelDatabase model) async {
    Database db = await getDatabase();
    await db.insert('tasks', model.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future getDataFromDatabase() async {
    Database database = await getDatabase();
    List<Map> maps = await database.query('tasks');
    List<Map> generatedList = [];
    /*List<Map> newTasksList = [];
    List<Map> doneTasksList = [];
    List<Map> archivedTasksList = [];*/
    for (int i = 0; i < maps.length; i++) {
      Map generatedMap = {
        "id": maps[i]["id"],
        "title": maps[i]["title"],
        "date": maps[i]["date"],
        "time": maps[i]["time"],
        "status": maps[i]["status"],
        "archived": maps[i]["archived"]
      };
      generatedList.add(generatedMap);
      /*if (generatedMap["status"] == "new") {
        newTasksList.add(generatedMap);
        return newTasksList;
      } else if (generatedMap["status"] == "done") {
        doneTasksList.add(generatedMap);
        return doneTasksList;
      } else if (generatedMap["status"] == "archived") {
        archivedTasksList.add(generatedMap);
        return archivedTasksList;
      }*/
    }
    return generatedList;
  }

  Future updateData(ModelDatabase model) async {
    Database database = await getDatabase();
    await database.update(
        'tasks',
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future updateStatus(int id, String status) async {
    Database database = await getDatabase();
    await database.update(
      'tasks',
      {'status': status}, // Update only the status field
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future updateArchived(int id, String archived) async {
    Database database = await getDatabase();
    await database.update(
      'tasks',
      {'archived': archived}, // Update only the archived field
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteData(int id) async {
    Database database = await getDatabase();
    await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future deleteAllData() async {
    Database database = await getDatabase();
    await database.delete('tasks');
  }
}
