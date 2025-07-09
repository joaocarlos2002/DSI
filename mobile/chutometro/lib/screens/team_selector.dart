import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class TeamSelector extends StatefulWidget {
  final String label;
  final void Function(Map<String, dynamic>?)? onChanged;
  const TeamSelector({Key? key, required this.label, this.onChanged}) : super(key: key);

  @override
  State<TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  List<Map<String, dynamic>> teams = [];
  Map<String, dynamic>? selectedTeam;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];
      final response = await http.get(
        Uri.parse('http://localhost:6969/api/teams'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          teams = data.cast<Map<String, dynamic>>();
          loading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao buscar times: ${response.statusCode}';
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
    return DropdownButtonFormField<Map<String, dynamic>>(
      decoration: InputDecoration(labelText: widget.label),
      value: selectedTeam,
      isExpanded: true,
      items: teams.map((team) {
        return DropdownMenuItem(
          value: team,
          child: Text(team['teamName'] ?? 'Time'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedTeam = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
