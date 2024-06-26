import 'package:flutter/material.dart';
import 'package:georeal/global_variables.dart';
import 'package:georeal/providers/user_provider';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../view_model/geo_sphere_view_model.dart';

/// Modal that allows user to create a new GeoSphere

class AddGeoSphereModal extends StatefulWidget {
  static const routeName = 'addGeoSphere';
  const AddGeoSphereModal({super.key});

  @override
  State<AddGeoSphereModal> createState() => _AddGeoSphereModalState();
}

class _AddGeoSphereModalState extends State<AddGeoSphereModal> {
  double sliderValue = 0;
  Location location = Location();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    EdgeInsets modalPadding = const EdgeInsets.only(
      bottom: 10,
      left: 20.0,
      right: 20.0,
    );
    final viewModel = Provider.of<GeoSphereViewModel>(context);
    return SafeArea(
      child: Padding(
        padding: modalPadding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(
                    top: 5,
                    bottom:
                        10.0), // Optional spacing from the rest of the modal content
              ),
              const Text(
                "Add a Geo-Sphere!",
                style: GlobalVariables.headerStyle,
              ),
              const SizedBox(height: 20),
              Text(
                  "When you are in the desired location, select a radius and press the button to create your new geo-sphere",
                  style: GlobalVariables.bodyStyleRegular
                      .copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              const Text(
                "Please select the radius of your geo-sphere in meters:",
              ),
              Slider(
                value: sliderValue,
                thumbColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                min: 0,
                max: 50,
                divisions: 20,
                onChanged: (p0) {
                  setState(() {
                    sliderValue = p0;
                  });
                },
                label: "${(sliderValue).toString()} m",
              ),
              const Text(
                "Give your Geo-Sphere a name:",
              ),
              TextField(
                controller: nameController,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final user =
                          Provider.of<UserProvider>(context, listen: false)
                              .user;
                      if (user != null) {
                        await viewModel.setAndCreateGeoSphere(
                            sliderValue, nameController.text, user.id);
                      }

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .primaryColor, // this is the background color
                      foregroundColor: Colors.white, // this is the text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Create Geo-Sphere"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
