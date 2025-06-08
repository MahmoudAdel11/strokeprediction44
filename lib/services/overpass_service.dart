import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OverpassService {
  Future<List<Map<String, dynamic>>> fetchHospitals(LatLng userLocation) async {
    final bbox = _buildBBox(userLocation, 0.1); //
    final query = """
      [out:json];
      (
        node["amenity"="hospital"]($bbox);
        way["amenity"="hospital"]($bbox);
        relation["amenity"="hospital"]($bbox);
      );
      out center;
    """;

    final response = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      body: {'data': query},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final elements = data['elements'] as List;

      return elements.map((element) {
        double lat = element['lat'] ?? element['center']?['lat'];
        double lon = element['lon'] ?? element['center']?['lon'];
        String name = element['tags']?['name:en'] ?? " Hospital";

        return {
          'name': name,
          'lat': lat,
          'lon': lon,
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch hospitals');
    }
  }

  String _buildBBox(LatLng center, double delta) {
    return '${center.latitude - delta},${center.longitude - delta},'
        '${center.latitude + delta},${center.longitude + delta}';
  }
}
