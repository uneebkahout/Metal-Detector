import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
Color meterCololor = const Color.fromARGB(255, 33, 65, 123);
 late double x_axis=0, y_axis=0, z_axis;

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  
double StartValue = 60.0;

late String screenvalue = '0';

  List<double>? _magnetometerValues;

  final _stream = <StreamSubscription<dynamic>>[];
 


  String? displaytxt;
    
  double meterValue = 0;

  AudioPlayer _alert =AudioPlayer();

  @override
  void dispose() {
    _alert.dispose();
    super.dispose();
  }
 bool _isPlaying =false;


List <metalData>getChartData(){
  return <metalData>[
metalData(meterValue, meterValue)
  ];
}
     

  void _playmusic() {
    final alert = _alert ;
    alert.play(AssetSource('sound1.mp3'));
    _isPlaing :true;
  }
  void pause(){
    _alert.pause();
_isPlaying : false;

  }


List <metalData> _metalData=[];

  @override
  Widget build(BuildContext context) {
    
 
    return Scaffold(
     
    body:Stack(
      children: [
        Container(

decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color.fromARGB(255, 189, 195, 199),
              Color.fromARGB(255, 44, 62, 80),
             
            ],
           ) // G
           ),
           child: Center(
            child: Column(
              
              children: [
                               GestureDetector(
child: Icon(_isPlaying ? Icons.volume_down_alt : Icons.volume_up_outlined,color:   Color.fromARGB(255, 44, 62, 80),size: 30,),


              onTap: () {
                if (_alert.volume==0) {//check if volume is already set to 0 (i.e mute)
                  _alert.setVolume(1.0); 

                } else {
//check if volume is already set to 1 (i.e unmute)

                  _alert.setVolume(0.0);
                  
                }        
                setState(() {
                  _isPlaying=!_isPlaying;
                });
                      },

    ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Text('Graph',style: TextStyle(
                                            color: Color.fromARGB(210, 31, 40, 52),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                
                  
                  ),),
                ),
SizedBox(height: 20,),
Container(
  height: 300,
  child: SfCartesianChart(
  legend:Legend(isVisible: true),
    series:<CartesianSeries> [

      LineSeries<metalData , double>(
        
      dataSource :_metalData,
      xValueMapper :(metalData data, _)=>data.x_Axis,
      yValueMapper: (metalData data, _)=>data.y_Axis,
      
      ),
      
    ],
  ),
)

              ],
            ),
           ),

        )
      ],
    )




      







    );
  }


@override
  void initState() {
    super.initState();
    _stream.add(
      // ignore: deprecated_member_use
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
            
            x_axis = event.x;
            y_axis = event.y;
            z_axis = event.z;


            final xx_ax = pow(x_axis, 2);
            final yy_ax = pow(y_axis, 2);
            final  zz_ax= pow(z_axis, 2);

            final sum = xx_ax + yy_ax + zz_ax;

           final  total = pow(sum, 1 / 2);

            if (total > 45) {
              displaytxt = "METAL DETECTED";

              meterValue = ((100 - 66) * (total - 45) / (100 - 45)) + 66;
              if (meterValue >= 100) {
                meterValue = 100;
                _playmusic();
              }
            } else if (total < 45 && total > 40) {
              displaytxt = "MOVE CLOSER";
              pause();

              meterCololor = Colors.orange;
              meterValue = ((66 - 33) * (total - 40) / (45 - 40)) + 33;
            } else {
              displaytxt = 'NO SUCH METAL';

              meterCololor = Colors.red;
              meterValue = ((33 - 1) * (total - 1) / (40 - 1)) + 1;
            }
            screenvalue = meterValue.toStringAsFixed(1);
            if (meterValue >= 100) {
              screenvalue = '100.0';
      
            }
_metalData.add(metalData(meterValue,total));


     });



        },
      ),
    );
  }

}
class metalData{
  final double x_Axis;
  final num y_Axis;
  metalData(this.x_Axis, this.y_Axis );
}
