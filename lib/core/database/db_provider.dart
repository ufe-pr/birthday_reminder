import 'dart:async';

import 'package:birthday_reminder/core/models/birthday.dart';
import 'package:sqflite/sqflite.dart';

final String tableBirthday = 'birthdays';
final String columnId = '_id';
final String columnCelebrant = 'celebrant';
final String columnBirthday = 'birthday';

class BirthdayDatabaseProvider {
  static Database _db;
  static BirthdayDatabaseProvider _instance;
  Database get db => _db;

  Future<BirthdayDatabaseProvider> get instance async {
    if (_instance != null) return _instance;
    _instance = BirthdayDatabaseProvider();
    await _instance.open('birthday.db');
    return _instance;
  }

  static StreamController<Iterable<Birthday>> _streamController =
      StreamController<Iterable<Birthday>>.broadcast();

  Stream<Iterable<Birthday>> get birthdayStream =>
      _streamController.stream.asBroadcastStream();

  Future open(String path) async {
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
CREATE TABLE $tableBirthday ( 
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnCelebrant TEXT NOT NULL,
  $columnBirthday TEXT NOT NULL)
''');
    });
    _streamController = StreamController<Iterable<Birthday>>.broadcast();
  }

  Future<Birthday> insert(Birthday birthday) async {
    var id = await db.insert(tableBirthday, birthday.toJson());
    await updateStream();
    return Birthday(id: id).copyWith(
      celebrant: birthday.celebrant,
      birthday: birthday.birthday,
    );
  }

  Future<void> updateStream() async {
    List<Map> maps = await db.query(tableBirthday);
    _streamController.add(List.from(maps.map((e) => Birthday.fromJson(e))));
  }

  Future<Birthday> getBirthday(int id) async {
    List<Map> maps = await db.query(tableBirthday,
        columns: [columnId, columnBirthday, columnCelebrant],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Birthday.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    var numDeleted =
        await db.delete(tableBirthday, where: '$columnId = ?', whereArgs: [id]);
    await updateStream();
    return numDeleted;
  }

  Future<int> update(Birthday birthday) async {
    return await db.update(tableBirthday, birthday.toJson(),
        where: '$columnId = ?', whereArgs: [birthday.id]);
  }

  Future close() async {
    await db.close();
    await _streamController?.close();
  }
}
