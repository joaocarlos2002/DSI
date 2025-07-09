import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class TeamInfo extends StatefulWidget {
  final String teamName;
  const TeamInfo({Key? key, required this.teamName}) : super(key: key);

  @override
  State<TeamInfo> createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {
  Map<String, dynamic>? teamData;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchTeam();
  }

  Future<void> fetchTeam() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];
      final response = await http.get(
        Uri.parse('http://localhost:6969/api/team/${Uri.encodeComponent(widget.teamName)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          teamData = jsonDecode(response.body);
          loading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao buscar time: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erro: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    if (teamData == null) {
      return const SizedBox();
    }
  
    String assetLogo = 'assets/times/logos/' +
        (teamData!["teamName"]?.toString().toLowerCase().replaceAll(' ', '-') ?? 'default') + '.png';
    return Column(
      children: [
        Image.asset(
          assetLogo,
          width: 56,
          height: 56,
          errorBuilder: (context, error, stackTrace) => const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey,
            child: Icon(Icons.sports_soccer, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamData!["teamName"] ?? widget.teamName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
       
      ],
    );
  }
}
