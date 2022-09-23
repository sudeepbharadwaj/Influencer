import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infleuncer/view/screens/home.dart';
import 'package:sizer/sizer.dart';


class Filter extends StatefulWidget {
  
  const Filter({ Key? key }) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {


var defaultchoiceindex;
bool wantfilter=true;


final List _iconimg=[
  'assets/icons/diet.png',
  'assets/icons/education.png',
  'assets/icons/fashion.png',
  'assets/icons/gadgets.png',
  'assets/icons/giftbox.png',


];

  final List _filtlst=[
    'Food',"Education","Fashion","Electronics","Gift"
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
    appBar: AppBar(title:Text("Filter",style: GoogleFonts.poppins(fontSize:14.sp,fontWeight:FontWeight.w600,color:Colors.white),)),

    body:SafeArea(minimum: EdgeInsets.only(left:2.w,right:2.w,bottom: 4.h),
      
      child: 
    Column(
      children: [
        Expanded(child:GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4,crossAxisSpacing: 12,mainAxisSpacing: 1,childAspectRatio:  MediaQuery.of(context).size.width /0.6/
              (MediaQuery.of(context).size.height / 0.9),),   
              scrollDirection: Axis.vertical,
              itemCount: _filtlst.length,

        itemBuilder:(ctx,i){
          return Column(
            children: [
              SizedBox.fromSize(size: const Size.fromRadius(25),
              child: ClipRRect(borderRadius: BorderRadius.circular(8),

                
                child: Image.asset(_iconimg[i],filterQuality: FilterQuality.low,fit: BoxFit.fitWidth)
              )
              
              
              
              ,),

              FilterChip(showCheckmark: true, onSelected:(value){
                setState(() {
                  defaultchoiceindex=value?i:defaultchoiceindex;
                });
              },

              selected: defaultchoiceindex==i,
               backgroundColor: Colors.grey[800],
                selectedColor:const Color.fromARGB(255, 93, 168, 153),
                label:Text(_filtlst[i],style: GoogleFonts.poppins(fontSize:10.sp,fontWeight:FontWeight.w600,color: Colors.white,letterSpacing: 1.3),overflow:TextOverflow.ellipsis,) 
              )

            ],
          );
        }
        
        )
        
        ),


          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            
            children: [
             MaterialButton(onPressed: (){

               (defaultchoiceindex!=null)?

               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home(filtlst:_filtlst[defaultchoiceindex],wantfilter:wantfilter))):

                 Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home(filtlst:_filtlst[0],wantfilter:false)));

               
             //Navigator.pop(context,[_filtlst[defaultchoiceindex],wantfilter]);
           // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Nav(defaultchoiceindex:defaultchoiceindex)));
          },
          height: 6.h,
         minWidth: MediaQuery.of(context).size.width/2.4,
          child:Text("Done",style:GoogleFonts.poppins(fontSize:15.sp,fontWeight:FontWeight.w600,color: Colors.black,letterSpacing: 1.5)),
          color:const Color.fromARGB(255, 151, 255, 234),
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          ),
           MaterialButton(onPressed: (){
             if(mounted){
           setState(() {
             defaultchoiceindex=null;
             wantfilter=false;

           });
           //Navigator.pop(context);
           }
          },
          height: 6.h,
          minWidth:MediaQuery.of(context).size.width/2.4,
          child:Text("Reset",style:GoogleFonts.poppins(fontSize:15.sp,fontWeight:FontWeight.w600,color: Colors.black,letterSpacing: 1.5)),
          color: Colors.white,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
          ),

          ],),
         
          
      
    
      ])
    )
      
    );
  }
}