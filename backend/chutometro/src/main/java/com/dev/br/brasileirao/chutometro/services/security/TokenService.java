package com.dev.br.brasileirao.chutometro.services.security;


import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.dev.br.brasileirao.chutometro.models.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

@Service
public class TokenService {

    @Value("${spring.api.security.token.secret}")
    private String secretPassword;

    public String generateToken(User user) {
        try {
            Algorithm alg = Algorithm.HMAC256(secretPassword);
            String token = JWT.create().withIssuer("login-auth-api").withSubject(user.getEmail()).withExpiresAt(generateExpirationDate()).sign(alg);
            return token;
        } catch (JWTCreationException e) {
            throw new RuntimeException("Error while authenticating");
        }
    }

    public String validateToken(String token) {
        try {
            Algorithm alg = Algorithm.HMAC256(secretPassword);
            return JWT.require(alg).withIssuer("login-auth-api").build().verify(token).getSubject();
        } catch (JWTCreationException e) {
            return null;
        }
    }

    private Instant generateExpirationDate() {
        return LocalDateTime.now().plusHours(2).toInstant(ZoneOffset.of("-03:00"));
    }

}
