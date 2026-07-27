import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ProfessionalProfileSetupScreen extends StatefulWidget {

  const ProfessionalProfileSetupScreen({super.key});


  @override
  State<ProfessionalProfileSetupScreen> createState() =>
      _ProfessionalProfileSetupScreenState();

}



class _ProfessionalProfileSetupScreenState
    extends State<ProfessionalProfileSetupScreen> {


  final nameController = TextEditingController();
  final aboutController = TextEditingController();
  final experienceController = TextEditingController();


  String? selectedProfession;



  final professions = [

    "Plumber",
    "Electrician",
    "Carpenter",
    "Painter",
    "Cleaner",
    "AC Repair"

  ];



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Setup Professional Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

      ),




      body: SingleChildScrollView(


        padding:
        const EdgeInsets.all(20),



        child: Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[



            const Center(

              child:CircleAvatar(

                radius:50,

                child:Icon(

                  Icons.person,

                  size:50,

                ),

              ),

            ),



            const SizedBox(height:25),





            const Text(

              "Personal Information",

              style:TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:15),




            TextField(

              controller:nameController,

              decoration:
              const InputDecoration(

                labelText:"Full Name",

                border:
                OutlineInputBorder(),

                prefixIcon:
                Icon(Icons.person),

              ),

            ),




            const SizedBox(height:15),





            DropdownButtonFormField<String>(


              decoration:
              const InputDecoration(

                labelText:"Profession",

                border:
                OutlineInputBorder(),

                prefixIcon:
                Icon(Icons.work),

              ),



              initialValue:selectedProfession,



              items: professions.map((item){


                return DropdownMenuItem(

                  value:item,

                  child:Text(item),

                );


              }).toList(),




              onChanged:(value){


                setState(() {

                  selectedProfession=value;

                });


              },


            ),





            const SizedBox(height:15),





            TextField(

              controller:
              experienceController,


              keyboardType:
              TextInputType.number,



              decoration:
              const InputDecoration(

                labelText:"Experience Years",

                border:
                OutlineInputBorder(),

                prefixIcon:
                Icon(Icons.timeline),

              ),

            ),






            const SizedBox(height:15),





            TextField(

              controller:
              aboutController,


              maxLines:4,


              decoration:
              const InputDecoration(

                labelText:"About Your Service",

                hintText:
                "Describe your skills and experience",

                border:
                OutlineInputBorder(),

              ),

            ),





            const SizedBox(height:30),





            SizedBox(


              width:
              double.infinity,



              child:
              ElevatedButton(


                style:
                ElevatedButton.styleFrom(


                  padding:
                  const EdgeInsets.all(15),


                ),



                onPressed:(){



                  if(nameController.text.isEmpty ||
                      selectedProfession==null){


                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content:
                        Text(
                          "Please complete profile",
                        ),

                      ),

                    );


                    return;

                  }





                  // Later connect API:
                  // PATCH /professional/profile



                  context.go(
                    '/professional/dashboard',
                  );


                },



                child:
                const Text(

                  "Complete Setup",

                  style:
                  TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),


              ),


            )





          ],


        ),


      ),


    );


  }



}