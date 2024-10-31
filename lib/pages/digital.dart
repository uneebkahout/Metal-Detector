
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

Color meterCololor = const Color.fromARGB(255, 33, 65, 123);
class DigitalDetector extends StatefulWidget {
  const DigitalDetector({super.key});

  @override
  State<DigitalDetector> createState() => _DigitalDetectorState();
}
late String screenvalue = 'll';
bool _isPlaying =false;

class _DigitalDetectorState extends State<DigitalDetector> {
   List<double>? _magnetometerValues;


  final _stream = <StreamSubscription<dynamic>>[];
  late double x_axis=0.0, y_axis=0.0, z_axis=0.0;
  
  late double? total;
  late double sum;

  String? displaytxt;

  double meterValue = 60.0;

  
  AudioPlayer _alert=AudioPlayer();

   void _playmusic() {


    _alert.play(AssetSource('sound1.mp3'));
  }
  void pause(){
_alert.pause();
  }

@override
  void dispose() {
    _alert.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
      body: Stack(
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
            // color: Color.fromARGB(255, 1, 4, 26),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(
                    width: 400,
                    height: 400,
                    decoration: const BoxDecoration(
                    ),
                   child: Column(
                    children: [
                      
                      
                        Text(' $screenvalue %',
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(210, 31, 40, 52),
                      )),
                       
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text('$displaytxt',
                        style: const TextStyle(
                          wordSpacing: 4,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),

                        )),
                  ),

                       Padding(
                         padding: const EdgeInsets.only(left:30.0),
                         child: Row(
                          children: [
                            Text('X',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          SizedBox(width: 20,),
                            Text('$x_axis',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left:30.0),
                         child: Row(
                          children: [
                            Text('Y',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          SizedBox(width: 20,),
                            Text('$y_axis',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          ],
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left:30.0),
                         child: Row(
                          children: [
                            Text('Z',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          SizedBox(width: 20,),
                            Text('$z_axis',
                          style: const TextStyle(
                            wordSpacing: 4,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                        color: Color.fromARGB(210, 31, 40, 52),
                          )),
                          ],
                         ),
                       ),

                    ],
                   ),
                  ),
                 
                ],
              ),
            ),
            

          

        ],
      ),
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

            final total = pow(sum, 1 / 2);

            if (total > 45) {
              displaytxt = "METAL DETECTED";

              meterValue = ((100 - 66) * (total - 45) / (100 - 45)) + 66;
              if (meterValue >= 100) {
                meterValue = 100;
                _playmusic();
              }
            } else if (total < 45 && total > 40) {
              pause();
              displaytxt = "MOVE CLOSER";
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
          });
        },
      ),
    );
  }

}
 