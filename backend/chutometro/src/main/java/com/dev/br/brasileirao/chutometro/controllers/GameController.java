package com.dev.br.brasileirao.chutometro.controllers;

import com.dev.br.brasileirao.chutometro.models.Games;
import com.dev.br.brasileirao.chutometro.services.GameServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/games")
@Validated
public class GameController {

    @Autowired
    private GameServices gameServices;

    @GetMapping
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

    @PostMapping
    public ResponseEntity<Games> create(@RequestBody Games game) {
        Games createdGame = gameServices.create(game);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(createdGame.getId())
                .toUri();
        return ResponseEntity.created(uri).body(createdGame);
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
}