import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

const Color kPrimaryColor = Color(0xFF3E5922);
const Color kCardColor = Colors.white;
const Color kCorVerdeClaro = Color(0xFF5B8C2A); // Verde claro
const Color kPlaceholderColor = Colors.grey;
const Color kCorTextoPrincipal = Color(0xFF283040);
const Color kBackgroundColor = Color(0xFFD0D3D9); // Cor de fundo da tela

class GameSelector extends StatefulWidget {
  final void Function(Map<String, dynamic>?)? onGameSelected;
  const GameSelector({Key? key, this.onGameSelected}) : super(key: key);

  @override
  State<GameSelector> createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector> {
  List<Map<String, dynamic>> games = [];
  Map<String, dynamic>? selectedGame;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = await auth.getCurrentUser();
      final token = user['token'];
      final response = await http.get(
        Uri.parse('http://localhost:6969/api/games/pull-all-games-of-the-round/1'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          games = data.cast<Map<String, dynamic>>();
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
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kPrimaryColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          hint: const Text(
            'Selecione um jogo',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          value: selectedGame,
          isExpanded: true,
          icon: Icon(Icons.sports_soccer, color: kPrimaryColor),
          items: games.map((game) {
            final home = game['homeTeam']?['teamName'] ?? 'Time A';
            final away = game['awayTeam']?['teamName'] ?? 'Time B';
            final rodada = game['round']?.toString() ?? '';
            return DropdownMenuItem(
              value: game,
              child: Row(
                children: [
                  Icon(Icons.sports, color: kPrimaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Rodada $rodada: $home x $away',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGame = value;
            });
            if (widget.onGameSelected != null) {
              widget.onGameSelected!(value);
            }
          },
          dropdownColor: kCardColor,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
