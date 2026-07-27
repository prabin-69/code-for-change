import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ProfessionalHomeScreen extends StatelessWidget {
  const ProfessionalHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF7F8FC),


      appBar: AppBar(

        backgroundColor: Colors.white,

        elevation: 0,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Good Morning 👋",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),


            Text(
              "Ram Bahadur",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),


        actions: [

          IconButton(

            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),

            onPressed: (){},

          ),


          const SizedBox(width:10),

        ],

      ),



      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),


        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,


          children: [


            // PROFILE CARD

            Container(

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

              ),


              child: Row(

                children: [

                  const CircleAvatar(

                    radius:35,

                    backgroundColor: Colors.blue,

                    child: Icon(
                      Icons.person,
                      size:40,
                      color:Colors.white,
                    ),

                  ),


                  const SizedBox(width:15),



                  const Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Ram Bahadur",
                          style: TextStyle(
                            fontSize:20,
                            fontWeight:FontWeight.bold,
                          ),
                        ),


                        SizedBox(height:5),


                        Text(
                          "Electrician",
                          style:TextStyle(
                            color:Colors.grey,
                          ),
                        ),


                        SizedBox(height:5),


                        Row(

                          children:[

                            Icon(
                              Icons.star,
                              size:18,
                              color:Colors.orange,
                            ),


                            Text(
                              " 4.9 (120 Reviews)",
                            ),

                          ],

                        )

                      ],

                    ),

                  )

                ],

              ),

            ),



            const SizedBox(height:20),



            // ONLINE STATUS


            Container(

              padding: const EdgeInsets.all(16),


              decoration:BoxDecoration(

                color:Colors.green.shade50,

                borderRadius:BorderRadius.circular(18),

              ),


              child:Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,


                children:[


                  const Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[

                      Text(
                        "Availability",
                        style:TextStyle(
                          fontWeight:FontWeight.bold,
                        ),
                      ),


                      SizedBox(height:5),


                      Text(
                        "You are available for jobs",
                      ),

                    ],

                  ),



                  Switch(

                    value:true,

                    onChanged:(value){},

                    activeColor:Colors.green,

                  )

                ],

              ),

            ),




            const SizedBox(height:25),




            const Text(

              "Overview",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),




            const SizedBox(height:15),



            Row(

              children:[


                _infoCard(
                  "156",
                  "Jobs",
                  Icons.work,
                ),



                _infoCard(
                  "4.9",
                  "Rating",
                  Icons.star,
                ),



                _infoCard(
                  "Rs 45K",
                  "Income",
                  Icons.currency_rupee,
                ),


              ],

            ),





            const SizedBox(height:25),




            const Text(

              "New Requests",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),




            const SizedBox(height:15),





            Container(

              padding:const EdgeInsets.all(18),


              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:BorderRadius.circular(18),

              ),



              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  const Text(

                    "AC Repair Request",

                    style:TextStyle(

                      fontSize:18,

                      fontWeight:FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:8),



                  const Text(
                    "Customer: Sita Sharma",
                  ),


                  const Text(
                    "Location: Kathmandu",
                  ),



                  const SizedBox(height:15),




                  Row(

                    children:[


                      Expanded(

                        child:ElevatedButton(

                          onPressed:(){

                            context.push(
                              '/professional/requests',
                            );

                          },

                          child:
                          const Text("Accept"),

                        ),

                      ),




                      const SizedBox(width:10),




                      Expanded(

                        child:OutlinedButton(

                          onPressed:(){},

                          child:
                          const Text("Reject"),

                        ),

                      )


                    ],

                  )


                ],

              ),


            ),





            const SizedBox(height:25),




            const Text(

              "Quick Actions",

              style:TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),




            const SizedBox(height:15),




            GridView.count(

              shrinkWrap:true,

              physics:
              const NeverScrollableScrollPhysics(),


              crossAxisCount:2,


              crossAxisSpacing:12,

              mainAxisSpacing:12,



              children:[


                _action(

                  context,
                  "Requests",
                  Icons.notifications,
                  '/professional/requests',
                ),



                _action(

                  context,
                  "My Jobs",
                  Icons.work_history,
                  '/professional/my-jobs',

                ),



                _action(

                  context,
                  "Services",
                  Icons.handyman,
                  '',

                ),



                _action(

                  context,
                  "Profile",
                  Icons.person,
                  '/professional/profile',

                ),


              ],

            )


          ],

        ),

      ),




      bottomNavigationBar: BottomNavigationBar(

        currentIndex:0,


        type:
        BottomNavigationBarType.fixed,


        items:const[


          BottomNavigationBarItem(

            icon:Icon(Icons.home),

            label:"Home",

          ),


          BottomNavigationBarItem(

            icon:Icon(Icons.notifications),

            label:"Requests",

          ),


          BottomNavigationBarItem(

            icon:Icon(Icons.work),

            label:"Jobs",

          ),


          BottomNavigationBarItem(

            icon:Icon(Icons.chat),

            label:"Chat",

          ),


          BottomNavigationBarItem(

            icon:Icon(Icons.person),

            label:"Profile",

          ),


        ],

      ),


    );

  }




  Widget _infoCard(
      String value,
      String title,
      IconData icon,
      ){

    return Expanded(

      child:Container(

        margin:
        const EdgeInsets.only(right:8),


        padding:
        const EdgeInsets.all(15),


        decoration:BoxDecoration(

          color:Colors.white,

          borderRadius:
          BorderRadius.circular(16),

        ),


        child:Column(

          children:[

            Icon(icon),

            const SizedBox(height:8),


            Text(

              value,

              style:const TextStyle(

                fontSize:18,

                fontWeight:FontWeight.bold,

              ),

            ),


            Text(title),

          ],

        ),

      ),

    );

  }





  Widget _action(

      BuildContext context,

      String title,

      IconData icon,

      String route,

      ){

    return InkWell(

      onTap:(){

        if(route.isNotEmpty){

          context.push(route);

        }

      },


      child:Container(

        decoration:BoxDecoration(

          color:Colors.white,

          borderRadius:
          BorderRadius.circular(18),

        ),


        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(

              icon,

              size:35,

            ),


            const SizedBox(height:10),



            Text(

              title,

              style:const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            )


          ],

        ),

      ),

    );

  }

}