package com.dev.br.brasileirao.chutometro.models;

import jakarta.persistence.*;

import java.util.Objects;

@Entity
@Table(name = Team.TABLE_NAME)
public class Team {
    public static final String TABLE_NAME = "team";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true)
    private Long id;

    @Column(name = "team_name", length = 100, nullable = false, unique = true)
    private String teamName;

    @Column(name = "avatar_link")
    private String avatar;

    @Column(name = "total_games")
    private Integer totalGames;

    @Column(name = "average_of_goals")
    private Float averageOfGoals;

    @Column(name = "total_victories")
    private Integer totalVictories;

    @Column(name = "total_defeats")
    private Integer totalDefeats;

    @Column(name = "total_of_ties")
    private Integer totalOfTies;

    public Team() {

    }

    public Team(Long id, String teamName, String avatar, Integer totalGames, Float averageOfGoals, Integer totalVictories, Integer totalDefeats, Integer totalOfTies) {
        this.id = id;
        this.teamName = teamName;
        this.avatar = avatar;
        this.totalGames = totalGames;
        this.averageOfGoals = averageOfGoals;
        this.totalVictories = totalVictories;
        this.totalDefeats = totalDefeats;
        this.totalOfTies = totalOfTies;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getTotalGames() {
        return totalGames;
    }

    public void setTotalGames(Integer totalGames) {
        this.totalGames = totalGames;
    }

    public Float getAverageOfGoals() {
        return averageOfGoals;
    }

    public void setAverageOfGoals(Float averageOfGoals) {
        this.averageOfGoals = averageOfGoals;
    }

    public Integer getTotalVictories() {
        return totalVictories;
    }

    public void setTotalVictories(Integer totalVictories) {
        this.totalVictories = totalVictories;
    }

    public Integer getTotalDefeats() {
        return totalDefeats;
    }

    public void setTotalDefeats(Integer totalDefeats) {
        this.totalDefeats = totalDefeats;
    }

    public Integer getTotalOfTies() {
        return totalOfTies;
    }

    public void setTotalOfTies(Integer totalOfTies) {
        this.totalOfTies = totalOfTies;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Team team = (Team) o;
        return Objects.equals(id, team.id) && Objects.equals(teamName, team.teamName) && Objects.equals(avatar, team.avatar) && Objects.equals(totalGames, team.totalGames) && Objects.equals(averageOfGoals, team.averageOfGoals) && Objects.equals(totalVictories, team.totalVictories) && Objects.equals(totalDefeats, team.totalDefeats) && Objects.equals(totalOfTies, team.totalOfTies);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, teamName, avatar, totalGames, averageOfGoals, totalVictories, totalDefeats, totalOfTies);
    }
}
