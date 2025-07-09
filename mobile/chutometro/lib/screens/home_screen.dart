import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'game_selector.dart';
import 'team_info.dart';
import 'confronto_detalhado_screen.dart';
import 'jogos_filtro_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'team_selector.dart';
import 'round_and_team_selector.dart';
import 'profile_screen.dart';

const Color kPrimaryColor = Color(0xFF3E5922);
const Color kCardColor = Colors.white;
const Color kCorVerdeClaro = Color(0xFF5B8C2A); // Verde claro
const Color kPlaceholderColor = Colors.grey;
const Color kCorTextoPrincipal = Color(0xFF283040);
const Color kBackgroundColor = Color(0xFFD0D3D9); // Cor de fundo da tela

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? selectedGame;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0, 
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data ?? {};
          if (userData.isNotEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bem-vindo, ${userData['name']}!',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GameSelector(
                    onGameSelected: (game) {
                      setState(() {
                        selectedGame = game;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 16),
                  MatchCard(selectedGame: selectedGame),
                  if (selectedGame != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.bar_chart, color: Colors.white),
                          label: const Text(
                            'Ver confrontos detalhados',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                            shadowColor: kPrimaryColor.withOpacity(0.3),
                          ),
                          onPressed: () {
                            final home = selectedGame?['homeTeam']?['teamName'] ?? '';
                            final away = selectedGame?['awayTeam']?['teamName'] ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfrontoDetalhadoScreen(
                                  homeTeam: home,
                                  awayTeam: away,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

          
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.filter_alt, color: Colors.white),
                      label: const Text(
                        'Filtrar Jogos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: kPrimaryColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JogosFiltroScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  Card(
                    color: kCardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: kBackgroundColor, width: 1.5),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_box, color: kCorVerdeClaro, size: 28),
                              const SizedBox(width: 10),
                              const Text(
                                'Cadastrar novo jogo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kCorVerdeClaro,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
    
                          _NovoJogoForm(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Usuário não autenticado'));
        },
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final Map<String, dynamic>? selectedGame;
  const MatchCard({super.key, this.selectedGame});

  @override
  Widget build(BuildContext context) {
    final home = selectedGame?['homeTeam']?['teamName'] ?? 'Time A';
    final away = selectedGame?['awayTeam']?['teamName'] ?? 'Time B';
    final rodada = selectedGame?['round']?.toString() ?? '';
    final dataHora = selectedGame?['data'] ?? '';
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kPrimaryColor, width: 2),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(
                    'https://flagcdn.com/w40/br.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'brasileirão - rodada $rodada',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dataHora,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (home != null && home != 'Time A')
                    TeamInfo(teamName: home)
                  else
                    _teamPlaceholder(home),
                  const Text(
                    '-',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (away != null && away != 'Time B')
                    TeamInfo(teamName: away)
                  else
                    _teamPlaceholder(away),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  static Widget _teamPlaceholder(String name) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: kPlaceholderColor,
        ),
        const SizedBox(height: 4),
        Text(name),
      ],
    );
  }
}

class _NovoJogoForm extends StatefulWidget {
  @override
  State<_NovoJogoForm> createState() => _NovoJogoFormState();
}

class _NovoJogoFormState extends State<_NovoJogoForm> {
  int? _selectedRound;
  Map<String, dynamic>? _selectedHomeTeam;
  Map<String, dynamic>? _selectedAwayTeam;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _formacaoMandanteController = TextEditingController();
  final TextEditingController _formacaoVisitanteController = TextEditingController();
  final TextEditingController _arenaController = TextEditingController();

  @override
  void dispose() {
    _formacaoMandanteController.dispose();
    _formacaoVisitanteController.dispose();
    _arenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RoundAndTeamSelector(
            onChanged: (round, home, away) {
              setState(() {
                _selectedRound = round;
                _selectedHomeTeam = home;
                _selectedAwayTeam = away;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Formação Mandante'),
                  value: _formacaoMandanteController.text.isNotEmpty ? _formacaoMandanteController.text : null,
                  items: const [
                    DropdownMenuItem(value: '4-4-2', child: Text('4-4-2')),
                    DropdownMenuItem(value: '4-3-3', child: Text('4-3-3')),
                    DropdownMenuItem(value: '3-5-2', child: Text('3-5-2')),
                    DropdownMenuItem(value: '4-2-3-1', child: Text('4-2-3-1')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _formacaoMandanteController.text = value ?? '';
                    });
                  },
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Formação Visitante'),
                  value: _formacaoVisitanteController.text.isNotEmpty ? _formacaoVisitanteController.text : null,
                  items: const [
                    DropdownMenuItem(value: '4-4-2', child: Text('4-4-2')),
                    DropdownMenuItem(value: '4-3-3', child: Text('4-3-3')),
                    DropdownMenuItem(value: '3-5-2', child: Text('3-5-2')),
                    DropdownMenuItem(value: '4-2-3-1', child: Text('4-2-3-1')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _formacaoVisitanteController.text = value ?? '';
                    });
                  },
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _arenaController,
                  decoration: const InputDecoration(labelText: 'Estádio'),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Cadastrar Jogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate() && _selectedRound != null && _selectedHomeTeam != null && _selectedAwayTeam != null) {
                  final body = {
                    "round": _selectedRound,
                    "homeTeam": {"id": _selectedHomeTeam!["id"]},
                    "awayTeam": {"id": _selectedAwayTeam!["id"]},
                    "homeTeamFormation": _formacaoMandanteController.text,
                    "awayTeamFormation": _formacaoVisitanteController.text,
                    "stadium": _arenaController.text,
                  };
           
                  try {
                    final auth = Provider.of<AuthService>(context, listen: false);
                    final user = await auth.getCurrentUser();
                    final token = user['token'];
                    final response = await http.post(
                      Uri.parse('http://localhost:6969/api/games/create'),
                      headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                      },
                      body: jsonEncode(body),
                    );
                    if (response.statusCode == 200 || response.statusCode == 201) {
              
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JogosFiltroScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar jogo: ${response.statusCode}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao cadastrar jogo: $e')),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
