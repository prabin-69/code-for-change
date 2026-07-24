import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/services/location_service.dart';


class LocationPickerScreen extends StatefulWidget {

  final Function(LatLng, String) onLocationSelected;
  final LatLng? initialLocation;


  const LocationPickerScreen({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });


  @override
  State<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();

}



class _LocationPickerScreenState
    extends State<LocationPickerScreen> {


  GoogleMapController? _mapController;


  LatLng? _selectedLocation;


  String? _selectedAddress;


  bool _isLoading = true;


  bool _isSearching = false;


  final TextEditingController _searchController =
      TextEditingController();



  @override
  void initState(){

    super.initState();

    _initializeLocation();

  }





  Future<void> _initializeLocation() async {


    if(widget.initialLocation != null){


      _selectedLocation =
          widget.initialLocation;


      _selectedAddress =
          await LocationService.getAddressFromLatLng(
            widget.initialLocation!.latitude,
            widget.initialLocation!.longitude,
          );


      setState((){

        _isLoading=false;

      });


      return;

    }





    final permission =
        await LocationService.checkAndRequestPermission();



    if(permission){


      final position =
          await LocationService.getCurrentPosition();



      final current =
          LatLng(
            position.latitude,
            position.longitude,
          );



      setState((){


        _selectedLocation=current;


        _isLoading=false;


      });



      _selectedAddress =
          await LocationService.getAddressFromLatLng(
            position.latitude,
            position.longitude,
          );


      setState((){});



    }

    else{


      setState((){

        _isLoading=false;

      });


    }


  }





  Future<void> _searchPlace(String query) async {


    if(query.trim().isEmpty){
      return;
    }


    setState((){

      _isSearching=true;

    });



    try{


      List<Location> locations =
          await locationFromAddress(query);



      if(locations.isNotEmpty){


        final place =
            locations.first;



        final position =
            LatLng(
              place.latitude,
              place.longitude,
            );



        setState((){


          _selectedLocation=position;


          _selectedAddress=query;


          _isSearching=false;


        });



        _mapController?.animateCamera(

          CameraUpdate.newLatLngZoom(
            position,
            15,
          ),

        );


      }



    }catch(e){


      setState((){

        _isSearching=false;

      });



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text(
            "Location not found",
          ),
        ),

      );


    }


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
          "Select Location",
        ),


        bottom:
        PreferredSize(

          preferredSize:
          const Size.fromHeight(60),


          child:
          Padding(

            padding:
            const EdgeInsets.all(10),


            child:
            TextField(

              controller:
              _searchController,


              onSubmitted:
              _searchPlace,


              decoration:
              InputDecoration(

                hintText:
                "Search location",


                prefixIcon:
                const Icon(
                  Icons.search,
                ),


                suffixIcon:
                _isSearching

                    ?
                const Padding(

                  padding:
                  EdgeInsets.all(12),

                  child:
                  CircularProgressIndicator(
                    strokeWidth:2,
                  ),

                )

                    :
                null,


                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(12),

                ),

              ),

            ),

          ),

        ),

      ),





      body:


      _isLoading

          ?

      const Center(
        child:
        CircularProgressIndicator(),
      )


          :


      Stack(

        children:[


          GoogleMap(


            initialCameraPosition:
            CameraPosition(

              target:
              _selectedLocation ??
              const LatLng(
                27.7172,
                85.3240,
              ),

              zoom:14,

            ),



            onMapCreated:
            (controller){

              _mapController =
                  controller;

            },



            onTap:
            (location) async {


              setState((){

                _selectedLocation =
                    location;

              });



              _selectedAddress =
              await LocationService
                  .getAddressFromLatLng(

                location.latitude,
                location.longitude,

              );



              setState((){});

            },



            myLocationEnabled:true,


            markers:

            _selectedLocation != null

                ?

            {

              Marker(

                markerId:
                const MarkerId(
                  "selected",
                ),


                position:
                _selectedLocation!,

              ),

            }

                :

            {},


          ),





          if(_selectedAddress != null)


            Positioned(

              bottom:100,

              left:15,

              right:15,


              child:

              Card(

                child:

                Padding(

                  padding:
                  const EdgeInsets.all(12),


                  child:

                  Text(
                    _selectedAddress!,
                  ),


                ),

              ),

            ),





          Positioned(

            bottom:30,

            left:20,

            right:20,


            child:

            ElevatedButton(

              onPressed:

              _selectedLocation == null

                  ?

              null

                  :

                  (){


                widget.onLocationSelected(

                  _selectedLocation!,

                  _selectedAddress ?? "",

                );


                Navigator.pop(context);


              },


              child:

              const Text(
                "Confirm Location",
              ),

            ),

          )



        ],

      ),



    );


  }






  @override
  void dispose(){


    _mapController?.dispose();


    _searchController.dispose();


    super.dispose();


  }


}