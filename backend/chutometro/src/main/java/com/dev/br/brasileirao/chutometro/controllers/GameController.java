package com.dev.br.brasileirao.chutometro.controllers;

import com.dev.br.brasileirao.chutometro.models.Games;
import com.dev.br.brasileirao.chutometro.models.Team;
import com.dev.br.brasileirao.chutometro.services.GameServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/games")
@Validated
public class GameController {

    @Autowired
    private GameServices gameServices;

    @GetMapping("/all")
    public ResponseEntity<List<Games>> findAll() {
        List<Games> games = gameServices.findAll();
        return ResponseEntity.ok().body(games);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Games> findById(@PathVariable Long id) {
        Optional<Games> game = gameServices.findById(id);
        return game.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping("/create")
    public ResponseEntity<Games> create(@RequestBody Games game) {
        Games createdGame = gameServices.create(game);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdGame.getId())
                .toUri();
        return ResponseEntity.created(uri).body(createdGame);
    }
    
    @GetMapping("/pull-all-games-of-the-round/{round}")
    public ResponseEntity<List<Games>> pullAllGamesOfTheRound(
            @PathVariable Integer round,
            @RequestParam(required = false) String ano) {

        List<Games> games = gameServices.findByRoundAndYear(round, ano);
        if (games.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(games);
    }

    @GetMapping("/games/{team1}/{team2}")
    public ResponseEntity<List<Games>> getGames(
            @PathVariable String team1,
            @PathVariable String team2
    ) {
        return ResponseEntity.ok(gameServices.findByTeamNames(team1, team2));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Games> update(@PathVariable Long id, @RequestBody Games updatedGame) {
        try {
            Games game = gameServices.update(id, updatedGame);
            return ResponseEntity.ok().body(game);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        try {
            gameServices.delete(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/find-by-all-games")
    public ResponseEntity<List<Games>> findByAllGames() {
        List<Games> games = gameServices.findByAllGames();
        return ResponseEntity.ok().body(games);
    }
}