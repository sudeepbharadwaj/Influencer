import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/model/maindb.dart';
import 'package:infleuncer/view/screens/nointernet.dart';
import 'package:sizer/sizer.dart';




class Details extends StatefulWidget {
  int i;
   Details({ Key? key,required this.i}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState(i);
}

class _DetailsState extends State<Details> {
  int i;
  _DetailsState(this.i);


   final _mainhelper=MainHelper.instance;

     StreamSubscription? connectivitySubscription;

 ConnectivityResult? oldres;


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
    appBar: AppBar(
      title: Text("Detail",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight: FontWeight.w500,color:Colors.white,),
      
    ),
    ),

    body: FutureBuilder(future: _mainhelper.queryall(),
    builder: (BuildContext context ,AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return Column(
        children: [
          Expanded(child:SafeArea(minimum: EdgeInsets.only(left:4.w,right: 4.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   SizedBox(height: 4.h,),
                Center(child:Padding(
                  padding:  EdgeInsets.only(bottom: 0.7.h),
                  child: CircleAvatar(radius: 29,
                  backgroundColor: const Color.fromARGB(255, 87, 155, 141),
                  child: Center(child:Text('${snapshot.data[i]['businessname']}'.toString().substring(0,1).toUpperCase(),style: GoogleFonts.poppins(fontSize:23.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
                
              ),
              ),
                ),),
          
                Text('${snapshot.data[i]['businessname']}',style: GoogleFonts.poppins(fontSize:15.sp,fontWeight: FontWeight.w600,color:Colors.white,),),
                Text('${snapshot.data[i]['category']}',style: GoogleFonts.poppins(fontSize:11.sp,fontWeight: FontWeight.w500,color:Colors.white,),),
          
                 SizedBox(height: 8.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Detail",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
                Column(children: [
                     const Icon(Icons.favorite,color:Colors.white,size:30),
                      Text('${snapshot.data[i]['likes']}',style: GoogleFonts.poppins(fontSize:11.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
              
                ],)
             
                
              ],),


                SizedBox(height: 2.h,),
    
            Align(alignment: Alignment.centerLeft,
              child:  Text('${snapshot.data[i]['description']}',style: GoogleFonts.poppins(fontSize:12.sp,fontWeight: FontWeight.w600,color:Colors.white,)),
              ),

              SizedBox(height: 7.h,),
              
                ],
              ) 
              ,
            ),
          )
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            OutlineButton(onPressed: (){}, 
            borderSide: const BorderSide(color: Color.fromARGB(255, 87, 155, 141)),
            child:Text("mail",style: GoogleFonts.poppins(fontSize:12.sp,fontWeight:FontWeight.w600,color:Colors.white),)
            ),
            OutlineButton(onPressed: (){}, 
            borderSide: const BorderSide(color: Color.fromARGB(255, 87, 155, 141)),
            child:Text("Webiste",style: GoogleFonts.poppins(fontSize:12.sp,fontWeight:FontWeight.w600,color:Colors.white),)
            ),
            OutlineButton(onPressed: (){}, 
            borderSide: const BorderSide(color: Color.fromARGB(255, 87, 155, 141)),
            child:Text("Instagram",style: GoogleFonts.poppins(fontSize:12.sp,fontWeight:FontWeight.w600,color:Colors.white),)
            )
          ],)
        ],
      );
     }

     else{
       return const Center(child:CircularProgressIndicator(color: Color.fromARGB(255, 87, 155, 141)));
     }



    })

      
    );
  }
}