import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MainHelper{
  static final _databasename="data.db";
  static final _databaseversion=1;

  static final table='data_table';

  static const filtable="filter_table";

  static const liketable='like_table';

  static final columnID='id';
  static final columnName='name';
  static final columnNumber="number";
  static final columnBusiname="businessname";
  static final columnCategory="category";
  static final ColumnLike="like";
  static final columnDate="date";
  static final columndescription='description';
  static final columnmail='gmail';
  static final columnchecklike='checklike';
  static final columninstagramlink="instagram_link";
  static final columnwebsitelink='website_link';




  static const columnKey="id";
  static const columnLikearr="likes";


  static  Database? _database;

  MainHelper._privateConstructor();
  static final MainHelper instance=MainHelper._privateConstructor();

  Future <Database> get databse async{
    if(_database!=null) return _database as Database;

    _database=await _initDatabase();
    return _database as Database;


  }


  _initDatabase () async{
    Directory docdir=await getApplicationDocumentsDirectory();
    String path=join(docdir.path,_databasename);
    return await openDatabase(path,version: _databaseversion,onCreate: _oncreate);

  }


  Future _oncreate(Database db,int version)async{

    await db.execute(
      '''
        CREATE TABLE $table (
          $columnID INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL,
          $columnBusiname TEXT,
          $columnCategory TEXT,
          $ColumnLike INTEGER,
          $columnDate TEXT,
          $columndescription TEXT,
          $columnmail TEXT,
          $columninstagramlink TEXT,
          $columnwebsitelink TEXT,
          $columnchecklike INTEGER
          )

      '''

);
    await db.execute(
      '''
        CREATE TABLE $filtable(
          $columnBusiname TEXT
          
        )
      '''
    );

    await db.execute(
      '''
      CREATE TABLE $liketable(
        $columnKey INTEGER PRIMARY KEY,
        $columnLikearr TEXT
        )
      '''
    );

  } 


  //function to insert data
  Future <int> insert(Map<String,dynamic> row)async{
    Database db=await instance.databse;
    return await db.insert(table, row);
  }

var data=['bebox.in'];

  //function to query data for listview
   Future querylst(List <String> data)async{
    Database db=await instance.databse;
    
    var res=await db.query(table,where:"businessname=?",whereArgs:data.toList());


    print(res.toList());
    
    
    
  }

  // function to insert business data in filter data 
  Future <int> filinsert(Map<String,dynamic>row)async{
    Database db=await instance.databse;
    return await db.insert(filtable, row);
  }

  //function to query all rows

  Future <List<Map<String,dynamic>>> queryall()async{
    Database db=await instance.databse;
    return await db.query(table);
  }

//function to query specific data
Future <List<Map<String,dynamic>>> queryspecific(String data)async{
  Database db=await instance.databse;
  var res=await db.query(table,where:"gmail=?",whereArgs: [data]);
  return res;

} 

printdata(String data)async{
  Database db=await instance.databse;
  print(await db.query(table,where:'category=?',whereArgs:[data]));

}
//function to delete specific data 
Future <int> deletedata(String number)async{
  Database db=await instance.databse;
  var res=await db.delete(table,where:"number=?",whereArgs: [number]);
  return res;
}


//function to update specific data
Future <int> update (String gmail,Map<String,dynamic> row)async{
  Database db=await instance.databse;
  var res =await db.update(table,row,where:"gmail=?",whereArgs: [gmail]);
  return res;
}


//function to clear all the data and also reset primary key 
Future clear()async{
  Database db=await instance.databse;
  await db.delete(table);
  await db.delete(filtable);
  //await db.rawDelete('DELETE FROM sqlite_sequence WHERE name=?',[table]);
}


//function to read specific column data 
Future readcolumn()async{
  Database db=await instance.databse;
  var finalres;
  var res= await db.rawQuery('SELECT businessname FROM $filtable');
  print(res);
  for(int i=0;i<res.length;i++){

   finalres= res[i]['businessname'].toString();

  }
  print( finalres);



}

//var fil=true;
//var cat='Food';

Future <List<Map<String,dynamic>>> queryfil(bool fil,var cat) async{
  Database db=await instance.databse;
  if(fil==true){
  return db.query(table,where: 'category=?',whereArgs: [cat]);
}

  return  db.query(table);


}



// insert for likes
Future <int> Likeinsert(Map<String,dynamic> row)async{
  Database db=await instance.databse;
  return db.insert(liketable, row);


}


  //function to query all rows of like table

  Future <List<Map<String,dynamic>>> likequeryall()async{
    Database db=await instance.databse;
    return await db.query(liketable);
  }


//functiom to clear all data of like table

Future likeclear()async{
  Database db=await instance.databse;
  await db.delete(liketable);
  //await db.rawDelete('DELETE FROM sqlite_sequence WHERE name=?',[table]);
}

//function to query specific like data
Future  likequeryspecific(String data)async{
  Database db=await instance.databse;
  var res=await db.query(liketable,where:"likes=?",whereArgs: [data]);
  if(res.isNotEmpty){
    return true;
  }
  else false;

} 


//function to delete specific like data
Future <int> likedeletedata(String number)async{
  Database db=await instance.databse;
  var res=await db.delete(liketable,where:"likes=?",whereArgs: [number]);
  return res;
}
 





  
}