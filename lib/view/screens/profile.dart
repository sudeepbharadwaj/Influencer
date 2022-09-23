import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/personaldb.dart';
import 'package:infleuncer/view/screens/editprofile.dart';
import 'package:infleuncer/view/screens/login.dart';
import 'package:infleuncer/view/screens/nointernet.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _addyourproduct=false;


   StreamSubscription? connectivitySubscription;

 ConnectivityResult? oldres;
 final FirebaseAuth _auth= FirebaseAuth.instance;

  final PerHelper _perHelper=PerHelper();



 Future <void> _logout()async{
   
   
   if(_auth.currentUser != null){
      await _perHelper.putdatawithkey('logstatus',false);

     await _auth.signOut();
     
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));

     
   }

   //print(_perHelper.getall());

 }




 @override 
 void initState(){
   super.initState();
   connectivitySubscription=Connectivity().onConnectivityChanged.listen((ConnectivityResult resnow) {
      if(resnow==ConnectivityResult.none){
      
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Nointernet()));
        
      

      }else if (oldres==ConnectivityResult.none){

         
        

        
      }

     
     
      oldres=resnow;
   });

   
 }


@override
void dispose(){
  super.dispose();
  connectivitySubscription!.cancel();


}



  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar: AppBar(title: Text("Profile",style: GoogleFonts.poppins(fontSize:15.sp,fontWeight:FontWeight.w600,color: Colors.white,letterSpacing: 0.6),),
    actions: <Widget> [
    Padding(
      padding:EdgeInsets.only(right:4.5.w),
      child: GestureDetector(
        onTap: (){

        _logout();
      
        },
        child: const Icon(Icons.logout,size:25,color:Colors.white)))

    ],
    ),
    body:FutureBuilder(future:_perHelper.getdata('id'),
    builder: (BuildContext context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return SafeArea(minimum: EdgeInsets.only(left:4.w,right: 4.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 4.h,),
              Center(child:Padding(
                padding:  EdgeInsets.only(bottom: 0.7.h),
                child: CircleAvatar(radius: 29,
                backgroundColor: const Color.fromARGB(255, 87, 155, 141),
                child: Center(child:Text(snapshot.data['name'].toString().substring(0,1),style: GoogleFonts.poppins(fontSize:23.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
      
            ),
            ),
              ),),
            Text('${snapshot.data['name']}',style: GoogleFonts.poppins(fontSize:16.sp,fontWeight: FontWeight.w600,color:Colors.white,),),
          Text(('${snapshot.data['category']}'!='Select Category')?'${snapshot.data['category']}':"",style: GoogleFonts.poppins(fontSize:11.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
            SizedBox(height: 8.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Detail",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
              Column(children: [
                   const Icon(Icons.thumb_up,color:Color.fromARGB(255, 87, 155, 141),size:25),
                    Text('${snapshot.data['like']}',style: GoogleFonts.poppins(fontSize:11.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
    
              ],)
           
      
            ],),
            SizedBox(height: 2.h,),
    
            Align(alignment: Alignment.centerLeft,
              child: Text(('${snapshot.data['description']}'!='description')?'${snapshot.data['description']}':""
                ,style: GoogleFonts.poppins(fontSize:12.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
              ),

              SizedBox(height: 7.h,),



             
               ('${snapshot.data['category']}'!='category')?
                
                MaterialButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const editprofile()));
                  
                },
                color: Colors.white,
                height: 7.h,minWidth: 60.w,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: 
                Text("Edit Profile",style: GoogleFonts.poppins(fontSize:15.sp,fontWeight: FontWeight.w600,letterSpacing: 0.5,color:Colors.black),)
                ,):Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add,color:Colors.white,size: 20,),
                      TextButton(onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>const editprofile()));
                      }, child:
                      
                      Text("Add your product",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w600,color:Colors.white),))

                  ],),
                )
              
    
              
      
      
            ],
          ),
        ),
      );
      }
      else if(snapshot.hasError){
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error,size:30,color:Colors.white),
              Text("An Error occurred.Try Again later",style:GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w600,color:Colors.white) ,)
        
        
          ],),
        );
      }

      else{
        return const Center(child: CircularProgressIndicator(color:Color.fromARGB(255, 125, 187, 127)));
      }
       } ),
      
    );
  }
  
}


