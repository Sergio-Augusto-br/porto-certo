# Porto Certo

Sistema web para venda de passagens fluviais. O projeto usa Flutter Web no
frontend, uma API REST em Node.js/Express no backend e PostgreSQL como banco de
dados.

## Estrutura

```text
.
├── backend/            # API REST Node.js + Express + PostgreSQL
│   ├── db/             # Scripts SQL de schema e seed
│   ├── src/            # Codigo-fonte da API
│   └── .env.example    # Exemplo de configuracao local
├── docs/               # Documentacao, PDFs, modelos e atividades
├── lib/                # Codigo Flutter
├── test/               # Testes automatizados
├── web/                # Arquivos do Flutter Web
├── pubspec.yaml        # Dependencias Flutter
└── README.md           # Guia principal do projeto
```

## Requisitos

- Flutter instalado e configurado
- Node.js e npm instalados
- PostgreSQL instalado e rodando
- Navegador web

Verifique o Flutter:

```bash
flutter doctor
```

Verifique Node.js e npm:

```bash
node --version
npm --version
```

## Como Rodar Depois De Clonar

Clone o repositorio e entre na pasta:

```bash
git clone URL_DO_REPOSITORIO
cd NOME_DA_PASTA_DO_PROJETO
```

### 1. Preparar O PostgreSQL

Crie um banco chamado `porto_certo`. Substitua `SUA_SENHA` pela senha real do
usuario `postgres` da sua maquina.

```bash
psql "postgres://postgres:SUA_SENHA@localhost:5432/postgres" -c "CREATE DATABASE porto_certo;"
```

Se o banco ja existir, siga para o proximo passo.

Teste a conexao:

```bash
psql "postgres://postgres:SUA_SENHA@localhost:5432/porto_certo"
```

Para sair do `psql`:

```sql
\q
```

### 2. Configurar O Backend

Entre na pasta do backend:

```bash
cd backend
```

Crie o arquivo `.env` a partir do exemplo:

```bash
cp .env.example .env
```

Edite o arquivo `backend/.env`:

```env
PORT=3000
DATABASE_URL=postgres://postgres:SUA_SENHA@localhost:5432/porto_certo
```

Instale as dependencias:

```bash
npm install
```

Crie as tabelas:

```bash
npm run db:schema
```

Insira os dados iniciais:

```bash
npm run db:seed
```

Inicie a API:

```bash
npm run dev
```

A API deve ficar disponivel em:

```text
http://127.0.0.1:3000/api
```

Teste em outro terminal:

```bash
curl http://127.0.0.1:3000/api/health
```

Resposta esperada:

```json
{"status":"ok"}
```

### 3. Rodar O Flutter Web

Em outro terminal, volte para a raiz do projeto:

```bash
cd ..
```

Instale as dependencias Flutter:

```bash
flutter pub get
```

Rode no navegador:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8082
```

Acesse:

```text
http://127.0.0.1:8082
```

## Credenciais De Teste

```text
Email: ana.costa@email.com
Senha: senha123
```

```text
Email: marcos.lima@email.com
Senha: porto456
```

## Funcionalidades

- Cadastro de passageiro
- Login de passageiro
- Atualizacao de perfil
- Listagem de viagens disponiveis
- Busca por origem, destino e data
- Detalhes da viagem com embarcacao e paradas
- Selecao de porto de embarque e desembarque
- Calculo dinamico do valor do trecho
- Compra simulada de passagem
- Registro de passagem no PostgreSQL

## Endpoints Principais

```text
GET    /api/health
POST   /api/auth/login
POST   /api/passageiros
PUT    /api/passageiros/:id
GET    /api/viagens
GET    /api/viagens/buscar?origem=...&destino=...&data=...
GET    /api/viagens/:id
POST   /api/passagens
GET    /api/passageiros/:id/passagens
```

## Testes E Validacao

Analise estatica:

```bash
dart analyze lib test
```

Testes automatizados:

```bash
flutter test
```

Build web:

```bash
flutter build web
```

Validar sintaxe do backend:

```bash
node --check backend/src/server.js
```

## Observacoes Importantes

- O arquivo `backend/.env` nao deve ser enviado ao GitHub.
- Use `backend/.env.example` apenas como modelo.
- O comando `npm run db:schema` recria as tabelas e apaga os dados atuais.
- O comando `npm run db:seed` reinsere os dados iniciais.
- Se a API estiver desligada, algumas telas do Flutter ainda possuem fallback
  para dados mockados durante desenvolvimento.
