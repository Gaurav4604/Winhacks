import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class Analysis extends StatefulWidget {
  String shop_name;
  Analysis(this.shop_name);
  @override
  _AnalysisState createState() => _AnalysisState();
}


class _AnalysisState extends State<Analysis> {
  //var user;
  String URL1="";
  Color final_color;
  var color1 =  Color(0xFFD50000);
  var color2 =  Color(0xFFFDDED5);
  var color3 =  Color(0xFFF4592F);
  var color4 =  Color(0xFF0050F5);
  var color5 =  Color(0xFFF4592F);
  bool valuefirst = false;
  QueryDocumentSnapshot value1;
  int user_current_strength=0;
  String user_shopname="";
  String user_Instruction1="";
  String user_Instruction2="";
  String user_safest_time="";
  int user_total_strength =0;







  @override
  void initState() {

  getshopdata();

    super.initState();
  }
  getshopdata()async{
    //user = await FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").where("StoreName",isEqualTo:"Nike").get();
    FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.id == "SRMT"){
          FirebaseFirestore.instance
              .collection("Vendors")
              .doc("SRMT")
              .collection("SRMT")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              setState(() {
                if(result["StoreName"]==widget.shop_name){
                  value1 =result;
                  //user = result.data();
                  user_current_strength=result["Current_strength"];
                  print(user_current_strength);
                  user_shopname=result["StoreName"];
                  user_total_strength=result["Total_strength"];
                  user_Instruction1=result["Instruction1"];
                  user_Instruction2=result["Instruction2"];
                  user_safest_time =result["Safest_time"];
                  //print(user);
                }

              });
            });
          });
        }

      });
    });
  }

  uploaddata(String shopname)async{


    FirebaseFirestore.instance.collection("Vendors").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(result.id == "SRMT"){
          FirebaseFirestore.instance
              .collection("Vendors")
              .doc("SRMT")
              .collection("SRMT")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              print(result.id);
              if(result["StoreName"]== shopname){
                FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").doc(result.id).update({
                  'Added':"True"
                });
              }
            });
          });
        }

      });
    });


  }

  @override
  Widget build(BuildContext context) {
    if (user_current_strength <= user_current_strength * 0.25) {
      final_color = Colors.lightGreenAccent;
    }
    else if (user_total_strength * 0.25 <
        user_current_strength &&
        user_current_strength <=
            user_total_strength * 0.75) {
      final_color = Colors.orange;
    }
    else if (user_total_strength * 0.75 <
        user_current_strength &&
        user_current_strength <=
            user_total_strength) {
      final_color = color1;
    }
    if(user_shopname =="KFC")
      URL1 ="images/kfc.png";
    else if(user_shopname=="Nike")
      URL1 ="images/nike1.png";
    else if(user_shopname=="Jockey")
      URL1 ="images/jockey1.png";

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(URL1),
                      radius: 40,
                    ),
                    Text(user_shopname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),),
                    Column(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              color: final_color,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            "${user_current_strength}/${user_total_strength}")
                      ],
                    )


                  ],
                ),
              ),
              Text("Instructions:",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
              SizedBox(height: 15,),
              Container(
                height: MediaQuery.of(context).size.height*0.11,
                width: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                    color: color2,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child:Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("-${user_Instruction1}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      SizedBox(height: 5,),
                      Text("-${user_Instruction2}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text("Our timings:",style: TextStyle(fontWeight: FontWeight.bold,color: color4,fontSize: 25),),
              SizedBox(height: 15,),
              Center(
                  child: Container(
                    height: 280,
                      child: SfCartesianChart(
                          backgroundColor: Colors.white,
                          primaryXAxis: CategoryAxis(),
                          // Enable legend
                          //legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(
                            header: "Crowd",
                              enable: true
                          ),
                          series: <LineSeries<SalesData, String>>[
                            LineSeries<SalesData, String>(
                              color: color5,
                                width:3.5,
                                dataSource:  <SalesData>[
                                  //SalesData('${user["Timings"][0]}', 35),
                                  SalesData("10:30AM", 45),
                                  SalesData("11:30AM", 55),
                                  SalesData("12:30PM", 75),
                                  SalesData("1:30PM", 15),
                                  SalesData("2:30PM", 95),
                                  SalesData("3:30PM", 105),
                                  SalesData("4:30PM", 125),
                                  SalesData("5:30PM", 25),
                                  //SalesData('${user["Timings"][1]}', 130),

                                ],
                                xValueMapper: (SalesData sales, _) => sales.year,
                                yValueMapper: (SalesData sales, _) => sales.sales,

                                // Enable data label
                                //dataLabelSettings: DataLabelSettings(isVisible: true)
                            )
                          ]
                      )
                  )
              ),
              SizedBox(height: 15,),
              Text("Best time to visit:",style: TextStyle(fontWeight: FontWeight.bold,color: color3,fontSize: 25),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("keeping your safety in mind and to ensure their is no compromise in your experience we have estimated that the ideal time for you to shop with us is",style: TextStyle(color: Colors.black,fontSize: 13.55),),
                    Text("${user_safest_time}",style: TextStyle(color: color5,fontSize: 15,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Text("Would you like to visit us today?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 22),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.height*0.35,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Get notfied for the timing that suits you the best and create a custom schedule with us'),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          checkColor: Colors.black,
                          activeColor: color5,
                          value: this.valuefirst,
                          onChanged: (bool value) {
                            setState(() {
                              this.valuefirst = value;
                              if(valuefirst){
                                FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").doc(value1.id).update({
                                  'Added':"True"
                                });
                              }
                                else{
                                FirebaseFirestore.instance.collection("Vendors").doc("SRMT").collection("SRMT").doc(value1.id).update({
                                  'Added':"False"
                                });
                              }

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if(valuefirst == false)
                    Column(
                      children: [
                        Text("Item is removed from schedule",style: TextStyle(color: color5,fontSize: 10),),

                      ],
                    ),
                  if(valuefirst == true)
                    Column(
                      children: [
                        Text("Iteam is added to the schedule",style: TextStyle(color: color5,fontSize: 10),),

                      ],
                    ),
                  SizedBox(height: 10,),

                ],
              ),
              SizedBox(
                height: 35,
                width: 125,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color5,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),// background
                    ),

                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Back",style: TextStyle(color: Colors.white,fontSize: 18),),
                        Icon(Icons.subdirectory_arrow_left,color: Colors.white,)
                      ],
                    )),
              ),



            ],
          ),
        ),
      ),
    );



  }
}
