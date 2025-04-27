package com.dev.br.brasileirao.chutometro.controllers;

import com.dev.br.brasileirao.chutometro.models.Team;
import com.dev.br.brasileirao.chutometro.services.TeamServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

@RestController
@RequestMapping("/api/team")
@Validated
public class TeamController {

    @Autowired
    private TeamServices teamServices;

    @GetMapping("/{id}")
    public ResponseEntity<Team> findById(@PathVariable Long id) {
        Team team = this.teamServices.findById(id);
        return ResponseEntity.ok().body(team);
    }

    @PostMapping("/create")
    @Validated
    public ResponseEntity<Void> create(@RequestBody Team team) {
        this.teamServices.createTeam(team);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest().path("/{id}").buildAndExpand(team.getId()).toUri();
        return ResponseEntity.created(uri).build();
    }

    @PutMapping("/{id}/name")
    public ResponseEntity<Void> updateNameTeam(@PathVariable Long id, @RequestBody String newName) {
        this.teamServices.updateNameTeam(id, newName);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/avatar")
    public ResponseEntity<Void> updateAvatarTeam(@PathVariable Long id, @RequestBody String newLink) {
        this.teamServices.updateAvatarTeam(id, newLink);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/total-games")
    public ResponseEntity<Void> updateTotalGames(@PathVariable Long id, @RequestBody Integer newTotalGames) {
        this.teamServices.updateTotalGames(id, newTotalGames);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/average-goals")
    public ResponseEntity<Void> updateAverageOfGoals(@PathVariable Long id, @RequestBody Float newAverage) {
        this.teamServices.updateAverageOfGoals(id, newAverage);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/total-victories")
    public ResponseEntity<Void> updateTotalVictories(@PathVariable Long id, @RequestBody Integer newVictories) {
        this.teamServices.updateTotalVictories(id, newVictories);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/total-defeats")
    public ResponseEntity<Void> updateTotalDefeats(@PathVariable Long id, @RequestBody Integer newDefeats) {
        this.teamServices.updateTotalDefeats(id, newDefeats);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/total-ties")
    public ResponseEntity<Void> updateTotalTies(@PathVariable Long id, @RequestBody Integer newTies) {
        this.teamServices.updateTotalTies(id, newTies);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTeam(@PathVariable Long id) {
        this.teamServices.deleteTeam(id);
        return ResponseEntity.noContent().build();
    }
}