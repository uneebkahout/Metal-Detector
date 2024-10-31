import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:metaldetector/pages/analog.dart';
import 'package:metaldetector/pages/digital.dart';
import 'package:metaldetector/pages/graph.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  

  int bottomIndex = 0;
  List<Widget> pages = const [
      AnalogDetector(),
      DigitalDetector(),
      Graph(),
   
  ];
  final RateMyApp rateMyApp=RateMyApp(
minDays: 0,
minLaunches: 0,
remindLaunches: 2,
remindDays: 0,

);
  

void rate(){
  rateMyApp.init().then((_) 
    {
      rateMyApp.conditions.forEach((condition) { 
        if(condition is DebuggableCondition){
          print(condition.valuesAsString);
        }
      });
if(rateMyApp.shouldOpenDialog   )
    
    { 


    rateMyApp.showStarRateDialog(

            context,
title: 'Rate this App',
message: 
'If you like this app, please take a little bit of your time to review it! it really helps us and it shouldn\'t take you more than one minute.',
actionsBuilder: (context,stars){
  return[
TextButton(onPressed: ()async{
  stars=  stars?? 0;
  print("Thank you for the : ${stars.toString()} stars rating");

if(stars! <4){
print("would you like to leave a feedback ");

}

else{
  Navigator.pop(context, RateMyAppDialogButton.rate);
  await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
  if((await rateMyApp.isNativeReviewDialogSupported)?? false){
    await rateMyApp.launchNativeReviewDialog();
  }
  rateMyApp.launchStore();
}
}
, child: Text('Ok'))
  ];

},


ignoreNativeDialog: true,
dialogStyle: const DialogStyle(
  titleAlign: TextAlign.center,
  messageAlign: TextAlign.center,
  messagePadding: EdgeInsets.only(bottom: 20),

),
starRatingOptions: 
const StarRatingOptions()
,
onDismissed: ()=>
  rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), 
    );
    
    
    }
    } 
    
    );

}
void Privacy() async{

final Uri url=Uri.parse("https://docs.google.com/document/d/1vxb2OPQ71YG-cgKQfnSNNpNSZMvrA7g7lpqRPd36AwU/edit?usp=sharing");
launchUrl(url);
}
@override
Widget build(BuildContext context) {
   Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue 
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), 
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

  
	return Scaffold(

 drawer: Drawer(
          child: Container(
             decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color.fromARGB(255, 189, 195, 199),
              Color.fromARGB(255, 44, 62, 80),
              // Color(0xff5b0060),
              // Color(0xff870160),
              // Color(0xffac255e),
              // Color(0xffca485c),
              // Color(0xffe16b5c),
              // Color(0xfff39060),
              // Color(0xffffb56b),
            ],
           ) // G
           ),
            child: ListView(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage("assets/images/metalic.gif"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Metal Detector",
                          style: TextStyle(
 color: Color.fromARGB(210, 13, 15, 19),
                        fontSize: 25,                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading:Icon(Icons.share,
                  color: Colors.white
                  ),
                  title: const Text(
                    "Share App ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                   Share.share("https://www.youtube.com/");
                  },
                ),
                ListTile(
                  leading:Icon(Icons.rate_review,
                  color: Colors.white,),
                  title: const Text(
                    "Rate Us ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {



                    rate();                    
                    
                  },
                
                ),
               
                ListTile(
                  leading: 
                  Icon(Icons.privacy_tip,
                  color: Colors.white)
                  ,
                  title: const Text(
                    "Privacy Policy  ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
Privacy();
                  },
                ),
                ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text(
            "Metal Detecotor",
          

            style: TextStyle(
                        color: Color.fromARGB(210, 31, 40, 52),
              fontSize: 25.0,
            ),
            
          ),
        backgroundColor: Color.fromARGB(180, 42, 63, 80),
      
        ),

          body: Container(
            
            child: pages[bottomIndex]),
       
 bottomNavigationBar: CurvedNavigationBar(
  color: Color.fromARGB(200, 143, 169, 177),
   backgroundColor: Color.fromARGB(200,42, 62, 80),
          buttonBackgroundColor: Color.fromARGB(200, 143, 169, 177),
  animationDuration: Duration(milliseconds: 300),

   index: bottomIndex,
          onTap: (value) {
            setState(() {
              bottomIndex = value;
            });
          },
  items: [
    CurvedNavigationBarItem(
      child: Image(image:AssetImage("assets/images/speedometer.png"), width: 35,),

      label: 'Analog',
    ),
    CurvedNavigationBarItem(
            child: Image(image:AssetImage("assets/images/gauge.png" ),width: 35,),

      label: 'Digital',
    ),
    CurvedNavigationBarItem(
      child: Image(image:AssetImage("assets/images/growth.png"), width: 35,),
      

      label: 'Graph',
    ),
  ],

),
 
);
}
}
