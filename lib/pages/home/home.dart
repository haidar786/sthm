import 'package:flutter/material.dart';
import 'package:sthm/components/map.dart';
import 'package:provider/provider.dart';
import 'package:sthm/model/locations.dart';
import 'package:sthm/model/update_location.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ChangeNotifierProvider(
        create: (_) => UpdateLocationModel(),
        builder: (context, child) {
          return Stack(
            children: [
              const MapComponent(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<UpdateLocationModel>(context, listen: false)
                          .goToRandomLocation();
                    },
                    child: const Text("random")),
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      Provider.of<UpdateLocationModel>(context, listen: false)
                          .goToCurrentLocation();
                    },
                    child: const Text("current")),
              ),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    onPressed: () async {
                      final previousLocations =
                          Provider.of<UpdateLocationModel>(context, listen: false)
                              .locations;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView(
                                  children: previousLocations
                                      .map((LocationModel e) => Text(e.latLng.toString()))
                                      .toList(),
                                ),
                              ),
                            );
                          });
                    },
                    child: const Text("previous locations")),
              )
            ],
          );
        },
      )),
    );
  }
}
