import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ProfessionalEditProfileScreen extends StatefulWidget {

  const ProfessionalEditProfileScreen({super.key});


  @override
  State<ProfessionalEditProfileScreen> createState() =>
      _ProfessionalEditProfileScreenState();

}



class _ProfessionalEditProfileScreenState
    extends State<ProfessionalEditProfileScreen> {


  final nameController =
      TextEditingController(text: "Ram Bahadur");


  final aboutController =
      TextEditingController(
        text:
        "Experienced professional providing quality home services.",
      );


  final experienceController =
      TextEditingController(
        text:"3",
      );



  String selectedProfession = "Plumber";



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

          "Edit Profile",

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


              initialValue:selectedProfession,


              decoration:
              const InputDecoration(

                labelText:"Profession",

                border:
                OutlineInputBorder(),

                prefixIcon:
                Icon(Icons.work),

              ),



              items:
              professions.map((item){


                return DropdownMenuItem(

                  value:item,

                  child:Text(item),

                );


              }).toList(),




              onChanged:(value){


                setState(() {

                  selectedProfession =
                      value!;

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

                labelText:
                "Experience Years",

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


              maxLines:5,


              decoration:
              const InputDecoration(

                labelText:
                "About Service",

                border:
                OutlineInputBorder(),

              ),

            ),






            const SizedBox(height:30),





            SizedBox(


              width:
              double.infinity,



              child:
              ElevatedButton.icon(



                icon:
                const Icon(Icons.save),



                label:
                const Text(

                  "Save Changes",

                  style:
                  TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),




                onPressed:(){


                  // Later API connection:
                  //
                  // PATCH /api/v1/professional/profile
                  //


                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(

                      content:
                      Text(
                        "Profile Updated Successfully",
                      ),

                    ),

                  );



                  context.pop();


                },



              ),


            )




          ],


        ),


      ),


    );


  }


}