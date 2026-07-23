import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GuestHomeScreen extends StatelessWidget {

  const GuestHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "SewaGhar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
  actions: [

    IconButton(
      icon: const Icon(Icons.settings_outlined),

      onPressed: () {

        context.push('/settings');

      },

    ),

  ],

),



      body: SingleChildScrollView(

        child: Column(

          children: [


            Container(

              padding: const EdgeInsets.all(20),

              child: Column(

                children: [


                  const Text(

                    "Connecting Skills\nWith People",

                    textAlign: TextAlign.center,

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight: FontWeight.bold,

                    ),

                  ),


                  const SizedBox(height:20),


                  TextField(

                    decoration: InputDecoration(

                      hintText:
                      "Search services...",


                      prefixIcon:
                      const Icon(Icons.search),


                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(15),

                      ),

                    ),

                  ),


                ],

              ),

            ),



            const SizedBox(height:20),



            _sectionTitle("Popular Services"),



            Wrap(

              spacing:10,

              children:[


                _serviceCard(
                    context,
                    "🔧 Plumbing"
                ),

                _serviceCard(
                    context,
                    "⚡ Electrician"
                ),

                _serviceCard(
                    context,
                    "🧹 Cleaning"
                ),

                _serviceCard(
                    context,
                    "❄️ AC Repair"
                ),


              ],

            ),



            const SizedBox(height:30),



            _sectionTitle(
                "Top Professionals"
            ),



            _professionalCard(context),



          ],

        ),

      ),


      bottomNavigationBar:
      BottomNavigationBar(

        items: const [


          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label:"Home",

          ),


          BottomNavigationBarItem(

            icon: Icon(Icons.search),

            label:"Search",

          ),


          BottomNavigationBarItem(

            icon: Icon(Icons.person),

            label:"Profile",

          ),


        ],



        onTap:(index){


          if(index==2){

            _showLogin(context);

          }


        },

      ),


    );

  }



  Widget _sectionTitle(String text){

    return Padding(

      padding:
      const EdgeInsets.all(15),

      child:Align(

        alignment:
        Alignment.centerLeft,

        child:Text(

          text,

          style:
          const TextStyle(

            fontSize:22,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),

    );

  }




  Widget _serviceCard(
      BuildContext context,
      String name){

    return Card(

      child:Padding(

        padding:
        const EdgeInsets.all(15),

        child:Text(name),

      ),

    );

  }



  Widget _professionalCard(
      BuildContext context){

    return Card(

      margin:
      const EdgeInsets.all(15),


      child:ListTile(

        leading:
        const CircleAvatar(

          child:
          Icon(Icons.person),

        ),


        title:
        const Text(
          "Ram Bahadur",
        ),


        subtitle:
        const Text(
          "✔ Verified\n⭐ 4.9\n🏆 Sewa Score 98",
        ),


        trailing:
        ElevatedButton(

          onPressed:(){

            _showLogin(context);

          },

          child:
          const Text(
            "Book",
          ),

        ),


      ),

    );

  }




  void _showLogin(BuildContext context){

    showDialog(

      context:context,

      builder:(context)=>AlertDialog(

        title:
        const Text(
          "Login Required",
        ),


        content:
        const Text(
          "Please login to continue.",
        ),


        actions:[


          TextButton(

            onPressed:(){

              Navigator.pop(context);

              context.push('/login');

            },


            child:
            const Text(
              "Login",
            ),

          ),


        ],


      ),

    );

  }

}