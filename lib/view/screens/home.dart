import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/maindb.dart';
import 'package:infleuncer/model/personaldb.dart';
import 'package:infleuncer/view/screens/detail.dart';
import 'package:infleuncer/view/screens/filter.dart';
import 'package:infleuncer/view/screens/nointernet.dart';
import 'package:infleuncer/view/screens/profile.dart';
import 'package:sizer/sizer.dart';




enum showwidget{
  SHOW_DATA,
  SHOW_LOADING,

}


class Home extends StatefulWidget {
  var filtlst;
  var wantfilter;
  Home({ Key? key , this.filtlst, this.wantfilter}) : super(key: key);

  @override
  State<Home> createState() => _HomeState(filtlst,wantfilter);
}

class _HomeState extends State<Home> {
  var filtlst;
  var wantfilter;

  _HomeState(this.filtlst,this.wantfilter);


  final CollectionReference _user=FirebaseFirestore.instance.collection("data");
  final PerHelper _perhelper=PerHelper();

  final _mainhelper=MainHelper.instance;

  StreamSubscription? connectivitySubscription;

 ConnectivityResult? oldres;



 showwidget currentstate=showwidget.SHOW_LOADING;

  bool _rebuildui=false;

 @override 
 void initState(){
   super.initState();



   _getdata().whenComplete(()async{

     await _perhelper.putdatawithkey('getdata', 1);
     

    Timer(const Duration(milliseconds: 1000),(){
       if(mounted){
     setState(() {

      currentstate=showwidget.SHOW_DATA;
     });
     }
      
    });
    


   });

   

   connectivitySubscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult resnow) {
      if(resnow==ConnectivityResult.none){
      
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Nointernet()));
        
      

      }else if (oldres==ConnectivityResult.none){

         
        

        
      }

     
     
      oldres=resnow;
   });

   _perhelper.putdatawithkey('logstatus',true);

 

 }




@override
void dispose(){
  super.dispose();
  connectivitySubscription!.cancel();


}

  Future _getdata()async{
    if(_perhelper.getdatawithkey("getdata")==0){
      _user.orderBy("last_updated",descending: true).get().then((value) {
      
        if(value.docs.isNotEmpty){
          print("satrting");

        
        value.docs.forEach((data)async {
       
          await _mainhelper.insert(
            {
              MainHelper.columnName:data.get("name"),
              //MainHelper.columnNumber:data.get('phone_number'),
              MainHelper.columnBusiname:data.get("business_name"),
              MainHelper.columnCategory:data.get("Category"),
              MainHelper.ColumnLike:data.get("like"),
              MainHelper.columndescription:data.get("description"),
              MainHelper.columnmail:data.get("gmail"),
              MainHelper.columninstagramlink:data.get("instagram_link"),
              MainHelper.columnwebsitelink:data.get("website_link"),
              MainHelper.columnDate:data.get("last_updated").toString(),
              }
              );

             
              print("finished");



          
        });
       }
        });
      
    }
    print("comnpleted");

  }



void _checklike(String data)async{
  if(await _mainhelper.likequeryspecific(data)==true){
     await  _user.doc(_perhelper.getdatawithkey("id").toString()).update({
       'like_arr':FieldValue.arrayRemove([data])
}).onError((error, stackTrace) => null);
    await _mainhelper.likedeletedata(data);
   
  }
  else{ await  _user.doc(_perhelper.getdatawithkey("id").toString()).update({
       'like_arr':FieldValue.arrayUnion([data])
}).onError((error, stackTrace) => null);

await _mainhelper.Likeinsert({
  MainHelper.columnLikearr:data
});


}
}

void clear()async{
  await _mainhelper.likeclear();
}



 _colorchange (String data)async{
  if(await  _mainhelper.likequeryspecific(data)==true){
    return Colors.green;
  }
  return Colors.white;
}













Widget _showdata(context){
  return FutureBuilder(future:(filtlst==null)? _mainhelper.queryfil(false,''):_mainhelper.queryfil(wantfilter,filtlst.toString()),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return  Column(
        children: [  
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Padding(
              padding:  EdgeInsets.only(left:4.w,bottom: 3.h,top:2.h),
              child: OutlineButton(onPressed: ()async{

                
                print("pressed");
                var allrows=await _mainhelper.queryall();
                print(allrows);
    
                allrows.forEach((element) {
                  print("run");
                  print(element);
                  
                });
                //print('$result');
                print(_perhelper.getall());
    
    
              },
              borderSide: const BorderSide(color:Color.fromARGB(255, 70, 155, 138),),
              
              child:Text("Order",style: GoogleFonts.poppins(fontSize:12.sp,fontWeight: FontWeight.w600,color:Colors.white,letterSpacing: 0.6),) ,
    
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(right:4.w,bottom: 3.h,top:2.h),
              child: OutlineButton(onPressed: ()async{
                

            await Navigator.push(context, MaterialPageRoute(builder: (context)=>const Filter()));
                //print(_perhelper.getdatawithkey("getdata"));
              //   _perhelper.putdatawithkey('getdata',0);
                //print(_perhelper.getall());
               // _mainhelper.querylst(_mainhelper.readcolumn());
               //_mainhelper.readcolumn();

               //_mainhelper.clear();
              //_getdata();
              //print(_mainhelper.printdata("Food"));
            //print(_mainhelper.readcolumn(0,'businessname'));
              },
              borderSide: const BorderSide(color:Color.fromARGB(255, 70, 155, 138),),
              
              child:Text("Filter",style: GoogleFonts.poppins(fontSize:12.5.sp,fontWeight: FontWeight.w600,color:Colors.white,letterSpacing: 0.6),) ,
    
              ),
            )
    
    
          ],),
      
      Expanded(
      
        child:
         ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder:(ctx,i){
            return 
            ('${snapshot.data[i]['businessname']}'!='Business Name' && '${snapshot.data[i]['category']}'!='Select Category' )?
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder:(context)=>Details(i:i)));
              },
              tileColor: const Color.fromARGB(255, 37, 34, 34),
              leading: CircleAvatar(
                backgroundColor:const Color.fromARGB(255, 87, 155, 141),
                child: Center(child:Text(snapshot.data[i]['businessname'].toString().substring(0,1).toUpperCase(),style: GoogleFonts.poppins(fontSize:19.sp,fontWeight: FontWeight.w600,color: Colors.white),))),
                title:Text('${snapshot.data[i]['businessname']}',style: GoogleFonts.poppins(fontSize:12.sp,fontWeight:FontWeight.w500,color:Colors.white),),
                subtitle: Text('${snapshot.data[i]['category']}',style: GoogleFonts.poppins(fontSize:9.sp,fontWeight:FontWeight.w500,color:Colors.white70),),
                trailing: IconButton(onPressed: (){
                 // _checklike('${snapshot.data[i]['gmail']}');
                  //clear();
             



                }, icon:
                 Icon(Icons.favorite,color:Colors.white,size: 30,)
                ),
        
            ):Container();
          }
          
          ),
      )
        ]);
      }

      else if(snapshot.hasError){
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const Icon(Icons.error,size:25,color:Colors.white),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text("An error has occured.Try Again later",style: GoogleFonts.poppins(fontSize:13.sp,fontWeight:FontWeight.w500,color:Colors.white),),
            )
          ],),
        );
      }

      else if (snapshot.connectionState != ConnectionState.done){
        // ignore: unnecessary_const
        return const Center(child: CircularProgressIndicator(color:Color.fromARGB(255, 87, 155, 141)));
      }

      else{
         return const Center(child: CircularProgressIndicator(color:Color.fromARGB(255, 87, 155, 141)));
      }


    }


    );
      
      
}



Widget _showloading(context){
   return const Center(child: CircularProgressIndicator(color:Color.fromARGB(255, 87, 155, 141)));
  
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar: AppBar(title: Text("HomePage",style: GoogleFonts.poppins(fontSize:12.sp,fontWeight: FontWeight.w500,color:Colors.white),),
    actions: <Widget>[
      Padding(padding: EdgeInsets.only(right: 4.w),
      child: GestureDetector(onTap: (){

        //_mainhelper.querylst(['bebox.in']);
        //print(_mainhelper.querylst(['bebox.in']));

        // _mainhelper.querylst([_mainhelper.readcolumn().toString()]);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>const Profile()));
      },
        child: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 87, 155, 141),
          child: Center(child:Text("S",style: GoogleFonts.poppins(fontSize:18.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
        ),
        ),
      )
      )],
      
    ),
    body:currentstate==showwidget.SHOW_LOADING?_showloading(context):_showdata(context)
    
    
      
    );
  }
}