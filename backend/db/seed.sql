INSERT INTO passageiros (id_passageiro, nome, email, telefone, cpf, senha) VALUES
(1, 'Ana Beatriz Costa', 'ana.costa@email.com', '(92) 99999-1001', '123.456.789-10', 'senha123'),
(2, 'Marcos Lima', 'marcos.lima@email.com', '(92) 99999-2002', '987.654.321-00', 'porto456');

INSERT INTO embarcacoes (id_embarcacao, nome_e, tipo, descricao, capacidade_carga, url_imagem) VALUES
(1, 'Expresso Rio Negro', 'Lancha Rápida', 'Embarcação de navegação rápida indicada para deslocamentos diurnos entre cidades próximas do Médio Amazonas. Possui operação focada em agilidade, embarque simplificado e boa previsibilidade de horários em rotas de curta e média distância.', 1.8, 'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Lancha+Rapida'),
(2, 'Princesa do Solimões', 'Navio Motor', 'Navio regional preparado para percursos longos pelos rios Amazonas e Solimões. Sua estrutura é adequada para viagens com múltiplas escalas, transporte de passageiros entre polos regionais e navegação noturna com maior estabilidade.', 7.5, 'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Navio+Motor'),
(3, 'Ajato Amazonas', 'Ajato', 'Ajato de médio porte voltado para rotas expressas e trechos com alta procura de passageiros. É uma embarcação adequada para reduzir o tempo de deslocamento em linhas com poucas paradas operacionais.', 2.4, 'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Ajato'),
(4, 'Comandante Parintins', 'Barco Regional', 'Barco regional utilizado em linhas regulares entre cidades ribeirinhas e portos de conexão. A embarcação atende bem viagens com demanda mista de passageiros e pequenas cargas, mantendo operação constante no Médio Amazonas.', 5.2, 'https://placehold.co/900x420/0D47A1/FFFFFF/png?text=Barco+Regional');

INSERT INTO viagens (id_viagem, nome_rota, status_viagem, vagas_disponiveis, id_embarcacao) VALUES
(1, 'Linha Manaus - Juruti', 'Confirmada', 28, 2),
(2, 'Linha Itacoatiara - Santarém', 'Embarque Próximo', 42, 4),
(3, 'Linha Manaus - Tefé', 'Confirmada', 17, 2),
(4, 'Linha Manaus - Parintins Expressa', 'Confirmada', 9, 3),
(5, 'Linha Tefé - Manaus', 'Confirmada', 31, 2),
(6, 'Linha Parintins - Manaus', 'Embarque Próximo', 24, 1);

INSERT INTO paradas (id_parada, id_viagem, nome_porto, ordem, horario_chegada, horario_saida, preco_acumulado) VALUES
('P1-1', 1, 'Manaus', 1, '2026-07-02 06:30', '2026-07-02 07:00', 0),
('P1-2', 1, 'Itacoatiara', 2, '2026-07-02 12:10', '2026-07-02 12:40', 85),
('P1-3', 1, 'Parintins', 3, '2026-07-02 21:20', '2026-07-02 22:00', 220),
('P1-4', 1, 'Juruti', 4, '2026-07-03 05:45', '2026-07-03 06:10', 310),

('P2-1', 2, 'Itacoatiara', 1, '2026-07-03 05:40', '2026-07-03 06:00', 0),
('P2-2', 2, 'Parintins', 2, '2026-07-03 15:30', '2026-07-03 16:10', 135.50),
('P2-3', 2, 'Juruti', 3, '2026-07-03 23:40', '2026-07-04 00:20', 225),
('P2-4', 2, 'Santarém', 4, '2026-07-04 09:30', '2026-07-04 10:00', 340),

('P3-1', 3, 'Manaus', 1, '2026-07-04 17:20', '2026-07-04 18:00', 0),
('P3-2', 3, 'Manacapuru', 2, '2026-07-04 23:30', '2026-07-05 00:10', 95),
('P3-3', 3, 'Coari', 3, '2026-07-05 07:40', '2026-07-05 08:20', 180),
('P3-4', 3, 'Tefé', 4, '2026-07-05 11:20', '2026-07-05 11:50', 230),

('P4-1', 4, 'Manaus', 1, '2026-07-05 07:45', '2026-07-05 08:15', 0),
('P4-2', 4, 'Itacoatiara', 2, '2026-07-05 12:40', '2026-07-05 13:00', 80),
('P4-3', 4, 'Urucurituba', 3, '2026-07-05 15:30', '2026-07-05 15:50', 115),
('P4-4', 4, 'Parintins', 4, '2026-07-05 17:45', '2026-07-05 18:10', 160),

('P5-1', 5, 'Tefé', 1, '2026-07-07 17:00', '2026-07-07 17:30', 0),
('P5-2', 5, 'Coari', 2, '2026-07-08 00:10', '2026-07-08 00:50', 55),
('P5-3', 5, 'Manacapuru', 3, '2026-07-08 07:20', '2026-07-08 07:50', 145),
('P5-4', 5, 'Manaus', 4, '2026-07-08 10:50', '2026-07-08 11:20', 225),

('P6-1', 6, 'Parintins', 1, '2026-07-08 05:15', '2026-07-08 05:45', 0),
('P6-2', 6, 'Urucurituba', 2, '2026-07-08 08:10', '2026-07-08 08:30', 42),
('P6-3', 6, 'Itacoatiara', 3, '2026-07-08 14:55', '2026-07-08 15:25', 128.90),
('P6-4', 6, 'Manaus', 4, '2026-07-08 20:10', '2026-07-08 20:30', 210);

SELECT setval('passageiros_id_passageiro_seq', 2, true);
SELECT setval('embarcacoes_id_embarcacao_seq', 4, true);
SELECT setval('viagens_id_viagem_seq', 6, true);
