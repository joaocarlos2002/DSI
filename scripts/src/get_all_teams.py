import csv
import os

file_path = os.path.join(os.path.dirname(__file__),'data', 'dataset', 'campeonato-brasileiro-full.csv')

def get_all_teams() -> tuple:

    home_teams = set()
    away_teams = set()

    with open(file_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            home_teams.add(row['mandante'])
            away_teams.add(row['visitante'])

    all_teams = home_teams.union(away_teams)
    
    
    return all_teams










