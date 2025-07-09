import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RoundAndTeamSelector extends StatefulWidget {
  final void Function(int? round, Map<String, dynamic>? homeTeam, Map<String, dynamic>? awayTeam)? onChanged;
  const RoundAndTeamSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  State<RoundAndTeamSelector> createState() => _RoundAndTeamSelectorState();
}

class _RoundAndTeamSelectorState extends State<RoundAndTeamSelector> {
  List<int> rounds = [];
  List<Map<String, dynamic>> teams = [];
  int? selectedRound;
  Map<String, dynamic>? selectedHomeTeam;
  Map<String, dynamic>? selectedAwayTeam;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];
 
      rounds = List.generate(38, (i) => i + 1);

      final response = await http.get(
        Uri.parse('http://localhost:6969/api/team/all-team'),
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
    return Column(
      children: [
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Rodada'),
          value: selectedRound,
          items: rounds.map((r) => DropdownMenuItem(value: r, child: Text('Rodada $r'))).toList(),
          onChanged: (value) {
            setState(() {
              selectedRound = value;
            });
            widget.onChanged?.call(selectedRound, selectedHomeTeam, selectedAwayTeam);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Map<String, dynamic>>(
          decoration: const InputDecoration(labelText: 'Time Mandante'),
          value: selectedHomeTeam,
          items: teams.map((team) => DropdownMenuItem(value: team, child: Text(team['teamName']))).toList(),
          onChanged: (value) {
            setState(() {
              selectedHomeTeam = value;
            });
            widget.onChanged?.call(selectedRound, selectedHomeTeam, selectedAwayTeam);
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<Map<String, dynamic>>(
          decoration: const InputDecoration(labelText: 'Time Visitante'),
          value: selectedAwayTeam,
          items: teams.map((team) => DropdownMenuItem(value: team, child: Text(team['teamName']))).toList(),
          onChanged: (value) {
            setState(() {
              selectedAwayTeam = value;
            });
            widget.onChanged?.call(selectedRound, selectedHomeTeam, selectedAwayTeam);
          },
        ),
      ],
    );
  }
}
