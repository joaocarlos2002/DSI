package com.dev.br.brasileirao.chutometro.models;

import jakarta.persistence.*;

import java.util.Objects;

@Entity
@Table(name = Games.GAME_NAME)
public class Games {
    public static final String GAME_NAME = "games";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", unique = true)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "home_team_id", nullable = false)
    private Team homeTeam;

    @Column(name = "home_team_goals")
    private Integer homeTeamGoals;

    @Column(name = "home_state")
    private String homeState;

    @Column(name = "home_team_formation")
    private String homeTeamFormation;

    @Column(name = "home_team_coach")
    private String homeTeamCoach;

    @ManyToOne
    @JoinColumn(name = "away_team_id", nullable = false)
    private Team awayTeam;

    @Column(name = "away_team_goals")
    private Integer awayTeamGoals;

    @Column(name = "away_state")
    private String awayState;

    @Column(name = "away_team_formation")
    private String awayTeamFormation;

    @Column(name = "away_team_coach")
    private String awayTeamCoach;

    @Column(name = "Winner")
    private String Winner;

    @Column(name = "stadium")
    private String stadium;

    @Column(name = "round")
    private Integer round;

    @Column(name = "data")
    private String data;

    @Column(name = "total_goals")
    private Integer totalOfGoals;


    public Games() {

    }

    public Games(Long id, Team homeTeam, Integer homeTeamGoals, String homeState, String homeTeamFormation, String homeTeamCoach, Team awayTeam, Integer awayTeamGoals, String awayState, String awayTeamFormation, String awayTeamCoach, String winner, String stadium, Integer round, String data, Integer totalOfGoals) {
        this.id = id;
        this.homeTeam = homeTeam;
        this.homeTeamGoals = homeTeamGoals;
        this.homeState = homeState;
        this.homeTeamFormation = homeTeamFormation;
        this.homeTeamCoach = homeTeamCoach;
        this.awayTeam = awayTeam;
        this.awayTeamGoals = awayTeamGoals;
        this.awayState = awayState;
        this.awayTeamFormation = awayTeamFormation;
        this.awayTeamCoach = awayTeamCoach;
        Winner = winner;
        this.stadium = stadium;
        this.round = round;
        this.data = data;
        this.totalOfGoals = totalOfGoals;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Team getHomeTeam() {
        return homeTeam;
    }

    public void setHomeTeam(Team homeTeam) {
        this.homeTeam = homeTeam;
    }

    public Integer getHomeTeamGoals() {
        return homeTeamGoals;
    }

    public void setHomeTeamGoals(Integer homeTeamGoals) {
        this.homeTeamGoals = homeTeamGoals;
    }

    public String getHomeState() {
        return homeState;
    }

    public void setHomeState(String homeState) {
        this.homeState = homeState;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Games games = (Games) o;
        return Objects.equals(id, games.id) && Objects.equals(homeTeam, games.homeTeam) && Objects.equals(homeTeamGoals, games.homeTeamGoals) && Objects.equals(homeState, games.homeState) && Objects.equals(homeTeamFormation, games.homeTeamFormation) && Objects.equals(homeTeamCoach, games.homeTeamCoach) && Objects.equals(awayTeam, games.awayTeam) && Objects.equals(awayTeamGoals, games.awayTeamGoals) && Objects.equals(awayState, games.awayState) && Objects.equals(awayTeamFormation, games.awayTeamFormation) && Objects.equals(awayTeamCoach, games.awayTeamCoach) && Objects.equals(Winner, games.Winner) && Objects.equals(stadium, games.stadium) && Objects.equals(round, games.round) && Objects.equals(data, games.data) && Objects.equals(totalOfGoals, games.totalOfGoals);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, homeTeam, homeTeamGoals, homeState, homeTeamFormation, homeTeamCoach, awayTeam, awayTeamGoals, awayState, awayTeamFormation, awayTeamCoach, Winner, stadium, round, data, totalOfGoals);
    }

    public String getHomeTeamFormation() {
        return homeTeamFormation;
    }

    public void setHomeTeamFormation(String homeTeamFormation) {
        this.homeTeamFormation = homeTeamFormation;
    }

    public String getHomeTeamCoach() {
        return homeTeamCoach;
    }

    public void setHomeTeamCoach(String homeTeamCoach) {
        this.homeTeamCoach = homeTeamCoach;
    }

    public Team getAwayTeam() {
        return awayTeam;
    }

    public void setAwayTeam(Team awayTeam) {
        this.awayTeam = awayTeam;
    }

    public Integer getAwayTeamGoals() {
        return awayTeamGoals;
    }

    public void setAwayTeamGoals(Integer awayTeamGoals) {
        this.awayTeamGoals = awayTeamGoals;
    }

    public String getAwayState() {
        return awayState;
    }

    public void setAwayState(String awayState) {
        this.awayState = awayState;
    }

    public String getAwayTeamFormation() {
        return awayTeamFormation;
    }

    public void setAwayTeamFormation(String awayTeamFormation) {
        this.awayTeamFormation = awayTeamFormation;
    }

    public String getAwayTeamCoach() {
        return awayTeamCoach;
    }

    public void setAwayTeamCoach(String awayTeamCoach) {
        this.awayTeamCoach = awayTeamCoach;
    }

    public String getWinner() {
        return Winner;
    }

    public void setWinner(String winner) {
        Winner = winner;
    }

    public String getStadium() {
        return stadium;
    }

    public void setStadium(String stadium) {
        this.stadium = stadium;
    }

    public Integer getRound() {
        return round;
    }

    public void setRound(Integer round) {
        this.round = round;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Integer getTotalOfGoals() {
        return totalOfGoals;
    }

    public void setTotalOfGoals(Integer totalOfGoals) {
        this.totalOfGoals = totalOfGoals;
    }
}
