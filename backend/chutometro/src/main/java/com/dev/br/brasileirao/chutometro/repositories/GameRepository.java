package com.dev.br.brasileirao.chutometro.repositories;

import com.dev.br.brasileirao.chutometro.models.Games;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GameRepository extends JpaRepository<Games, Long> {
    Optional<Games> findById(Long id);

//    @Override
//    List<Games> findAll();
//
//    @Override
//    List<Games> findAllById(Iterable<Long> longs);

//    @Query(value = "SELECT q FROM Games q where q.id = :id")
//    List<Games> findGameById(@Param("game_id") Long game_id);

//    @Query(value = "SELECT * FROM games g WHERE q.games.id = :id", nativeQuery = true)
//    List<Games> findGameById(@Param("id") Long id);
}