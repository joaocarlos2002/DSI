import csv

class Game:
    def __init__(self, rodata, data, hora, mandante, visitante, formacao_mandante, formacao_visitante, tecnico_mandante, tecnico_visitante, vencedor, arena, mandante_Placar, visitante_Placar, mandante_Estado, visitante_Estado):
        self.rodata = rodata
        self.data = data
        self.hora = hora
        self.mandante = mandante
        self.visitante = visitante
        self.formacao_mandante = formacao_mandante
        self.formacao_visitante = formacao_visitante
        self.tecnico_mandante = tecnico_mandante
        self.tecnico_visitante = tecnico_visitante
        self.vencedor = vencedor
        self.arena = arena
        self.mandante_placar = mandante_Placar
        self.visitante_placar = visitante_Placar
        self.mandante_estado = mandante_Estado
        self.visitante_estado = visitante_Estado

    def print_game_info(self):
        
        print(f"Rodada: {self.rodata}")
        print(f"Data: {self.data}")
        print(f"Hora: {self.hora}")
        print(f"Mandante: {self.mandante}")
        print(f"Visitante: {self.visitante}")
        print(f"Formação Mandante: {self.formacao_mandante}")
        print(f"Formação Visitante: {self.formacao_visitante}")
        print(f"Técnico Mandante: {self.tecnico_mandante}")
        print(f"Técnico Visitante: {self.tecnico_visitante}")
        print(f"Vencedor: {self.vencedor}")
        print(f"Arena: {self.arena}")
        print(f"Placar Mandante: {self.mandante_placar}")
        print(f"Placar Visitante: {self.visitante_placar}")
        print(f"Estado Mandante: {self.mandante_estado}")
        print(f"Estado Visitante: {self.visitante_estado}")
    
    