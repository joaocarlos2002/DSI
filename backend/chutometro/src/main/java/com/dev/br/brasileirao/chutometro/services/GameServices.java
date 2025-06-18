package com.dev.br.brasileirao.chutometro.services;

import com.dev.br.brasileirao.chutometro.models.Games;
import com.dev.br.brasileirao.chutometro.models.Team;
import com.dev.br.brasileirao.chutometro.repositories.GameRepository;
import com.dev.br.brasileirao.chutometro.repositories.TeamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;


@Service
public class GameServices {
    @Autowired
    private GameRepository gameRepository;
    @Autowired
    private TeamRepository teamRepository;

    public GameServices(GameRepository gameRepository, TeamRepository teamRepository) {
        this.gameRepository = gameRepository;
        this.teamRepository = teamRepository;
    }

    public Games create(Games game) {
        validateTeams(game);
        calculateTotalGoals(game);
        return gameRepository.save(game);
    }

    public List<Games> findAllByRoundAndDate(Integer round, String data) {
        if (data != null) {
            return gameRepository.findByRoundAndData(round, data);
        } else {
            return gameRepository.findByRound(round);
        }
    }

    public List<Games> findByTeamNames(String team1, String team2) {
        return gameRepository.findByTeamNames(team1, team2);
    }

    public List<Games> findByRoundAndYear(Integer round, String ano) {
        if (ano != null && !ano.isBlank()) {
            return gameRepository.findByRoundAndDataStartingWith(round, ano);
        }
        return gameRepository.findByRound(round);
    }

    public List<Games> findAll() {
        return gameRepository.findAll();
    }

    public Optional<Games> findById(Long id) {

        return gameRepository.findById(id);
    }

    public Games update(Long id, Games updatedGame) {
        return gameRepository.findById(id).map(game -> {
            game.setHomeTeam(updatedGame.getHomeTeam());
            game.setHomeTeamGoals(updatedGame.getHomeTeamGoals());
            game.setHomeState(updatedGame.getHomeState());
            game.setHomeTeamFormation(updatedGame.getHomeTeamFormation());
            game.setHomeTeamCoach(updatedGame.getHomeTeamCoach());

            game.setAwayTeam(updatedGame.getAwayTeam());
            game.setAwayTeamGoals(updatedGame.getAwayTeamGoals());
            game.setAwayState(updatedGame.getAwayState());
            game.setAwayTeamFormation(updatedGame.getAwayTeamFormation());
            game.setAwayTeamCoach(updatedGame.getAwayTeamCoach());

            game.setWinner(updatedGame.getWinner());
            game.setStadium(updatedGame.getStadium());
            game.setRound(updatedGame.getRound());
            game.setData(updatedGame.getData());

            calculateTotalGoals(game);
            return gameRepository.save(game);
        }).orElseThrow(() -> new RuntimeException("Jogo não encontrado"));
    }

    public void delete(Long id) {
        if (!gameRepository.existsById(id)) {
            throw new RuntimeException("Jogo não encontrado");
        }
        gameRepository.deleteById(id);
    }



    private void calculateTotalGoals(Games game) {
        Integer total = 0;
        if (game.getHomeTeamGoals() != null) total += game.getHomeTeamGoals();
        if (game.getAwayTeamGoals() != null) total += game.getAwayTeamGoals();
        game.setTotalOfGoals(total);
    }

    private void validateTeams(Games game) {
        if (!teamRepository.existsById(game.getHomeTeam().getId()) ||
                !teamRepository.existsById(game.getAwayTeam().getId())) {
            throw new RuntimeException("One or both teams do not exist");
        }
    }
}
