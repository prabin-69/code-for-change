import 'package:flutter/material.dart';


class ProfessionalStatCard extends StatelessWidget {

  final String value;
  final String title;
  final IconData icon;


  const ProfessionalStatCard({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
  });


  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: Card(

        elevation: 3,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),


        child: Padding(

          padding: const EdgeInsets.all(16),

          child: Column(

            children: [

              Icon(
                icon,
                size:30,
              ),


              const SizedBox(height:10),


              Text(
                value,
                style: const TextStyle(
                  fontSize:20,
                  fontWeight:FontWeight.bold,
                ),
              ),


              Text(title),

            ],

          ),

        ),

      ),

    );

  }

}