import 'package:flutter/material.dart';
import 'package:strokeprediction/models/hospital.dart';
import 'package:strokeprediction/screens/map_screen.dart';
import 'package:strokeprediction/services/location_service.dart';
import 'package:strokeprediction/screens/NearbyHospitalsScreen.dart';
import 'package:latlong2/latlong.dart';


class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  final LocationService _locationService = LocationService();

  bool _loading = false;

  final List<Hospital> _hospitals = [
    Hospital("City Hospital", 30.0444, 31.2357),
    Hospital("Town Clinic", 30.0522, 31.2348),
    Hospital("Central Medical Center", 30.0500, 31.2400),
    Hospital("Riverdale Hospital", 30.0480, 31.2320),

  ];

  Future<void> _showMapWithHospitals() async {
    setState(() => _loading = true);

    try {
      final userPosition = await _locationService.getCurrentLocation();

      setState(() => _loading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NearbyHospitalsScreen(
            userLocation: LatLng(userPosition.latitude, userPosition.longitude),
          ),
        ),
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stroke Classification App'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_hospital, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    "Nearby Hospitals",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Tap below to view nearby hospitals on the map.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text("View Map", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      backgroundColor: Colors.lightBlueAccent,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: _showMapWithHospitals,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
