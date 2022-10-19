
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
  List<String> stringlist = ['0','0','0','0','0','0','0','0','0'];
  List <double> valuelist = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
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
          ListView(
            scrollDirection: Axis.horizontal,
            addAutomaticKeepAlives: false,
            children: [
              Center(
                  child:
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80.0,30,0,0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Container(
                            width: (MediaQuery.of(context).size.width)/1.7,
                            height: (MediaQuery.of(context).size.width)/1.7,
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
                            width: (MediaQuery.of(context).size.width)/1.7,
                            height: (MediaQuery.of(context).size.width)/1.7,
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
                                        Text('${(valuelist[1]*0.75006157584566).toStringAsFixed(2)} mmHg', style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                            angle: 90, positionFactor: 0.8
                                        )
                                      ]
                                  )
                                ]),
                          ),
                        ),
                        Container(
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
                        Text("Altitude",style: TextStyle(fontSize: 24),),
                      ],
                    ),
                  )

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(350,100,6,0),
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width)/1.05,
                  height: (MediaQuery.of(context).size.width)/1.05,
                  child: Container(
                    child: Column(
                      children: [
                        Center(child: Text("X axis acceleration")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.0,
                          maximum: 11.0,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[3],
                                child: Text("${valuelist[3]}")

                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(child: Text("Y axis acceleration")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.0,
                          maximum: 11.0,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[4],
                                child: Text("${valuelist[4]}")

                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(child: Text("Z axis acceleration")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.0,
                          maximum: 11.0,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[5],
                                child: Text("${valuelist[5]}")

                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Center(child: Text("Yaw")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.01,
                          maximum: 2,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[6],
                                child: Text("${valuelist[6]}")

                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(child: Text("Pitch")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.01,
                          maximum: 2,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[7],
                                child: Text("${valuelist[7]}")

                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(child: Text("Roll")),
                        SizedBox(height: 20),
                        SfLinearGauge(
                          minimum: 0.01,
                          maximum: 2,
                          markerPointers: [
                            LinearWidgetPointer(
                                value: valuelist[8],
                                child: Text("${valuelist[8]}")

                            ),
                          ],
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}