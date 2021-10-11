import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);



  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  GoogleMapController? _controller;
  double _lat = 20.5937;
  double _lng = 78.9629;
  Location _location = Location();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    _controller!.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController _ctrl) {
    _controller = _ctrl;
    _customInfoWindowController.googleMapController = _ctrl;
    _location.onLocationChanged.listen((event) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(event.latitude!, event.longitude!), zoom: 15),
        ),
      );
      setState(() {
        _lat = event.latitude!;
        _lng = event.longitude!;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(

                initialCameraPosition:
                CameraPosition(target: LatLng(_lat, _lng)),
                mapType: MapType.satellite,
                onMapCreated: _onMapCreated,
                //myLocationEnabled: true,
                markers: {
                  Marker(
                    markerId: MarkerId("current"),
                    position: LatLng(_lat, _lng),
                    onTap: () {
                      _customInfoWindowController.addInfoWindow!(
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 60.0,
                                      height: 20.0,
                                      child: Text(
                                        _lat.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            // Trian
                            // Triangle.isosceles(
                            //   edge: Edge   Edge.BOTTOM,
                            //   child: Container(
                            //     color: Colors.blue,
                            //     width: 20.0,
                            //     height: 10.0,
                            //   ),
                            // ),
                          ],
                        ),
                        LatLng(_lat, _lng),
                      );
                    },
                  ),
                },
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 75,
                width: 150,
                offset: 50,
              ),
            ],
          )),
      // body: GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}
