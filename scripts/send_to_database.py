import dotenv
import os
import requests
from create_team import Team
from get_all_teams import get_all_teams

dotenv.load_dotenv()

DATA_BASE_URL = "http://localhost:6969"

def send_team_to_database(name_team):
    try:
        team = Team(name_team)

        headers = {
            "Content-Type": "application/json",
            
        }        

        body = {
            "teamName": team.team_name,
            "avatar": team.avatar_link,
            "totalGames": team.total_games,
            "averageOfGoals": team.average_of_goals,
            "totalVictories": team.total_victories,
            "totalDefeats": team.total_defeats,
            "totalOfTies": team.total_of_ties,
        }

        response = requests.post(f"{DATA_BASE_URL}/api/team/create", json=body, headers=headers)

        if response.status_code == 201:
            print(f"Time '{team.team_name}' enviado com sucesso para a API.")
        else:
            print(f"Falha ao enviar o time para a API. Status code: {response.status_code}, Response: {response.text}")

    except Exception as e:
        print(f"Erro ao enviar o time para a API: {e}")


if __name__ == "__main__":
    # all_taems = get_all_teams()

    # for team in all_taems:
    #     send_team_to_database(team)

    send_team_to_database("Sport")
    

