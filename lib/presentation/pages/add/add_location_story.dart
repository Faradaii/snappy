import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:snappy/common/localizations/common.dart';

class PlaceWithLatLng {
  geo.Placemark place;
  LatLng latLng;

  PlaceWithLatLng({required this.place, required this.latLng});
}

class AddLocationStoryPage extends StatefulWidget {
  const AddLocationStoryPage({super.key});

  @override
  State<AddLocationStoryPage> createState() => _AddLocationStoryPageState();
}

class _AddLocationStoryPageState extends State<AddLocationStoryPage> {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  LatLng? latLng;
  geo.Placemark? place;
  int tabIndex = 1;

  void defineMarker(LatLng newLatLng) async {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: newLatLng,
    );

    final info = await geo.placemarkFromCoordinates(
        newLatLng.latitude, newLatLng.longitude);
    setState(() {
      markers.clear();
      markers.add(marker);
      latLng = newLatLng;
      place = info[0];
    });
  }

  void onMyLocationPressed() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    defineMarker(latLng);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) {
    defineMarker(latLng);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: DefaultTabController(
          initialIndex: tabIndex,
          length: 2,
          child: Stack(children: [
            _buildMaps(),
            _buildTabBar(),
            _buildChooseLocationAndDetectLocationButton(),
          ]),
        ),
      ),
    );
  }

  Widget _buildMaps() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 18,
        target: latLng ?? LatLng(0, 0),
      ),
      markers: markers,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) {
        final marker = Marker(
          markerId: const MarkerId("source"),
          position: latLng ?? LatLng(0, 0),
        );
        setState(() {
          mapController = controller;
          markers.add(marker);
        });
      },
      onLongPress: (tabIndex == 0)
          ? (LatLng latLng) {
              onLongPressGoogleMap(latLng);
            }
          : null,
    );
  }

  Widget _buildChooseLocationAndDetectLocationButton() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (tabIndex == 1)
            FloatingActionButton(
                onPressed: () {
                  onMyLocationPressed();
                },
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: CircleBorder(),
                child: Icon(Icons.my_location_rounded)),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              children: [
                Text(
                    (latLng == null)
                        ? ((tabIndex == 0)
                            ? AppLocalizations.of(context)!.chooseByLongPress
                            : AppLocalizations.of(context)!.chooseByPressDetect)
                        : "${place?.street}, ${place?.name}, ${place?.administrativeArea} - ${place?.country} ${place?.postalCode}",
                    textAlign: TextAlign.center),
                Row(
                  spacing: 5,
                  children: [
                    ElevatedButton(
                      onPressed: () => {context.pop()},
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (latLng != null && place != null)
                            ? () => {
                                  context.pop(PlaceWithLatLng(
                                      place: place!, latLng: latLng!))
                                }
                            : null,
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                            AppLocalizations.of(context)!.chooseThisLocation),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Positioned(
        top: 16,
        right: 16,
        left: 16,
        child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
                labelColor: Theme.of(context).colorScheme.onPrimary,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                dividerColor: Colors.transparent,
                onTap: (index) => setState(() => tabIndex = index),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: [
                  Tab(
                    child: Text(AppLocalizations.of(context)!.pickLocation),
                  ),
                  Tab(
                    child: Text(AppLocalizations.of(context)!.currentLocation),
                  ),
                ])));
  }
}
