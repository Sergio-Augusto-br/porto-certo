# Porto Certo

Sistema web em Flutter para venda de passagens fluviais. A aplicacao usa uma
arquitetura Frontend-First com login obrigatorio antes do acesso as demais rotas.

## Estrutura do Projeto

```text
.
├── backend/            # API REST Node.js + Express + PostgreSQL
│   ├── db/             # Scripts SQL de schema e seed
│   └── src/            # Codigo-fonte da API
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
- PostgreSQL instalado e acessivel
- Navegador web disponivel

Confira se o Flutter esta pronto para uso:

```bash
flutter doctor
```

## Como acessar o projeto

1. Entre na pasta do projeto:

```bash
cd "/mnt/Documentos/UFAM/Períodos/3 periodo/Sistemas de banco de dados I"
```

2. Instale as dependencias Flutter:

```bash
flutter pub get
```

3. Prepare o backend:

```bash
cd backend
npm install
npm run db:schema
npm run db:seed
npm run dev
```

4. Em outro terminal, volte para a raiz e execute o Flutter:

```bash
cd "/mnt/Documentos/UFAM/Períodos/3 periodo/Sistemas de banco de dados I"
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

5. Abra a URL exibida no terminal:

```text
http://127.0.0.1:8080
```

Se a tela abrir em branco, pare o servidor com `Ctrl + C` no terminal e rode
novamente em uma porta limpa:

```bash
flutter clean
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8081
```

Depois acesse:

```text
http://127.0.0.1:8081
```

Outra alternativa e gerar a build web e servir os arquivos prontos:

```bash
flutter build web
python3 -m http.server 8082 --bind 127.0.0.1 --directory build/web
```

Nesse caso, acesse:

```text
http://127.0.0.1:8082
```

## Credenciais de teste

Use uma das credenciais mockadas para entrar no sistema:

```text
Email: ana.costa@email.com
Senha: senha123
```

ou

```text
Email: marcos.lima@email.com
Senha: porto456
```

## Testes

Antes de testar, garanta que as dependencias do projeto foram instaladas:

```bash
flutter pub get
```

### Teste automatizado

Execute todos os testes unitarios e de widget:

```bash
flutter test
```

O resultado esperado ao final e semelhante a:

```text
All tests passed!
```

### Analise estatica

Execute a analise do codigo Dart/Flutter:

```bash
dart analyze lib test
```

O resultado esperado e:

```text
No issues found!
```

### Teste manual no navegador

1. Inicie o projeto web:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

Se a porta 8080 mostrar tela branca, use uma porta limpa:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8081
```

2. Acesse no navegador:

```text
http://127.0.0.1:8080
```

3. Faca login com uma credencial de teste:

```text
Email: ana.costa@email.com
Senha: senha123
```

4. Na tela inicial, preencha:

- Origem
- Destino
- Data de ida

5. Clique em `Buscar Viagens`.

Se os campos estiverem validos, o sistema exibira uma mensagem como:

```text
Buscando viagens de Manaus para Parintins no dia 25/06/2026...
```

## Estrutura principal

- `backend/`: API REST, configuracao do PostgreSQL e scripts SQL
- `docs/`: documentacao do projeto, modelos e arquivos de apoio
- `lib/screens/login_screen.dart`: tela de login responsiva
- `lib/notifiers/auth_notifier.dart`: estado de autenticacao com `ChangeNotifier`
- `lib/data/passageiro_mock_db.dart`: banco mockado de passageiros
- `lib/models/passageiro.dart`: modelo `Passageiro`
- `lib/app_router.dart`: rotas publicas e privadas com `go_router`
- `test/`: testes unitarios e testes de widget
