from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import numpy as np
import pandas as pd

app = FastAPI()

with open('C:\\Users\\joao_\\OneDrive\\Documentos\\Faculdade\\DSI\\backend\\fastapi\\src\\data\\modelo_forest_treinado.pkl', 'rb') as f:
    obj = pickle.load(f)

model = obj['model']
feature_names = obj['feature_names']

csv_path = 'C:\\Users\\joao_\\OneDrive\\Documentos\\Faculdade\\DSI\\backend\\fastapi\\src\\data\\campeonato-brasileiro-full.csv'
df = pd.read_csv(csv_path)

def normalize_name(name):
    return str(name).strip().lower()

def get_latest_features(home_team, away_team):
    home_team_norm = normalize_name(home_team)
    away_team_norm = normalize_name(away_team)
    mandantes = df['mandante'].astype(str).str.strip().str.lower()
    visitantes = df['visitante'].astype(str).str.strip().str.lower()
    # Último jogo entre os times
    jogos = df[(mandantes == home_team_norm) & (visitantes == away_team_norm)]
    if jogos.empty:
        print('Nomes possíveis mandante:', df['mandante'].unique())
        print('Nomes possíveis visitante:', df['visitante'].unique())
        return None
    jogo = jogos.iloc[-1]
    rodada = int(jogo['rodata'])
    # Subset do DataFrame até a rodada do confronto
    df_ate_rodada = df[df['rodata'].astype(int) < rodada].copy()
    # Funções auxiliares do pipeline
    def pontos_mandante(row):
        if row['mandante_Placar'] > row['visitante_Placar']:
            return 3
        elif row['mandante_Placar'] == row['visitante_Placar']:
            return 1
        else:
            return 0
    def pontos_visitante(row):
        if row['visitante_Placar'] > row['mandante_Placar']:
            return 3
        elif row['visitante_Placar'] == row['mandante_Placar']:
            return 1
        else:
            return 0
    # Mandante
    jogos_mandante = df_ate_rodada[mandantes[df_ate_rodada.index] == home_team_norm].sort_values('rodata', ascending=False).head(10)
    rolling_goals_scored_10 = jogos_mandante['mandante_Placar'].astype(float).mean() if not jogos_mandante.empty else 0.0
    rolling_goals_conceded_10 = jogos_mandante['visitante_Placar'].astype(float).mean() if not jogos_mandante.empty else 0.0
    rolling_points_10 = jogos_mandante.apply(pontos_mandante, axis=1).mean() if not jogos_mandante.empty else 0.0
    # Visitante
    jogos_visitante = df_ate_rodada[visitantes[df_ate_rodada.index] == away_team_norm].sort_values('rodata', ascending=False).head(10)
    rolling_goals_scored_10_visitante_form = jogos_visitante['visitante_Placar'].astype(float).mean() if not jogos_visitante.empty else 0.0
    rolling_goals_conceded_10_visitante_form = jogos_visitante['mandante_Placar'].astype(float).mean() if not jogos_visitante.empty else 0.0
    rolling_points_10_visitante_form = jogos_visitante.apply(pontos_visitante, axis=1).mean() if not jogos_visitante.empty else 0.0
    # Diferenças
    diff_rolling_goals_scored_10 = rolling_goals_scored_10 - rolling_goals_scored_10_visitante_form
    diff_rolling_goals_conceded_10 = rolling_goals_conceded_10 - rolling_goals_conceded_10_visitante_form
    diff_rolling_points_10 = rolling_points_10 - rolling_points_10_visitante_form
    # goal_diff_last_game_mandante
    last_mandante = jogos_mandante.iloc[0] if not jogos_mandante.empty else None
    goal_diff_last_game_mandante = float(last_mandante['mandante_Placar']) - float(last_mandante['visitante_Placar']) if last_mandante is not None else 0.0
    # goal_diff_last_game_visitante
    last_visitante = jogos_visitante.iloc[0] if not jogos_visitante.empty else None
    goal_diff_last_game_visitante = float(last_visitante['visitante_Placar']) - float(last_visitante['mandante_Placar']) if last_visitante is not None else 0.0
    features = [
        rolling_goals_scored_10,
        rolling_goals_conceded_10,
        rolling_points_10,
        rolling_goals_scored_10_visitante_form,
        rolling_goals_conceded_10_visitante_form,
        rolling_points_10_visitante_form,
        diff_rolling_goals_scored_10,
        diff_rolling_goals_conceded_10,
        diff_rolling_points_10,
        goal_diff_last_game_mandante,
        goal_diff_last_game_visitante
    ]
    print('Features calculadas:', features)
    return features

class InputData(BaseModel):
    rolling_goals_scored_10: float
    rolling_goals_conceded_10: float
    rolling_points_10: float
    rolling_goals_scored_10_visitante_form: float
    rolling_goals_conceded_10_visitante_form: float
    rolling_points_10_visitante_form: float
    diff_rolling_goals_scored_10: float
    diff_rolling_goals_conceded_10: float
    diff_rolling_points_10: float
    goal_diff_last_game_mandante: float
    goal_diff_last_game_visitante: float

@app.post("/predict")
def predict(data: InputData):
    features = np.array([[getattr(data, name) for name in feature_names]])
    prediction = model.predict(features)
    return {"prediction": int(prediction[0])}

class TeamsInput(BaseModel):
    home_team: str
    away_team: str

@app.post("/predict_teams")
def predict_teams(data: TeamsInput):
    features = get_latest_features(data.home_team, data.away_team)
    if features is None:
        return {"error": "Não foi possível encontrar ou calcular os previsores para esses times."}
    prediction = model.predict([features])
    return {"prediction": int(prediction[0])}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=1111)