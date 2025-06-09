import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:strokeprediction/services/overpass_service.dart';


class MapScreen extends StatefulWidget {
  final double userLat;
  final double userLng;

  const MapScreen({
    required this.userLat,
    required this.userLng,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final OverpassService _overpassService = OverpassService();
  List<Marker> _hospitalMarkers = [];

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    final userLocation = LatLng(widget.userLat, widget.userLng);
    final hospitals = await _overpassService.fetchHospitals(userLocation);

    setState(() {
      _hospitalMarkers = hospitals.map((hospital) {
        return Marker(
          point: LatLng(hospital['lat'], hospital['lon']),
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(hospital['name']),
                  content: Text("Latitude: ${hospital['lat']}, Longitude: ${hospital['lon']}"),
                ),
              );
            },
            child: Icon(Icons.local_hospital, size: 40, color: Colors.red),
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = LatLng(widget.userLat, widget.userLng);

    return Scaffold(
      appBar: AppBar(title: Text("Nearby Hospitals")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: userLocation,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: [
            Marker(
              point: userLocation,
              width: 50,
              height: 50,
              child: Icon(Icons.person_pin_circle, size: 45, color: Colors.blue),
            ),
            ..._hospitalMarkers,
          ]),
        ],
      ),
    );
  }
}
