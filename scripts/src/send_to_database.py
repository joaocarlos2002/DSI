import dotenv
import requests
from team import Team
from get_all_teams import get_all_teams
from get_all_games import get_all_games
import os

dotenv.load_dotenv()

DATA_BASE_URL = "http://localhost:6969"

def send_team_to_database(name_team):
    
    try:
        team = Team(name_team)

        headers = {
            "Content-Type": "application/json",
        }

        if team.avatar_link is None:
            team.avatar_link = "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRUREvlCvHREdbT-Xsf2L2dmgO7AulT-6hqeDRUThJvVKKQwYuPwNatanNGyJiXSwubdlC8iTQHCPxOrsM-uuUCfg"

        body = {
            "teamName": team.team_name,
            "avatar": team.avatar_link,
            "totalGames": team.total_games,
            "averageOfGoals": team.average_of_goals,
            "totalVictories": team.total_victories,
            "totalDefeats": team.total_defeats,
            "totalOfTies": team.total_of_ties,
        }
        team.print_team_info()

        response = requests.post(f"{DATA_BASE_URL}/api/team/create", json=body, headers=headers)

        if response.status_code == 201:
            
            print(f"Time '{team.team_name}' enviado com sucesso para a API.")
        else:
            print(f"Falha ao enviar o time para a API. Status code: {response.status_code}, Response: {response.text}")

    except Exception as e:
        print(f"Erro ao enviar o time para a API: {e}")

def send_all_games_to_database():
    try:
        print("Iniciando o envio dos jogos para a API...")
        games = get_all_games()
    
        headers = {
            "Content-Type": "application/json",
        }
        for game in games:
            try:
                mandante_placar = int(game.mandante_placar)
            except Exception:
                mandante_placar = 0
            try:
                visitante_placar = int(game.visitante_placar)
            except Exception:
                visitante_placar = 0       

            home_team_resp = requests.get(f"{DATA_BASE_URL}/api/team/{game.mandante}", headers=headers)
            if home_team_resp.status_code == 200:

                home_team_id = home_team_resp.json()
            else:
                print(home_team_resp.status_code)
                print(f"Não foi possível encontrar o time mandante: {game.mandante}")
                continue

            away_team_resp = requests.get(f"{DATA_BASE_URL}/api/team/{game.visitante}", headers=headers)
            if away_team_resp.status_code == 200:
                away_team_id = away_team_resp.json()
            else:
                print(f"Não foi possível encontrar o time visitante: {game.visitante}")
                continue

            body = {
                "round": game.rodata,
                "data": game.data,
                "homeTeam": {"id": home_team_id},
                "awayTeam": {"id": away_team_id},
                "homeTeamFormation": game.formacao_mandante,
                "awayTeamFormation": game.formacao_visitante,
                "homeTeamCoach": game.tecnico_mandante,
                "awayTeamCoach": game.tecnico_visitante,
                "Winner": game.vencedor,
                "stadium": game.arena,
                "homeTeamGoals": mandante_placar,
                "awayTeamGoals": visitante_placar,
                "homeState": game.mandante_estado,
                "awayState": game.visitante_estado,
                "totalOfGoals": mandante_placar + visitante_placar
            }

            response = requests.post(f"{DATA_BASE_URL}/api/games/create", json=body, headers=headers)
            
            if response.status_code == 201:
                print(f"Jogo {game.rodata} entre {game.mandante} e {game.visitante} enviado com sucesso para a API.")
            else:
                print(f"Falha ao enviar o jogo {game.rodata}. Status code: {response.status_code}, Response: {response.text}")

    except Exception as e:
        print(f"Erro ao enviar os jogos para a API: {e}")

def download_team_logo(team_name, save_path):
    try:
        team = Team(team_name)
        logo_url = team.avatar_link
        if not logo_url:
            print(f"Time '{team_name}' não possui logo.")
            return

        # Cria o diretório se não existir
        dir_path = os.path.dirname(save_path)
        if dir_path and not os.path.exists(dir_path):
            os.makedirs(dir_path, exist_ok=True)

        response = requests.get(logo_url, stream=True)
        if response.status_code == 200:
            with open(save_path, "wb") as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            print(f"Logo do time '{team_name}' baixado com sucesso em '{save_path}'.")
        else:
            print(f"Falha ao baixar logo do time '{team_name}'. Status code: {response.status_code}")
    except Exception as e:
        print(f"Erro ao baixar logo do time '{team_name}': {e}")

# if __name__ == "__main__":
    # send_all_games_to_database()
    # all_teams = get_all_teams()

    # for team in all_teams:
    #     time_formatado = team.replace(" ", "-").lower()
    #     download_team_logo(time_formatado, f"logos/{time_formatado}.png")
