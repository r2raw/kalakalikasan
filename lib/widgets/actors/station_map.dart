import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalakalikasan/consts.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class StationMap extends StatefulWidget {
  const StationMap({super.key});
  @override
  State<StationMap> createState() {
    return _StationMapState();
  }
}

const LatLng _bagBagPlex = LatLng(14.6965992, 121.0306512);
const LatLng _pBrgyHallPlex = LatLng(14.7009186, 121.0325831);

const LatLng _qcuPlex = LatLng(14.6999933, 121.0317179);

class _StationMapState extends State<StationMap> {
  Location _locationController = new Location();
  LatLng? _currentPos = null;

  Map<PolylineId, Polyline> polylines = {};

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolyLinePoints().then((coordinates) => {
          generatePolyLineFromPoints(coordinates)
            })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: double.infinity,
        height: 300,
        child: _currentPos == null
            ? Center(
                child: Text("Loading..."),
              )
            : GoogleMap(
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _qcuPlex,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("_currLoc"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentPos!),
                  Marker(
                      markerId: MarkerId("_sanBartolomeLoc"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pBrgyHallPlex),
                  Marker(
                      markerId: MarkerId("_googleLoc"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _bagBagPlex),
                  Marker(
                      markerId: MarkerId("_qcuLoc"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _qcuPlex),
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 20);

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;

    PermissionStatus _permissionGranted;
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPos =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentPos!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polyLineCoordinates = [];

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
          origin: PointLatLng(_qcuPlex.latitude, _qcuPlex.longitude),
          destination:
              PointLatLng(_pBrgyHallPlex.latitude, _pBrgyHallPlex.latitude),
          mode: TravelMode.walking),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }));
    } else {
      print(result.errorMessage);
    }

    return polyLineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);

    setState(() {
      polylines[id] = polyline;
    });
  }
}
