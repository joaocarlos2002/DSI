import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class JogosFiltroScreen extends StatefulWidget {
  const JogosFiltroScreen({Key? key}) : super(key: key);

  @override
  State<JogosFiltroScreen> createState() => _JogosFiltroScreenState();
}

class _JogosFiltroScreenState extends State<JogosFiltroScreen> {
  List<Map<String, dynamic>> jogos = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchJogos();
  }

  Future<void> fetchJogos() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];
      final response = await http.get(
        Uri.parse('http://localhost:6969/api/games/all'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          jogos = data.cast<Map<String, dynamic>>().reversed.take(10).toList();
          loading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao buscar jogos: ${response.statusCode}';
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Últimos 10 Jogos Registrados')),
      body: ListView.builder(
        itemCount: jogos.length,
        itemBuilder: (context, index) {
          final jogo = jogos[index];
          final home = jogo['homeTeam']?['teamName'] ?? 'Time A';
          final away = jogo['awayTeam']?['teamName'] ?? 'Time B';
          final rodada = jogo['round']?.toString() ?? '';
          final estadio = jogo['stadium'] ?? '';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Rodada $rodada: $home x $away'),
              subtitle: Text('Estádio: $estadio'),
            ),
          );
        },
      ),
    );
  }
}
