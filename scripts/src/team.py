from shields import Shield
import csv

class Team(Shield):
    def __init__(self, name):
        self.DATASET_FILE_PATH = 'scripts\src\data\dataset\campeonato-brasileiro-full.csv'
        self.team_name = name
        self.average_of_goals = self.set_average_of_goals()
        self.total_games = self.set_total_games()
        self.total_of_ties = self.set_total_ties()
        self.total_victories = self.set_total_victories()
        self.total_defeats = self.set_total_defeats()

        try:
            self.avatar_link = Shield(name).return_shield_url()
        except Exception as e:
            self.avatar_link = "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRUREvlCvHREdbT-Xsf2L2dmgO7AulT-6hqeDRUThJvVKKQwYuPwNatanNGyJiXSwubdlC8iTQHCPxOrsM-uuUCfg"
            print(f"Erro ao obter o avatar link para o time {name}: {e}")

    def open_dataset(self):
        with open(self.DATASET_FILE_PATH, mode='r', encoding='utf-8') as f:
            reader = list(csv.DictReader(f))
        return reader

    def set_average_of_goals(self):
        total_goals = 0
        total_matches = self.set_total_games()
        base_dataset = self.open_dataset()
    
        for row in base_dataset:
            if row['mandante'] == self.team_name:
                total_goals += int(row['mandante_Placar'])
            elif row['visitante'] == self.team_name:
                total_goals += int(row['visitante_Placar'])

        if total_matches == 0:
            return 0  
        
        self.average_of_goals = round((total_goals / total_matches), 2)

        return self.average_of_goals

    def set_total_games(self) -> int:
        total_games = 0
        base_dataset = self.open_dataset()

        for row in base_dataset:
            if row['mandante'] == self.team_name or row['visitante'] == self.team_name:
                total_games += 1

        self.total_games = total_games

        return total_games
        
    def set_total_victories(self) -> int:
        total_victories = 0
        base_dataset = self.open_dataset()

        for row in base_dataset:
            if row['mandante'] == self.team_name and int(row['mandante_Placar']) > int(row['visitante_Placar']):
                total_victories += 1
            elif row['visitante'] == self.team_name and int(row['visitante_Placar']) > int(row['mandante_Placar']):
                total_victories += 1

        self.total_victories = total_victories

        return total_victories
    
    def set_total_defeats(self) -> int:
        total_defeats = 0
        base_dataset = self.open_dataset()

        for row in base_dataset:
            if row['mandante'] == self.team_name and int(row['mandante_Placar']) < int(row['visitante_Placar']):
                total_defeats += 1
            elif row['visitante'] == self.team_name and int(row['visitante_Placar']) < int(row['mandante_Placar']):
                total_defeats += 1

        self.total_defeats = total_defeats

        return total_defeats
    
    def set_total_ties(self) -> int:
        total_ties = 0
        base_dataset = self.open_dataset()

        for row in base_dataset:
            if row['mandante'] == self.team_name and int(row['mandante_Placar']) == int(row['visitante_Placar']):
                total_ties += 1
            elif row['visitante'] == self.team_name and int(row['visitante_Placar']) == int(row['mandante_Placar']):
                total_ties += 1

        self.total_ties = total_ties

        return total_ties
    
    def print_team_info(self):
        print(f"Team: {self.team_name}")
        print(f"Avatar Link: {self.avatar_link}")
        print(f"Average of Goals: {self.average_of_goals}")
        print(f"Total Games: {self.total_games}")
        print(f"Total Victories: {self.total_victories}")
        print(f"Total Defeats: {self.total_defeats}")
        print(f"Total Ties: {self.total_ties}")





