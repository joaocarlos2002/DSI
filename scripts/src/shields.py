import requests

class Shield:
    def __init__(self, name: str):
        self.name = name
        team_name = name.lower().replace(" ", "-")
        self.BASE_URL = f"https://logodetimes.com/times/{team_name}/logo-{team_name}-256.png"

    def verify_status_code(self) -> bool:
        response = requests.get(self.BASE_URL)
        return response.status_code == 200 

    def return_shield_url(self) -> str:
        if not self.verify_status_code():
            return print(f"Logo not found for {self.name}.")
        return self.BASE_URL