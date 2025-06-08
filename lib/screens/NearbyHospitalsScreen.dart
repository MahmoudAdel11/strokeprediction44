import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/overpass_service.dart';
import 'map_screen.dart'; // Update if needed

class NearbyHospitalsScreen extends StatefulWidget {
  final LatLng userLocation;

  const NearbyHospitalsScreen({super.key, required this.userLocation});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  final OverpassService _overpassService = OverpassService();
  List<Map<String, dynamic>> _hospitals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHospitals();
  }

  Future<void> _loadHospitals() async {
    try {
      final hospitals = await _overpassService.fetchHospitals(widget.userLocation);
      final distance = Distance();

      hospitals.sort((a, b) {
        final distA = distance(
            widget.userLocation, LatLng(a['lat'], a['lon']));
        final distB = distance(
            widget.userLocation, LatLng(b['lat'], b['lon']));
        return distA.compareTo(distB);
      });

      setState(() {
        _hospitals = hospitals;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching hospitals: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = Distance();

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Hospitals')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hospitals.isEmpty
          ? const Center(child: Text("No hospitals found."))
          : ListView.builder(
        itemCount: _hospitals.length,
        itemBuilder: (context, index) {
          final hospital = _hospitals[index];
          final dist = distance(
              widget.userLocation,
              LatLng(hospital['lat'], hospital['lon']));
          final distKm = (dist / 1000).toStringAsFixed(2);

          return ListTile(
            leading: const Icon(Icons.local_hospital, color: Colors.red),
            title: Text(hospital['name']),
            subtitle: Text('$distKm km away'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(
                    userLat: widget.userLocation.latitude,
                    userLng: widget.userLocation.longitude,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}









