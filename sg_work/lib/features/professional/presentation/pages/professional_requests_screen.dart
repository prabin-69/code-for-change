import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class ProfessionalRequestsScreen extends StatefulWidget {

  const ProfessionalRequestsScreen({super.key});


  @override
  State<ProfessionalRequestsScreen> createState() =>
      _ProfessionalRequestsScreenState();

}



class _ProfessionalRequestsScreenState
    extends State<ProfessionalRequestsScreen> {


  final List<Map<String,String>> requests = [


    {
      "name":"Hari Thapa",
      "service":"Plumbing",
      "location":"Ghorahi",
      "budget":"Rs.800",
      "time":"Today 10:00 AM",
    },


    {
      "name":"Sita Sharma",
      "service":"Electric Repair",
      "location":"Dang",
      "budget":"Rs.1200",
      "time":"Tomorrow 2:00 PM",
    },


  ];




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(

          "Service Requests",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),

        ),

      ),



      body: ListView.builder(


        padding:
        const EdgeInsets.all(16),


        itemCount:
        requests.length,


        itemBuilder:(context,index){


          final request =
          requests[index];



          return Card(


            elevation:4,


            margin:
            const EdgeInsets.only(bottom:16),



            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(18),

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

                        radius:28,

                        child:
                        Icon(Icons.person),

                      ),



                      const SizedBox(width:12),



                      Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children:[


                          Text(

                            request["name"]!,

                            style:
                            const TextStyle(

                              fontSize:18,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),



                          Text(
                            request["service"]!,
                          ),


                        ],

                      )



                    ],

                  ),





                  const SizedBox(height:15),





                  Text(
                    "📍 ${request["location"]}",
                  ),



                  Text(
                    "💰 ${request["budget"]}",
                  ),



                  Text(
                    "⏰ ${request["time"]}",
                  ),




                  const SizedBox(height:15),





                  Row(

                    children:[



                      Expanded(

                        child:
                        ElevatedButton(

                          onPressed:(){


                            _acceptRequest(
                              context,
                              request,
                            );


                          },


                          child:
                          const Text(
                            "Accept",
                          ),

                        ),

                      ),





                      const SizedBox(width:10),






                      Expanded(

                        child:
                        OutlinedButton(

                          onPressed:(){


                            setState(() {

                              requests.removeAt(index);

                            });


                          },


                          child:
                          const Text(
                            "Reject",
                          ),

                        ),

                      ),




                    ],

                  )



                ],


              ),


            ),



          );


        },


      ),



    );

  }





void _acceptRequest(

BuildContext context,

Map<String,String> request,

){


setState(() {


requests.remove(request);


});



ScaffoldMessenger.of(context)
.showSnackBar(


const SnackBar(

content:
Text(
"Request Accepted"
),

),


);



// Later this will open My Jobs

context.push(

'/professional/my-jobs',

);



}




}