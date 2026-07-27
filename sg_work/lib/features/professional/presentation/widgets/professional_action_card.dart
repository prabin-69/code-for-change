import 'package:flutter/material.dart';


class ProfessionalActionCard extends StatelessWidget {


final String title;
final IconData icon;
final VoidCallback onTap;


const ProfessionalActionCard({

super.key,

required this.title,

required this.icon,

required this.onTap,

});



@override
Widget build(BuildContext context){


return InkWell(

onTap:onTap,


child:Card(

shape:RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(16),

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

style:
const TextStyle(

fontWeight:
FontWeight.bold,

),

),


],


),

),

);


}


}