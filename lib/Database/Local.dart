//import 'package:sqflite/sqflite.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite/sqlite_api.dart';

class helperDB{
  //singlation
  helperDB._();
  static final helperDB getInstance = helperDB._();
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO= "s_no";
  static final String COLUMN_INFO= "info";

  static final String COLUMN_DISP= "Disp";
  Database? myDB;
  Future<Database> getDB() async{
    if(myDB!=null){
      return myDB!;
    }else{
      myDB= await openDB();
      return myDB!;
      
    }
  }

  Future<Database> openDB() async{
    if(kIsWeb){
      print('not supported ');
    }
    Directory appDir= await getApplicationDocumentsDirectory();
    String dbPath= join(appDir.path,"note.db");
    return await openDatabase(dbPath,onCreate:(db,version){
      db.execute("create table $TABLE_NOTE($COLUMN_NOTE_SNO,integer primary key autoincrement,$COLUMN_INFO text,$COLUMN_DISP text)");
      //
      //
      //
      //create multiple table 
    },version:1);
   
  }
  //add quires
  //insert 
  Future<bool> addNote({required String mtitle,required String mdisc}) async{
    var db= await myDB;
    int rowsEffected= await db!.insert(TABLE_NOTE,{
      COLUMN_INFO :mtitle,
      COLUMN_DISP :mdisc,
    }
    );
    return rowsEffected>0;
  }

  Future<List<Map<String ,dynamic>>> getAllNote()async{
    var db = await getDB();
    List<Map<String,dynamic>> mdata= await db.query(TABLE_NOTE);
    return mdata;
  }


  Future<bool> upadateNote({required String mtitle,required String mdisc ,required var sno })async{
    var db = await getDB();
    int rowEffected= await db.update(TABLE_NOTE,{
      COLUMN_INFO :mtitle,
      COLUMN_DISP :mdisc,

    },where:"$COLUMN_NOTE_SNO = $sno");
    return rowEffected>0;
  }

  Future<bool> deleteNote({required int sno})async{
    var db = await getDB();
    int rowEffected= await db.delete(TABLE_NOTE,where:"$COLUMN_NOTE_SNO = ?" ,whereArgs:['$sno']);
    return rowEffected>0;
  }

}