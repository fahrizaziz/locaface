import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../ViewModel/core/assets/assets.dart';
import '../ViewModel/core/constants/colors.dart';

class LocationView extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const LocationView({super.key, this.latitude, this.longitude});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    LatLng center = LatLng(widget.latitude ?? 0, widget.longitude ?? 0);
    Marker marker = Marker(
      markerId: const MarkerId("marker_1"),
      position: LatLng(widget.latitude ?? 0, widget.longitude ?? 0),
    );
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child:
                widget.latitude == null
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                    : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 18.0,
                      ),
                      markers: {marker},
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 50.0,
            ),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Assets.icons.back.svg(),
            ),
          ),
        ],
      ),
    );
  }
}
