import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';


import 'package:syncfusion_flutter_gauges/gauges.dart';

Color meterCololor = const Color.fromARGB(255, 33, 65, 123);

class AnalogDetector extends StatefulWidget {
  const AnalogDetector({super.key});

  @override
  State<AnalogDetector> createState() => _AnalogDetectorState();
}

double StartValue = 60.0;
late String screenvalue = '0';

class _AnalogDetectorState extends State<AnalogDetector> {
  List<double>? _magnetometerValues;

  final _stream = <StreamSubscription<dynamic>>[];
  late double x_axis, y_axis, z_axis;
  late double xx_ax;
  late double yy_ax;
  late double zz_ax;
  late double? total;
  late double sum;
bool _isPlaying =false;
  String? displaytxt;
    
  double meterValue = 0;

  AudioPlayer _alert=AudioPlayer();

  

  void _playmusic() {
    _alert.play(AssetSource('sound1.mp3'));
    _isPlaying :true;
  }
void pause(){
  _alert.pause();
  _isPlaying:false;


}
@override
  void dispose() {
    _alert.dispose();
    super.dispose();
  }
  @override
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
           ), // G
              child: Column(
                children: [
                  GestureDetector(
child: Icon(_isPlaying ? Icons.volume_down_alt : Icons.volume_up_outlined,color:   Color.fromARGB(255, 44, 62, 80),size: 30,
),
              onTap: () {
                if (_alert.volume==0) {//check if volume is already set to 0 (i.e mute)
                  _alert.setVolume(1.0); 

                } else {

                  _alert.setVolume(0.0);
                  
                }        
                setState(() {
                  _isPlaying=!_isPlaying;
                });
                      },
    ),
                  Center(
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: const BoxDecoration(
                        // color: Color.fromARGB(218, 1, 4, 26),
                      ),
                      padding: EdgeInsets.only(top:22 , left: 10),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                            text: 'Analog',
                            textStyle: TextStyle(
                                fontSize: 20.0,
                          color: Color.fromARGB(210, 31, 40, 52),
                                fontWeight: FontWeight.bold)),
                     
                     
                     
                        axes: <RadialAxis>[
                          RadialAxis(
                             showLabels: false,
            showAxisLine: true, showLastLabel: false,
            showTicks: false, maximumLabels: 3,
            startAngle:180, labelFormat: "",
            
            endAngle: 0,
          
            showFirstLabel: true,
             interval: 5,
                            minimum: 0,
                            maximum: 100,
                            axisLabelStyle: GaugeTextStyle(
                          color: Color.fromARGB(210, 31, 40, 52),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),



axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
        
          ),



                            pointers: <GaugePointer>[

 RangePointer(
  cornerStyle: CornerStyle.bothCurve,
  width: 18,
                            value: 100,
                            gradient: SweepGradient(colors: <Color>[
                             Color.fromARGB(255, 81, 90, 142),
      Color(0xFF66a86d),
      Color(0xFFd5d688),
      Color(0xFFdd9d6d),
      Color(0xFFd05c50),
                            ], stops: <double>[
                              0,
                              0.25,
                              0.5,
                              0.75,
                              1
                            ]
                            ),
                            ),


                              NeedlePointer(
                                  value: meterValue,
                                  needleLength: 0.95,
                                  enableAnimation: true,
                                  animationType: AnimationType.ease,
                                  needleStartWidth: 1.5,
                                  needleEndWidth: 6,
                                  needleColor:
                                      Colors.black,
                                  knobStyle: const KnobStyle(knobRadius: 0.09))
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 80),
                                      child: Text(screenvalue,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                    
                                          )),
                                    ),
                                  ])),
                                  angle: 90,
                                  positionFactor: 0.75),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text('Magnetometer: $magnetometer',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
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
          });
        },
      ),
    );
  }

}
