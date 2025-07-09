import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../services/auth_service.dart';

const Color kCorVerde = Color(0xFF3E5922); // Verde escuro
const Color kCorVerdeClaro = Color(0xFF5B8C2A); // Verde claro
const Color kCorFundo = Colors.white; // Cor de fundo do card
const Color kCorTextoPrincipal = Color(0xFF283040);

const Color kCorBorda = kCorVerde;
const Color kCorIcone = kCorVerdeClaro;
const Color kCorValorDestaque = kCorVerde;
const Color kCorBackground = Color(0xFFD0D3D9); // Cor de fundo da tela


class ConfrontoDetalhadoScreen extends StatefulWidget {
  final String homeTeam;
  final String awayTeam;

  const ConfrontoDetalhadoScreen({super.key, required this.homeTeam, required this.awayTeam});
  @override
  State<ConfrontoDetalhadoScreen> createState() => _ConfrontoDetalhadoScreenState();
}

class _ConfrontoDetalhadoScreenState extends State<ConfrontoDetalhadoScreen> {
  List<Map<String, dynamic>> confrontos = [];
  bool loading = true;
  String? error;

  int totalConfrontos = 0;
  int empates = 0;
  double mediaGols = 0.0;
  double mediaGolsHome = 0.0;
  double mediaGolsAway = 0.0;
  int vitoriasTimeA = 0;
  int vitoriasTimeB = 0;

  int? previsaoResultado; // 0 empate, 1 casa, 2 fora

  @override
  void initState() {
    super.initState();
    fetchConfrontos();
    fetchPrevisao();
  }

  Future<void> fetchPrevisao() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];

      final response = await http.post(
        Uri.parse('http://localhost:6969/api/predict'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'home_team': widget.homeTeam,
          'away_team': widget.awayTeam,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          previsaoResultado = data is int ? data : int.tryParse(data.toString());
        });
      } else {
        setState(() {
          previsaoResultado = null;
        });
      }
    } catch (e) {
      setState(() {
        previsaoResultado = null;
      });
    }
  }

  Future<void> fetchConfrontos() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];

      final response = await http.get(
        Uri.parse('http://localhost:6969/api/games/games/${Uri.encodeComponent(widget.homeTeam)}/${Uri.encodeComponent(widget.awayTeam)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        int gols = 0, golsHome = 0, golsAway = 0, emp = 0;
        int vA = 0, vB = 0;

        for (var c in data) {
          final homeName = c['homeTeam']?['teamName'] ?? '';
          final awayName = c['awayTeam']?['teamName'] ?? '';

          final homeGoals = _toInt(c['homeTeamGoals']);
          final awayGoals = _toInt(c['awayTeamGoals']);

          gols += homeGoals + awayGoals;

          final isHomeTeamA = homeName == widget.homeTeam;

          if (isHomeTeamA) {
            golsHome += homeGoals;
            golsAway += awayGoals;
          } else {
            golsHome += awayGoals;
            golsAway += homeGoals;
          }

          if (homeGoals > awayGoals) {
            if (homeName == widget.homeTeam) vA++;
            else if (homeName == widget.awayTeam) vB++;
          } else if (awayGoals > homeGoals) {
            if (awayName == widget.homeTeam) vA++;
            else if (awayName == widget.awayTeam) vB++;
          } else {
            emp++;
          }
        }

        setState(() {
          confrontos = data.reversed.take(3).map((e) => Map<String, dynamic>.from(e)).toList();
          totalConfrontos = data.length;
          empates = emp;
          mediaGols = data.isNotEmpty ? gols / data.length : 0.0;
          mediaGolsHome = data.isNotEmpty ? golsHome / data.length : 0.0;
          mediaGolsAway = data.isNotEmpty ? golsAway / data.length : 0.0;
          vitoriasTimeA = vA;
          vitoriasTimeB = vB;
          loading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao buscar dados';
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

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatDate(String? rawData) {
    if (rawData == null || rawData.isEmpty) return '';
    try {
      final date = DateTime.parse(rawData);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade900),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Text('$title: $value', style: const TextStyle(fontSize: 14)),
    );
  }

  Widget buildMatchCard(Map<String, dynamic> c) {
    final home = c['homeTeam']?['teamName'] ?? '';
    final away = c['awayTeam']?['teamName'] ?? '';
    final homeGoals = _toInt(c['homeTeamGoals']).toString();
    final awayGoals = _toInt(c['awayTeamGoals']).toString();
    final data = _formatDate(c['data']);

    final int h = int.tryParse(homeGoals) ?? 0;
    final int a = int.tryParse(awayGoals) ?? 0;
    final resultado = (h == a) ? 'Empate' : (h > a ? home : away);

    final homeAvatar = c['homeTeam']?['avatar'] ?? '';
    final awayAvatar = c['awayTeam']?['avatar'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade900, width: 1.2),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(data, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundImage: homeAvatar.isNotEmpty ? NetworkImage(homeAvatar) : null,
                  child: homeAvatar.isEmpty ? const Icon(Icons.sports_soccer) : null,
                ),
                Text('$homeGoals  -  $awayGoals',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                CircleAvatar(
                  backgroundImage: awayAvatar.isNotEmpty ? NetworkImage(awayAvatar) : null,
                  child: awayAvatar.isEmpty ? const Icon(Icons.sports_soccer) : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(resultado, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildEstatisticasSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: kCorFundo,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: kCorBorda,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              Text(
                'Confrontos totais',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kCorTextoPrincipal,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$totalConfrontos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.sports_soccer, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              const Text(
                'Média de gols por confronto',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                mediaGols.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.home, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              Text(
                'Gols do ${widget.homeTeam}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                mediaGolsHome.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.directions_bus, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              Text(
                'Gols do ${widget.awayTeam}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                mediaGolsAway.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.emoji_events, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              Text(
                'Vitórias do ${widget.homeTeam}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '$vitoriasTimeA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              Text(
                'Vitórias do ${widget.awayTeam}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '$vitoriasTimeB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.compare_arrows, color: kCorIcone, size: 18),
              const SizedBox(width: 6),
              const Text(
                'Empates',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '$empates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kCorValorDestaque,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPrevisaoSection() {
    String textoPrevisao = 'Indisponível';
    if (previsaoResultado != null) {
      if (previsaoResultado == 0) {
        textoPrevisao = 'Empate';
      } else if (previsaoResultado == 1) {
        textoPrevisao = widget.homeTeam;
      } else if (previsaoResultado == 2) {
        textoPrevisao = widget.awayTeam;
      }
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: kCorFundo,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: kCorBorda,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.analytics, color: kCorIcone, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Previsão do resultado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: kCorTextoPrincipal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Time vencedor: $textoPrevisao',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: kCorValorDestaque,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confrontos detalhados')),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.homeTeam} x ${widget.awayTeam}'),
        leading: const BackButton(),
        backgroundColor: kCorBackground, 
    
      ),
      backgroundColor: kCorBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildEstatisticasSection(),
              const SizedBox(height: 18),
              buildPrevisaoSection(),
              const SizedBox(height: 18),
              const Text('Últimos confrontos:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                
                height: 300, 
                child: confrontos.isEmpty
                    ? const Center(child: Text('Nenhum confronto encontrado.'))
                    : ListView.builder(
                        
                        itemCount: confrontos.length,
                        itemBuilder: (context, idx) {
                          final c = confrontos[idx];
                          final data = c['data'] ?? '';
                          final home = c['homeTeam']?['teamName'] ?? '';
                          final away = c['awayTeam']?['teamName'] ?? '';
                          final homeAvatar = c['homeTeam']?['avatar'] ?? '';
                          final awayAvatar = c['awayTeam']?['avatar'] ?? '';
                          final homeGoals = c['homeTeamGoals']?.toString() ?? '-';
                          final awayGoals = c['awayTeamGoals']?.toString() ?? '-';
                          final homeAsset = 'assets/times/logos/' + home.toString().toLowerCase().replaceAll(' ', '-') + '.png';
                          final awayAsset = 'assets/times/logos/' + away.toString().toLowerCase().replaceAll(' ', '-') + '.png';
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage(homeAsset),
                                onBackgroundImageError: (_, __) {},
                                child: Image.asset(
                                  homeAsset,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer),
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              title: Text('$home $homeGoals x $awayGoals $away', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Data: $data', style: const TextStyle(fontSize: 12)),
                              trailing: CircleAvatar(
                                backgroundImage: AssetImage(awayAsset),
                                onBackgroundImageError: (_, __) {},
                                child: Image.asset(
                                  awayAsset,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer),
                                  width: 24,
                                  height: 24,
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
      ),
    );
  }
}
