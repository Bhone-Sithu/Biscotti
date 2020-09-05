import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DbHelp {
  DbHelp._privateConstructor();
  static final DbHelp instance = DbHelp._privateConstructor();
  static final String aDB = 'app2.db';
  static final String aTable = 'App';
  static final String appName = 'appName';
  static final String appReal = 'appReal';
  static final String appIcon = 'appIcon';
  static final String Sdb = 'subject1.db';
  static final String Stable = 'Subjects';
  static final String id = 'id';
  static final String subject = 'subject';
  static final String hour = 'hour';
  static final String minute = 'minute';
  static final String lDB = 'launch1.db';
  static final String localDB = 'local.db';
  static Database database;
  static Database adatabase;
  static Database ldatabase;
  static Database localdatabase;

  Future<Database> get databaseget async {
    if (database != null) return database;

    database = await initdb();
    return database;
  }

  Future create(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $Stable ( id INTEGER PRIMARY KEY,
        subject TEXT,
        hour INTEGER,
        minute INTEGER )

      ''');
  }

  initdb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, Sdb);
    return await openDatabase(path, onCreate: create, version: 2);
  }

  Future<int> inserts(Map<String, dynamic> val) async {
    Database db = await instance.databaseget;
    return await db.insert(Stable, val);
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await instance.databaseget;
    List data = await db.query(Stable);
    return data;
  }

Future<List<Map<String, dynamic>>> select1(int idk) async {
    Database db = await instance.databaseget;
    List data = await db.query(Stable,where: "$id = ?", whereArgs: [idk]);
    return data;
  }
  Future<int> update(Map<String, dynamic> val) async {
    Database db = await instance.databaseget;
    return await db.update(Stable, val, where: "$id = ?", whereArgs: [val[id]]);
  }

  Future<int> delete(int ids) async {
    Database db = await instance.databaseget;
    return await db.delete(Stable, where: "$id = ?", whereArgs: [ids]);
  }

  //App Usage database
  Future<Database> get appDB async {
    if (adatabase != null) return adatabase;

    adatabase = await initaDB();
    return adatabase;
  }
  initaDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, aDB);
    return await openDatabase(path, onCreate: acreate, version: 1);
  }
  Future acreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $aTable ( id INTEGER PRIMARY KEY,
        $appName TEXT,
        $appReal TEXT,
        $appIcon TEXT
         )

      ''');
  }
  Future<int> ainserts(Map<String, dynamic> val) async {
    Database db = await instance.appDB;
    return await db.insert(aTable, val);
  }
  Future<List<Map<String, dynamic>>> aselect() async {
    Database db = await instance.appDB;
    List data = await db.query(aTable);
    return data;
  }
  Future<List<dynamic>> aselect1() async {
    Database db = await instance.appDB;
    List data = await db.query(aTable);
    return data.map((e) => e["appName"]).toList();
  }
  Future<List<Map<String,String>>> aselect2() async {
    Database db = await instance.appDB;
    List<Map<String,String>> data = await db.query(aTable);
    return data;
  }
  Future<int> adelete(String ids) async {
    Database db = await instance.appDB;
    return await db.delete(aTable, where: "$appName = ?", whereArgs: [ids]);
  }
   aselects(String name) async{
     Database db = await instance.appDB;
    return await db.query(aTable, where: "$appReal = ?", whereArgs: [name]);
    
  }

   //Launcher database
  Future<Database> get launchDB async {
    if (ldatabase != null) return ldatabase;

    ldatabase = await initlDB();
    return ldatabase;
  }
  initlDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, lDB);
    return await openDatabase(path, onCreate: lcreate, version: 1);
  }
  Future lcreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE Launch ( id INTEGER PRIMARY KEY,
        $appName TEXT,
        $appReal TEXT,
        Level INTEGER
         )

      ''');
  }
  Future<int> linserts(Map<String, dynamic> val) async {
    Database db = await instance.launchDB;
    return await db.insert('Launch', val);
  }
  Future<List<Map<String, dynamic>>> lselect() async {
    Database db = await instance.launchDB;
    List data = await db.query('Launch');
    return data;
  }
  lselects(String name) async{
     Database db = await instance.launchDB;
    return await db.query("Launch", where: "$appReal = ?", whereArgs: [name]);
    
  }
  Future<int> lupdate(Map<String, dynamic> val) async {
    Database db = await instance.launchDB;
    return await db.update("Launch", val, where: "$appReal = ?", whereArgs: [val[appReal]]);
  }
  //Local Database
Future<Database> get loDB async {
    if (localdatabase != null) return localdatabase;

    localdatabase = await initlocalDB();
    return localdatabase;
  }
  initlocalDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, localDB);
    return await openDatabase(path, onCreate: localcreate, version: 1);
  }
  Future localcreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE Local ( id INTEGER PRIMARY KEY,
        totalhour integer,
        totalmin integer
         )

      ''');
      localinserts(
        {
          "id":0,
          "totalhour":0,
          "totalmin":0,
        }
      );
  }
  localselects() async{
     Database db = await instance.loDB;
    return await db.query("Local");
    
  }
  Future<int> localinserts(Map<String, dynamic> val) async {
    Database db = await instance.loDB;
    return await db.insert('Local', val);
  }
  Future<int> localupdate(Map<String, dynamic> val) async {
    Database db = await instance.loDB;
    return await db.update("Local", val, where: "id = ?", whereArgs: [val[id]]);
  }
}

