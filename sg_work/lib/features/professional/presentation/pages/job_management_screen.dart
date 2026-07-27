import 'package:flutter/material.dart';



class JobManagementScreen extends StatefulWidget {

  const JobManagementScreen({super.key});


  @override
  State<JobManagementScreen> createState() =>
      _JobManagementScreenState();

}




class _JobManagementScreenState
    extends State<JobManagementScreen> {



  final List<Map<String,dynamic>> jobs = [


    {

      "customer":"Hari Thapa",

      "service":"Plumbing",

      "location":"Ghorahi",

      "payment":"Rs.800",

      "status":"Pending",


    },


    {

      "customer":"Sita Sharma",

      "service":"Electric Repair",

      "location":"Dang",

      "payment":"Rs.1200",

      "status":"On Going",


    },


  ];




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(

          "My Jobs",

          style: TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),




      body: ListView.builder(


        padding:
        const EdgeInsets.all(16),


        itemCount:
        jobs.length,


        itemBuilder:(context,index){


          final job =
          jobs[index];



          return Card(


            elevation:4,


            margin:
            const EdgeInsets.only(
              bottom:15,
            ),



            child:Padding(

              padding:
              const EdgeInsets.all(16),



              child:Column(


                crossAxisAlignment:
                CrossAxisAlignment.start,



                children:[




                  Row(

                    children:[


                      const CircleAvatar(

                        child:
                        Icon(
                          Icons.person,
                        ),

                      ),



                      const SizedBox(
                        width:12,
                      ),



                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children:[


                          Text(

                            job["customer"],

                            style:
                            const TextStyle(

                              fontSize:18,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),



                          Text(
                            job["service"],
                          ),


                        ],

                      ),


                    ],

                  ),





                  const SizedBox(height:15),




                  Text(
                    "📍 ${job["location"]}",
                  ),



                  Text(
                    "💰 ${job["payment"]}",
                  ),





                  const SizedBox(height:10),





                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:12,

                      vertical:6,

                    ),


                    decoration:
                    BoxDecoration(

                      color:
                      _statusColor(
                        job["status"],
                      ),


                      borderRadius:
                      BorderRadius.circular(20),

                    ),



                    child:Text(

                      job["status"],

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                      ),

                    ),

                  ),




                  const SizedBox(height:15),





                  SizedBox(

                    width:
                    double.infinity,


                    child:
                    ElevatedButton(


                      onPressed:(){



                        setState(() {



                          if(job["status"]=="Pending"){


                            job["status"]=
                            "On Going";


                          }

                          else if(
                          job["status"]=="On Going"
                          ){


                            job["status"]=
                            "Completed";


                          }



                        });



                      },



                      child:Text(

                        job["status"]=="Pending"

                            ? "Start Job"

                            :

                        job["status"]=="On Going"

                            ? "Complete Job"

                            :

                        "Completed",


                      ),



                    ),

                  ),




                ],


              ),


            ),



          );


        },


      ),


    );


  }





Color _statusColor(String status){


  if(status=="Pending"){

    return Colors.orange;

  }


  if(status=="On Going"){

    return Colors.blue;

  }


  return Colors.green;


}





}