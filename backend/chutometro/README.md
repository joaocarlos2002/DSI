
# API Chutômetro - Brasileirão
Esta é uma API Spring Boot para gerenciamento de jogos e times do Campeonato Brasileiro (Brasileirão), chamada "Chutômetro".

## Endpoints

### Autenticação (`/api/auth`)

#### Login (`/api/auth/login`)

| Método | Endpoint              | Descrição                |
|--------|-----------------------|--------------------------|
| POST   | /api/auth/login        | Realiza o login do usuário e retorna um token de autenticação |

**Exemplo de requisição (POST)**
```json
{
  "email": "usuario@example.com",
  "password": "senha123"
}
```

**Exemplo de resposta**
```json
{
  "name": "Nome do Usuário",
  "token": "token_de_autenticacao_aqui"
}
```

#### Registro (`/api/auth/register`)

| Método | Endpoint              | Descrição                |
|--------|-----------------------|--------------------------|
| POST   | /api/auth/register     | Realiza o cadastro de um novo usuário e retorna um token de autenticação |

**Exemplo de requisição (POST)**
```json
{
  "email": "usuario@example.com",
  "password": "senha123",
  "name": "Nome do Usuário"
}
```

**Exemplo de resposta**
```json
{
  "name": "Nome do Usuário",
  "token": "token_de_autenticacao_aqui"
}
```

### Jogos (`/api/games`)

| Método | Endpoint            | Descrição               |
|--------|---------------------|--------------------------|
| GET    | /api/games          | Lista todos os jogos     |
| GET    | /api/games/{id}     | Obtém um jogo pelo ID    |
| POST   | /api/games          | Cria um novo jogo        |
| PUT    | /api/games/{id}     | Atualiza um jogo         |
| DELETE | /api/games/{id}     | Remove um jogo           |

### Times (`/api/team`)

| Método | Endpoint                            | Descrição                            |
|--------|-------------------------------------|----------------------------------------|
| GET    | /api/team/{id}                      | Obtém um time específico pelo ID       |
| POST   | /api/team                           | Cria um novo time                      |
| PUT    | /api/team/{id}/name                 | Atualiza o nome do time                |
| PUT    | /api/team/{id}/avatar               | Atualiza o link do avatar do time      |
| PUT    | /api/team/{id}/total-games          | Atualiza o total de jogos do time      |
| PUT    | /api/team/{id}/average-goals        | Atualiza a média de gols do time       |
| PUT    | /api/team/{id}/total-victories      | Atualiza o total de vitórias do time   |
| PUT    | /api/team/{id}/total-defeats        | Atualiza o total de derrotas do time   |
| PUT    | /api/team/{id}/total-ties           | Atualiza o total de empates do time    |
| DELETE | /api/team/{id}                      | Remove um time                         |

## Requisitos
- Java 17
- Spring Boot
- Maven

## Como executar
1. Clone o repositório
2. Execute o comando

```
mvn spring-boot:run
```

A API estará disponível em `http://localhost:6969`
