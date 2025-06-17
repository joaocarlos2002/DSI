package com.dev.br.brasileirao.chutometro.repositories;

import com.dev.br.brasileirao.chutometro.models.Games;
import com.dev.br.brasileirao.chutometro.models.Team;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface GameRepository extends JpaRepository<Games, Long> {
    Optional<Games> findById(Long id);

    List<Games> findByRound(Integer round);

    List<Games> findByRoundAndData(Integer round, String data);

    List<Games> findByRoundAndDataStartingWith(Integer round, String ano);

    @Query("SELECT g FROM Games g WHERE " +
            "(g.homeTeam.teamName = :team1 AND g.awayTeam.teamName = :team2) OR " +
            "(g.homeTeam.teamName = :team2 AND g.awayTeam.teamName = :team1)")
    List<Games> findByTeamNames(@Param("team1") String team1, @Param("team2") String team2);
}