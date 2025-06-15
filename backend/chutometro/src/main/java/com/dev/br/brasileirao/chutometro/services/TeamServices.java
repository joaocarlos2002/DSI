package com.dev.br.brasileirao.chutometro.services;

import com.dev.br.brasileirao.chutometro.models.Team;
import com.dev.br.brasileirao.chutometro.repositories.GameRepository;
import com.dev.br.brasileirao.chutometro.repositories.TeamRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class TeamServices {
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private TeamRepository teamRepository;

    public TeamServices(GameRepository gameRepository, TeamRepository teamRepository) {
        this.gameRepository = gameRepository;
        this.teamRepository = teamRepository;
    }

    @Transactional
    public Team findTeamByName(String name) {
        try {
            Optional<Team> team = this.teamRepository.findByTeamName(name);
            return team.orElseThrow(() -> new RuntimeException("Time não encontrado"));
        }catch (RuntimeException e) {
            e.printStackTrace();
            throw new RuntimeException("Time não encontrado", e);
        }
    }

    @Transactional
    public Team findById(Long id) {
        try {
            Optional<Team> team = this.teamRepository.findById(id);
            return team.orElseThrow(() -> new RuntimeException("Time não encontrado"));
        } catch (RuntimeException e) {
            e.printStackTrace();
            throw new RuntimeException("Time não encontrado", e);
        }
    }

    // precisa tratar, caso não passe alguma coluna da tabela, depois tu faz isso guilherme
    @Transactional
    public Team createTeam(Team team) {
        try {
            team.setId(null);
            team = this.teamRepository.save(team);
            return this.teamRepository.save(team);
        } catch (RuntimeException e) {
            e.printStackTrace();
            throw e;
        }
    }

    @Transactional
    public void updateAvatarTeam(Long id, String newLink) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setAvatar(newLink);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateNameTeam(Long id, String newName) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setTeamName(newName);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateTotalGames(Long id, Integer newTotalGames) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setTotalGames(newTotalGames);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateAverageOfGoals(Long id, Float newAverage) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setAverageOfGoals(newAverage);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateTotalVictories(Long id, Integer newVictories) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setTotalVictories(newVictories);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateTotalDefeats(Long id, Integer newDefeats) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setTotalDefeats(newDefeats);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void updateTotalTies(Long id, Integer newTies) {
        teamRepository.findById(id).ifPresent(team -> {
            team.setTotalOfTies(newTies);
            teamRepository.save(team);
        });
    }

    @Transactional
    public void deleteTeam(Long id) {
        try {
            teamRepository.deleteById(id);

        } catch (Exception e) {
            throw new RuntimeException("Usuário não existe no banco");
        }
    }
}



