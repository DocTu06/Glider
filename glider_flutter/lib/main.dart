
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_beep/flutter_beep.dart';



void main() => runApp(MaterialApp(
  home: home(),
));

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  String stringResponse = 'test';
  List<String> stringlist = ['0','0','0','0','0','0','0','0','0','0'];
  List <double> valuelist = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  var color_backround = [255, 177, 93];
  bool zero = true;

  Future fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('http://192.168.4.1/date'));
    if (response.statusCode == 200) {
      setState(() {
        stringResponse = response.body;
        stringlist = stringResponse.split(',');
        valuelist = stringlist.map(double.parse).toList();
       /* if(valuelist[2] < 5.7)
          {
            FlutterBeep.playSysSound(41);
          } *///deactivated for presentation
      });
    }
  }
  Timer? timer;
  Timer? timer1;
  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(milliseconds: 100), (Timer t) => fetchData());
  }
  @override
  void dispose() {
    timer?.cancel();
    timer1?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body:
              Center(
                  child:
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,30,10,0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Container(
                            width: (MediaQuery.of(context).size.width)/1.4,
                            height: (MediaQuery.of(context).size.width)/1.76,
                            child:
                            SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 40,
                                      ranges: <GaugeRange>[
                                        GaugeRange(startValue: 0,
                                            endValue: 10,
                                            color: Colors.teal),
                                        GaugeRange(startValue: 10,
                                            endValue: 30,
                                            color: Colors.green),
                                        GaugeRange(startValue: 30,
                                            endValue: 40,
                                            color: Colors.orange)
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(value: valuelist[0])],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(widget: Container(child:
                                        Text('${valuelist[0]}°C', style: TextStyle(fontSize: 25,
                                            fontWeight: FontWeight.bold))),
                                            angle: 90, positionFactor: 0.8
                                        )
                                      ]
                                  )
                                ]),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                            width: (MediaQuery.of(context).size.width)/1.76,
                            height: (MediaQuery.of(context).size.width)/1.76,
                            child:
                            SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 600,
                                      maximum: 1000,
                                      ranges: <GaugeRange>[
                                        GaugeRange(startValue: 600,
                                            endValue: 700,
                                            color: Colors.teal),
                                        GaugeRange(startValue: 700,
                                            endValue: 850,
                                            color: Colors.green),
                                        GaugeRange(startValue: 850,
                                            endValue: 1000,
                                            color: Colors.red)
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(value: valuelist[1]*0.75006157584566,)],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(widget: Container(child:
                                        Text('${(valuelist[1]*0.75006157584566).toStringAsFixed(2)} mmHg', style: TextStyle(fontSize: 17,
                                            fontWeight: FontWeight.bold))),
                                            angle: 90, positionFactor: 0.8
                                        )
                                      ]
                                  )
                                ]),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                              width: (MediaQuery.of(context).size.width)/1.73,
                              height: (MediaQuery.of(context).size.width)/1.73,
                              child: SfLinearGauge(
                                minimum: 0.3,
                                maximum: 6.2,
                                markerPointers: [
                                  LinearShapePointer(
                                    value: valuelist[2]/1000,
                                    color: Colors.blue,
                                  ),
                                ],
                                orientation: LinearGaugeOrientation.vertical,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 100, 0),
                              width: (MediaQuery.of(context).size.width)/1.73,
                              height: (MediaQuery.of(context).size.width)/1.73,
                              child: SfLinearGauge(
                                minimum: 0.2,
                                maximum: 100,
                                markerPointers: [
                                  LinearShapePointer(
                                    value: valuelist[9],
                                    color: Colors.blue,
                                  ),
                                ],
                                orientation: LinearGaugeOrientation.vertical,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,50,0),
                          child: Text("Altitude(m)                 Sea level altitude(m)",style: TextStyle(fontSize: 15),),
                        ),
                        SizedBox(height: 5),
                        Center(child: Text("Acceleration vector(m/s²)")),
                        SizedBox(height: 5),
                        SfLinearGauge(
                          minimum: 0.0,
                          maximum: 40,
                          markerPointers: [
                            LinearShapePointer(
                              value: sqrt((valuelist[3]*valuelist[3])+(valuelist[4]*valuelist[4]) + (valuelist[5]*valuelist[5])),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )

              ),
                ),
    );
  }
}