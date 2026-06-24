# Porto Certo API

Backend REST do sistema Porto Certo usando Node.js, Express e PostgreSQL.

## Preparar o PostgreSQL

Entre no PostgreSQL com um usuário administrador:

```bash
sudo -u postgres psql
```

Crie o usuário e o banco:

```sql
CREATE USER porto_certo WITH PASSWORD 'porto_certo';
CREATE DATABASE porto_certo OWNER porto_certo;
\q
```

## Configurar a API

```bash
cd backend
cp .env.example .env
npm install
npm run db:schema
npm run db:seed
npm run dev
```

A API ficará disponível em:

```text
http://127.0.0.1:3000/api
```

Teste rápido:

```bash
curl http://127.0.0.1:3000/api/health
```

## Rodar o Flutter Web integrado

Em outro terminal, na raiz do projeto:

```bash
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8082
```

Credenciais iniciais:

```text
Email: ana.costa@email.com
Senha: senha123
```
