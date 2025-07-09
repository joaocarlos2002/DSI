package com.dev.br.brasileirao.chutometro.controllers;

import com.dev.br.brasileirao.chutometro.services.PredictionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.dev.br.brasileirao.chutometro.dto.TeamNamesDTO;

@RestController
@RequestMapping("/api/predict")
public class PredictionController {

    private final PredictionService predictionService;

    @Autowired
    public PredictionController(PredictionService predictionService) {
        this.predictionService = predictionService;
    }

    @PostMapping
    public ResponseEntity<Integer> predict(@RequestBody TeamNamesDTO request) {
        Integer prediction = predictionService.getPrediction(request.home_team(), request.away_team());
        return ResponseEntity.ok(prediction);
    }
}