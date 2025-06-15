import csv
import os
from game import Game

file_path = os.path.join(os.path.dirname(__file__),'data', 'dataset', 'campeonato-brasileiro-full.csv')

def get_all_games() -> list:

    all_games = []

    with open(file_path, 'r', encoding='utf-8') as f:
        data = csv.DictReader(f)
        for i in data:
            game = Game(
                rodata=i['rodata'] or "N/A",
                data=i['data'] or "N/A",
                hora=i['hora'] or "N/A",
                mandante=i['mandante'] or "N/A",
                visitante=i['visitante'] or "N/A",
                formacao_mandante=i['formacao_mandante'] or "N/A",
                formacao_visitante=i['formacao_visitante'] or "N/A",
                tecnico_mandante=i['tecnico_mandante'] or "N/A",
                tecnico_visitante=i['tecnico_visitante'] or "N/A",
                vencedor=i['vencedor'] or "N/A",
                arena=i['arena'] or "N/A",
                mandante_Placar=i['mandante_Placar'] or "N/A",
                visitante_Placar=i['visitante_Placar'] or "N/A",
                mandante_Estado=i['mandante_Estado'] or "N/A",
                visitante_Estado=i['visitante_Estado'] or "N/A",
            )
            all_games.append(game)

    return all_games
