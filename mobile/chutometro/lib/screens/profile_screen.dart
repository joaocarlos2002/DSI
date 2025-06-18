import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

const Color kPrimaryColor = Color(0xFF3E5922);
const Color kCardColor = Colors.white;
const Color kCorVerdeClaro = Color(0xFF5B8C2A); // Verde claro
const Color kPlaceholderColor = Colors.grey;
const Color kCorTextoPrincipal = Color(0xFF283040);
const Color kBackgroundColor = Color(0xFFD0D3D9); // Cor de fundo da tela

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LatLng? _selectedLatLng;
  String? _selectedState;
  bool _loadingState = false;

  static const String geoapifyApiKey = 'c7535fa61e214dd897c29b885da0305e';

  Future<void> _getStateFromLatLng(LatLng latLng) async {
    setState(() { _loadingState = true; });
    final url = 'https://api.geoapify.com/v1/geocode/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&apiKey=$geoapifyApiKey&lang=pt&limit=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List?;
      final state = features != null && features.isNotEmpty
          ? features[0]['properties']['state']
          : null;
      setState(() {
        _selectedState = state ?? 'Estado não encontrado';
        _selectedLatLng = latLng;
        _loadingState = false;
      });
    } else {
      setState(() {
        _selectedState = 'Erro ao buscar estado';
        _selectedLatLng = latLng;
        _loadingState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: Provider.of<AuthService>(context, listen: false).getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data ?? {};
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            title: const Text('Perfil'),
            backgroundColor: kPrimaryColor,
            elevation: 2,
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 54,
                      backgroundColor: kCorVerdeClaro,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  user['name'] ?? 'Usuário',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kCorTextoPrincipal),
                ),
                const SizedBox(height: 6),
   
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    color: kCardColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Selecione um estado no mapa',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(-14.235004, -51.92528),
                                  zoom: 4.5,
                                  onTap: (tapPosition, latlng) {
                                    _getStateFromLatLng(latlng);
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: const ['a', 'b', 'c'],
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  if (_selectedLatLng != null)
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          width: 40.0,
                                          height: 40.0,
                                          point: _selectedLatLng!,
                                          builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (_loadingState)
                            const Center(child: CircularProgressIndicator()),
                          if (_selectedState != null && !_loadingState)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                color: kCorVerdeClaro.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.flag, color: kPrimaryColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Estado selecionado: $_selectedState',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
