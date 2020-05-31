import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(
      latitude: 35.6804,
      longitude: 139.7690,
    ),
    this.isSelecting = false,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  LatLng _initialLocation;
  bool _isInitial;

  @override
  void initState() {
    super.initState();
    _isInitial = true;
    _initialLocation = LatLng(
      widget.initialLocation.latitude,
      widget.initialLocation.longitude,
    );
  }

  void _pickLocationOnMap(LatLng pickedLocation) {
    setState(() {
      _pickedLocation = pickedLocation;
      _isInitial = false;
    });
  }

  void _savePickedLocation(BuildContext context) {
    Navigator.of(context).pop<LatLng>(_pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () => _savePickedLocation(context),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: _pickLocationOnMap,
        markers: Set.from([
          Marker(
            markerId: MarkerId('mk1'),
            position: _isInitial ? _initialLocation : _pickedLocation,
          )
        ]),
      ),
    );
  }
}
