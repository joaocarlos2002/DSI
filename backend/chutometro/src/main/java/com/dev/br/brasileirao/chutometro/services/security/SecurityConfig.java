package com.dev.br.brasileirao.chutometro.services.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;


@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    SecurityFilter securityFilter;
    @Autowired
    private CustomUserDetailsService userDetailsService;

    @Bean
    @Order(1) // Ordem 1 - executa primeiro
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();


        config.setAllowCredentials(true);
        config.addAllowedOrigin("http://localhost:50619");
        config.addAllowedOrigin("http://localhost:3000"); 
        config.addAllowedHeader("*");
        config.addAllowedMethod("GET");
        config.addAllowedMethod("POST");
        config.addAllowedMethod("PUT");
        config.addAllowedMethod("DELETE");
        config.addAllowedMethod("OPTIONS");
        config.addAllowedMethod("HEAD");
        

        config.addExposedHeader("Access-Control-Allow-Origin");
        config.addExposedHeader("Access-Control-Allow-Credentials");
        config.setMaxAge(3600L); 
        
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        
    
                        .requestMatchers(HttpMethod.POST, "/api/auth/login").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/auth/register").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/team/create").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/games/create").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/team/*").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/games/games/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/games/pull-all-games-of-the-round/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/games/find-by-all-games").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/predict").permitAll()

                        .requestMatchers(HttpMethod.PUT, "/api/user/**").permitAll()
                        .requestMatchers(HttpMethod.DELETE, "/api/user/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/user/**").permitAll()

                        .anyRequest().authenticated()
                )
                .addFilterBefore(securityFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
}


