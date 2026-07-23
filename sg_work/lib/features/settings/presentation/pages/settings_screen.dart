import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';


class SettingsScreen extends StatelessWidget {

  const SettingsScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Settings",
        ),
      ),


      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [


          const Card(

            child: ListTile(

              leading: CircleAvatar(

                child: Icon(
                  Icons.person_outline,
                ),

              ),

              title: Text(
                "Guest User",
              ),

              subtitle: Text(
                "Login to access all features",
              ),

            ),

          ),



          const SizedBox(height: 15),



          Card(

            child: ListTile(

              leading: const Icon(
                Icons.login,
              ),


              title: const Text(
                "Login / Sign Up",
              ),


              subtitle: const Text(
                "Book services and contact professionals",
              ),


              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),


              onTap: () {

                context.push(
                  RouteConstants.phoneLogin,
                );

              },

            ),

          ),




          const Card(

            child: ListTile(

              leading: Icon(
                Icons.workspace_premium,
              ),


              title: Text(
                "Professional Subscription",
              ),


              subtitle: Text(
                "Grow your service business",

              ),

            ),

          ),





          const Card(

            child: ListTile(

              leading: Icon(
                Icons.help_outline,
              ),

              title: Text(
                "Help & Support",
              ),

            ),

          ),





          const Card(

            child: ListTile(

              leading: Icon(
                Icons.info_outline,
              ),

              title: Text(
                "About SewaGhar",
              ),

            ),

          ),


        ],

      ),

    );

  }

}