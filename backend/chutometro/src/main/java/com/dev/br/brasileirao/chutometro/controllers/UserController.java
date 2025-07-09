package com.dev.br.brasileirao.chutometro.controllers;

import com.dev.br.brasileirao.chutometro.models.User;
import com.dev.br.brasileirao.chutometro.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @GetMapping
    public ResponseEntity<String> getUser() {
        return ResponseEntity.ok("sucesso!");
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUserName(@PathVariable String id, @RequestBody Map<String, String> body) {
        try {
            Optional<User> optionalUser = userRepository.findById(id);

            if (optionalUser.isPresent()) {
                User user = optionalUser.get();
                String newName = body.get("name");
                
               
                if (newName == null || newName.trim().isEmpty()) {
                    return ResponseEntity.badRequest().body("Nome não pode ser vazio!");
                }
                
                user.setName(newName.trim());
                userRepository.save(user);
                return ResponseEntity.ok().body("Nome atualizado com sucesso!");
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Erro interno do servidor: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable String id) {
        try {
            if (userRepository.existsById(id)) {
                userRepository.deleteById(id);
                return ResponseEntity.ok().body("Usuário excluído com sucesso!");
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Erro interno do servidor: " + e.getMessage());
        }
    }
}