Row(

children =[


Expanded(

child: ElevatedButton(

onPressed:(){

context.push(

'/chat',

extra: name,

);

},


child:
const Text(
"Chat",
),


),

),



const SizedBox(width:10),



Expanded(

child: ElevatedButton(

onPressed:(){

context.push(

'/booking',

extra:name,

);

},


child:
const Text(
"Book Now",
),

),

),


],


)