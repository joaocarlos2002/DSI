package com.dev.br.brasileirao.chutometro.services;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Map;
import com.dev.br.brasileirao.chutometro.dto.TeamNamesDTO;
import org.springframework.http.*;


@Service
public class PredictionService {

    @Value("${ml.api.url}")
    private String mlApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public Integer getPrediction(String mandante, String visitante) {
        TeamNamesDTO dto = new TeamNamesDTO(mandante, visitante);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<TeamNamesDTO> request = new HttpEntity<>(dto, headers);

        ResponseEntity<Map> response = restTemplate.postForEntity(mlApiUrl, request, Map.class);

        if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
            return (Integer) response.getBody().get("prediction");
        }

        throw new RuntimeException("Erro ao obter previsão do modelo");
    }
}
