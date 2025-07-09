import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';


const Color kPrimaryColor = Color(0xFF3E5922);
const Color kCardColor = Colors.white;
const Color kCorVerdeClaro = Color(0xFF5B8C2A); 
const Color kPlaceholderColor = Colors.grey;
const Color kCorTextoPrincipal = Color(0xFF283040);
const Color kBackgroundColor = Color(0xFFD0D3D9); 

class JogosFiltroScreen extends StatefulWidget {
  const JogosFiltroScreen({Key? key}) : super(key: key);

  @override
  State<JogosFiltroScreen> createState() => _JogosFiltroScreenState();
}

class _JogosFiltroScreenState extends State<JogosFiltroScreen> {
  List<Map<String, dynamic>> jogos = [];
  List<Map<String, dynamic>> jogosFiltrados = [];
  bool loading = true;
  String? error;
  String filtroTime = '';
  String? filtroRodada;

  @override
  void initState() {
    super.initState();
    fetchJogos();
  }

  void aplicarFiltro() {
    setState(() {
      jogosFiltrados = jogos.where((jogo) {
        final home = (jogo['homeTeam']?['teamName'] ?? '').toString().toLowerCase();
        final away = (jogo['awayTeam']?['teamName'] ?? '').toString().toLowerCase();
        final rodada = jogo['round']?.toString() ?? '';
        final filtroTimeLower = filtroTime.toLowerCase();
        final matchTime = filtroTime.isEmpty || home.contains(filtroTimeLower) || away.contains(filtroTimeLower);
        final matchRodada = filtroRodada == null || filtroRodada!.isEmpty || rodada == filtroRodada;
        return matchTime && matchRodada;
      }).toList();
    });
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
        Uri.parse('http://localhost:6969/api/games/find-by-all-games'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          jogos = data.cast<Map<String, dynamic>>().reversed.take(10000).toList();
          jogosFiltrados = List.from(jogos);
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

  List<String> getRodadasDisponiveis() {
    final rodadas = jogos.map((j) => j['round']?.toString() ?? '').toSet().toList();
    rodadas.removeWhere((r) => r.isEmpty);
    rodadas.sort();
    return rodadas;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }
    if (error != null) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: Center(child: Text(error!, style: TextStyle(color: Colors.red, fontSize: 18))),
      );
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Jogos Registrados', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Card(
              color: kCardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filtrar Jogos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kPrimaryColor)),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Filtrar por time',
                        prefixIcon: Icon(Icons.search, color: kPrimaryColor),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                      onChanged: (value) {
                        filtroTime = value;
                        aplicarFiltro();
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: filtroRodada,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Filtrar por rodada',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todas as rodadas')),
                        ...getRodadasDisponiveis().map((rodada) => DropdownMenuItem(value: rodada, child: Text('Rodada $rodada'))),
                      ],
                      onChanged: (value) {
                        filtroRodada = value;
                        aplicarFiltro();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: jogosFiltrados.length,
                itemBuilder: (context, index) {
                  final jogo = jogosFiltrados[index];
                  final home = jogo['homeTeam']?['teamName'] ?? 'Time A';
                  final away = jogo['awayTeam']?['teamName'] ?? 'Time B';
                  final rodada = jogo['round']?.toString() ?? '';
                  final estadio = jogo['stadium'] ?? '';
                  return Card(
                    color: kCardColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      title: Text(
                        'Rodada $rodada: $home x $away',
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        'Estádio: $estadio',
                        style: const TextStyle(
                          color: kCorTextoPrincipal,
                          fontSize: 15,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: kCorVerdeClaro,
                        child: Text(
                          rodada,
                          style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
