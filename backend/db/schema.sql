DROP TABLE IF EXISTS passagens;
DROP TABLE IF EXISTS paradas;
DROP TABLE IF EXISTS viagens;
DROP TABLE IF EXISTS embarcacoes;
DROP TABLE IF EXISTS passageiros;

CREATE TABLE passageiros (
  id_passageiro SERIAL PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  telefone VARCHAR(30) NOT NULL,
  cpf VARCHAR(20) NOT NULL UNIQUE,
  senha VARCHAR(120) NOT NULL
);

CREATE TABLE embarcacoes (
  id_embarcacao SERIAL PRIMARY KEY,
  nome_e VARCHAR(120) NOT NULL,
  tipo VARCHAR(60) NOT NULL,
  descricao TEXT NOT NULL,
  capacidade_carga NUMERIC(10, 2) NOT NULL,
  url_imagem TEXT NOT NULL
);

CREATE TABLE viagens (
  id_viagem SERIAL PRIMARY KEY,
  nome_rota VARCHAR(140) NOT NULL,
  status_viagem VARCHAR(40) NOT NULL,
  vagas_disponiveis INTEGER NOT NULL CHECK (vagas_disponiveis >= 0),
  id_embarcacao INTEGER NOT NULL REFERENCES embarcacoes(id_embarcacao)
);

CREATE TABLE paradas (
  id_parada VARCHAR(20) PRIMARY KEY,
  id_viagem INTEGER NOT NULL REFERENCES viagens(id_viagem) ON DELETE CASCADE,
  nome_porto VARCHAR(80) NOT NULL,
  ordem INTEGER NOT NULL,
  horario_chegada TIMESTAMP NOT NULL,
  horario_saida TIMESTAMP NOT NULL,
  preco_acumulado NUMERIC(10, 2) NOT NULL,
  UNIQUE (id_viagem, ordem)
);

CREATE TABLE passagens (
  id_passagem VARCHAR(40) PRIMARY KEY,
  id_viagem INTEGER NOT NULL REFERENCES viagens(id_viagem),
  id_passageiro INTEGER NOT NULL REFERENCES passageiros(id_passageiro),
  id_porto_embarque VARCHAR(20) NOT NULL REFERENCES paradas(id_parada),
  id_porto_desembarque VARCHAR(20) NOT NULL REFERENCES paradas(id_parada),
  valor_total NUMERIC(10, 2) NOT NULL,
  status_reserva VARCHAR(40) NOT NULL DEFAULT 'Confirmada',
  criada_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_paradas_viagem_ordem ON paradas(id_viagem, ordem);
CREATE INDEX idx_passagens_passageiro ON passagens(id_passageiro);
