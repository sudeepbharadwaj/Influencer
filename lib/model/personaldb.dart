import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



class PerHelper{
  
  late Box box;

  PerHelper(){
    OpenBox();
  }


  OpenBox()async{
    box=Hive.box("user");
  }



  bool emptybox() {
    if (box.values.isEmpty || box.get("number")!=null || box.get('id')!=null){
    
      return true;

    }return false;
      
      
  }

bool checkkey(){
  if(box.containsKey("logstatus")){
    return true;
  }
  return false;
}

  bool checkloginstatus(){
    if(box.get("logstatus")==false){
      return true;
    }
    return false;
  }

 


   putdatawithkey(var key,var data){
     try{
    return box.put(key, data);
     }catch(e){}
  }


   getall(){
    return box.toMap();
  }

   

  void updatedata(var i ,var data){
    try{
    box.put(i,data);
    }catch(e){}
  }

  void  deletedata(var key){
    try{
    box.delete(key);
    }catch(e){}
  }

   getdatawithkey(var key){
    return box.get(key);
    
  }

  Future getdata(var key)async{
    return box.get(box.get(key));
  }


 

   clean (){
    box.clear();

  }
  
  

}