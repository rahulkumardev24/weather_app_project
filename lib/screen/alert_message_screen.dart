import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constant/utils.dart';
import 'package:weather_app/data/api/api_helper.dart';
import 'package:weather_app/model/alert_data_model.dart';
import 'package:weather_app/widgets/my_icon_button.dart';

class AlertMessageScreen extends StatefulWidget {
  String location ;
   AlertMessageScreen({super.key , required this.location});

  @override
  State<AlertMessageScreen> createState() => _AlertMessageScreenState();
}

class _AlertMessageScreenState extends State<AlertMessageScreen> {
  Future<AlertMessageData>? _alertMessage;

  @override
  void initState() {
    super.initState();
    _alertMessage = ApiHelper.fetchAlertMessage(location: widget.location);
  }
  
  /// here we create function for format date time 
  String formatDateTime(String date){
    DateTime dateTime = DateTime.parse(date) ;
    return DateFormat("d MMM hh:mm a").format(dateTime) ;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mqData = MediaQuery.of(context);
    final mqHeight = mqData.size.height;
    final mqWidth = mqData.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Here we show location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/images/map.png",
                  height: mqHeight * 0.028,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  widget.location,
                  style: myTextStyle18(),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white60),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: Text(
                    "Weather Alert",
                    style: myTextStyle22(fontFamily: "secondary"),
                  ),
                )),
          ],
        ),
        centerTitle: true,
        toolbarHeight: mqHeight * 0.1,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red.shade500, Colors.red.shade100],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
          child: MyIconButton(
            buttonIcon: Icons.backspace_outlined,
            onTap: () {
              Navigator.pop(context);
            },
            buttonColor: Colors.blue.shade300,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("lib/assets/icons/siren.png"),
          ),
          const SizedBox(
            width: 4,
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: _alertMessage,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Api Error :${snapshot.error}",
                          style: myTextStyle22(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      var alertMessage = snapshot.data!.alerts!.alert ?? [];

                      /// if alert ia empty then this part is show
                      if (alertMessage.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "lib/assets/icons/alert.png",
                                height: mqHeight * 0.1,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "No Weather Alerts",
                                style: myTextStyle22(),
                              )
                            ],
                          ),
                        );
                      }

                      /// if alert is not empty
                      /// ___________________________DATA___________________________///
                      return Container(
                          width: mqWidth,
                          height: mqHeight,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Colors.red.shade500,
                            Colors.red.shade100,
                          ])),
                          child: ListView.builder(
                              itemCount: alertMessage.length,
                              itemBuilder: (context, index) {
                                final alert = alertMessage[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: mqWidth * 0.4,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 3)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "lib/assets/icons/alert.png",
                                                height: mqHeight * 0.04,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                "${index + 1}. Alert",
                                                style: myTextStyle25(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      /// Heading
                                      Text(
                                        "${alert.headline}",
                                        style: const TextStyle(
                                          fontSize: 21,
                                          color: Colors.white,
                                          fontFamily: "primary",
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.black54,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 12,),
                                      /// alert time
                                      Container(
                                        decoration : BoxDecoration(
                                          borderRadius: BorderRadius.circular(10) ,
                                          color: Colors.black12 ,
                                          boxShadow: const [BoxShadow(color: Colors.black , blurRadius: 2)]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4.0 , vertical: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(formatDateTime("${alert.effective}") , style: myTextStyle18(fontColor: Colors.white),),
                                                  Text("Start" , style: myTextStyle22(fontColor: Colors.white60),)
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(formatDateTime("${alert.expires}") , style: myTextStyle18(fontColor: Colors.white),),
                                                  Text("End" , style: myTextStyle22(fontColor: Colors.white60),)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 12,),

                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration:BoxDecoration(
                                                color: Colors.yellow.shade300 ,
                                                borderRadius: BorderRadius.circular(16)
                                              ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4),
                                                  child: Text("${alert.urgency}" , style: myTextStyle22(),),
                                                )),
                                            const SizedBox(width: 12,),
                                            Container(
                                              decoration:BoxDecoration(
                                                borderRadius: BorderRadius.circular(16) ,
                                                  border: Border.all(width: 3 ,  color: Colors.orange.shade300  )
                                              ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4),
                                                  child: Text("${alert.severity}" , style: myTextStyle22(),),
                                                )),
                                            const SizedBox(width: 12,),
                                            Container(
                                              decoration:BoxDecoration(

                                                borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(width: 3 ,  color: Colors.greenAccent.shade200 )
                                              ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4),
                                                  child: Text("${alert.areas}" , style: myTextStyle22(),),
                                                )),
                                            const SizedBox(width: 12,),
                                            Container(
                                              decoration:BoxDecoration(

                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(width: 3 , color: Colors.deepPurpleAccent.shade100 )
                                              ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4),
                                                  child: Text("${alert.category}" , style: myTextStyle22(),),
                                                )),
                                        
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12,),
                                      Container(
                                          decoration:BoxDecoration(
                                              color: Colors.blue.shade200 ,
                                              borderRadius: BorderRadius.circular(16)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 4),
                                            child: Text("${alert.event}" , style: myTextStyle22(),),
                                          )),
                                      const SizedBox(height: 12,),

                                      /// Description
                                      Text(
                                        "${alert.desc}",
                                        style: myTextStyle18(),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),

                                      /// Safety  Instructions
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.greenAccent.shade200,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 4),
                                            child: Text(
                                              "Safety Instruction",
                                              style: myTextStyle18(),
                                            ),
                                          )),
                                      Text(
                                        "${alert.instruction}",
                                        style: myTextStyle18(),
                                      ),

                                      const Divider(
                                        thickness: 2,
                                        color: Colors.blueGrey,
                                      )
                                    ],
                                  ),
                                );
                              }));
                    } else {
                      return Text(
                        "No Data is found",
                        style: myTextStyle22(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

/// This is my Alert Message screen
/// ______________________Alert Message Screen ________________///
///Simples Steps
/// Step 1
/// fetch json data with the help of API =>DONE
/// Step 2
/// Convert Json Data to Dart => DONE
/// Step 3
/// Create a function inside the ApiHelper class for fetch the Alert Message => DONE
/// Step 4
/// Create ui and Show Data => DONE
/// Check
///
///
