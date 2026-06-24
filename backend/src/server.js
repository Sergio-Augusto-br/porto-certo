import 'dotenv/config';
import cors from 'cors';
import express from 'express';
import pg from 'pg';

const { Pool } = pg;
const app = express();
const port = process.env.PORT || 3000;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.use(cors());
app.use(express.json());

app.get('/api/health', async (req, res, next) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok' });
  } catch (error) {
    next(error);
  }
});

app.post('/api/auth/login', async (req, res, next) => {
  try {
    const { email, senha } = req.body;
    const result = await pool.query(
      `SELECT id_passageiro, nome, email, telefone, cpf, senha
       FROM passageiros
       WHERE lower(email) = lower($1)
       LIMIT 1`,
      [email],
    );

    const passageiro = result.rows[0];
    if (!passageiro || passageiro.senha !== senha) {
      return res.status(401).json({ message: 'Credenciais inválidas.' });
    }

    return res.json({ passageiro });
  } catch (error) {
    return next(error);
  }
});

app.post('/api/passageiros', async (req, res, next) => {
  try {
    const { nome, email, telefone, cpf, senha } = req.body;
    const result = await pool.query(
      `INSERT INTO passageiros (nome, email, telefone, cpf, senha)
       VALUES ($1, lower($2), $3, $4, $5)
       RETURNING id_passageiro, nome, email, telefone, cpf, senha`,
      [nome?.trim(), email?.trim(), telefone?.trim(), cpf?.trim(), senha],
    );

    return res.status(201).json(result.rows[0]);
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ message: 'Email ou CPF já cadastrado.' });
    }
    return next(error);
  }
});

app.put('/api/passageiros/:id', async (req, res, next) => {
  try {
    const { nome, email, telefone, senha } = req.body;
    const result = await pool.query(
      `UPDATE passageiros
       SET nome = $1, email = lower($2), telefone = $3, senha = $4
       WHERE id_passageiro = $5
       RETURNING id_passageiro, nome, email, telefone, cpf, senha`,
      [nome?.trim(), email?.trim(), telefone?.trim(), senha, req.params.id],
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Passageiro não encontrado.' });
    }

    return res.json(result.rows[0]);
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ message: 'Email já cadastrado.' });
    }
    return next(error);
  }
});

app.get('/api/viagens/buscar', async (req, res, next) => {
  try {
    const { origem, destino, data } = req.query;
    const ids = await pool.query(
      `SELECT v.id_viagem
       FROM viagens v
       JOIN paradas pe ON pe.id_viagem = v.id_viagem
       JOIN paradas pd ON pd.id_viagem = v.id_viagem
       WHERE lower(pe.nome_porto) = lower($1)
         AND lower(pd.nome_porto) = lower($2)
         AND pd.ordem > pe.ordem
         AND to_char(pe.horario_saida, 'DD/MM/YYYY') = $3
       ORDER BY pe.horario_saida`,
      [origem, destino, data],
    );

    const viagens = await carregarViagens(ids.rows.map((row) => row.id_viagem));
    return res.json(viagens);
  } catch (error) {
    return next(error);
  }
});

app.get('/api/viagens', async (req, res, next) => {
  try {
    const viagens = await carregarViagens();
    return res.json(viagens);
  } catch (error) {
    return next(error);
  }
});

app.get('/api/viagens/:id', async (req, res, next) => {
  try {
    const viagens = await carregarViagens([Number(req.params.id)]);
    if (viagens.length === 0) {
      return res.status(404).json({ message: 'Viagem não encontrada.' });
    }

    return res.json(viagens[0]);
  } catch (error) {
    return next(error);
  }
});

app.post('/api/passagens', async (req, res, next) => {
  try {
    const idPassagem = req.body.idPassagem || Date.now().toString();
    const result = await pool.query(
      `INSERT INTO passagens (
        id_passagem,
        id_viagem,
        id_passageiro,
        id_porto_embarque,
        id_porto_desembarque,
        valor_total,
        status_reserva
      )
      VALUES ($1, $2, $3, $4, $5, $6, COALESCE($7, 'Confirmada'))
      RETURNING
        id_passagem AS "idPassagem",
        id_viagem AS "idViagem",
        id_passageiro AS "idPassageiro",
        id_porto_embarque AS "idPortoEmbarque",
        id_porto_desembarque AS "idPortoDesembarque",
        valor_total::float AS "valorTotal",
        status_reserva AS "statusReserva"`,
      [
        idPassagem,
        Number(req.body.idViagem),
        Number(req.body.idPassageiro),
        req.body.idPortoEmbarque,
        req.body.idPortoDesembarque,
        Number(req.body.valorTotal),
        req.body.statusReserva,
      ],
    );

    return res.status(201).json(result.rows[0]);
  } catch (error) {
    return next(error);
  }
});

app.get('/api/passageiros/:id/passagens', async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT
        id_passagem AS "idPassagem",
        id_viagem AS "idViagem",
        id_passageiro AS "idPassageiro",
        id_porto_embarque AS "idPortoEmbarque",
        id_porto_desembarque AS "idPortoDesembarque",
        valor_total::float AS "valorTotal",
        status_reserva AS "statusReserva"
       FROM passagens
       WHERE id_passageiro = $1
       ORDER BY criada_em DESC`,
      [req.params.id],
    );

    return res.json(result.rows);
  } catch (error) {
    return next(error);
  }
});

async function carregarViagens(ids = null) {
  const params = ids && ids.length > 0 ? [ids] : [];
  const where = ids && ids.length > 0 ? 'WHERE v.id_viagem = ANY($1)' : '';

  const viagensResult = await pool.query(
    `SELECT
      v.id_viagem,
      v.nome_rota,
      v.status_viagem,
      v.vagas_disponiveis,
      e.id_embarcacao,
      e.nome_e,
      e.tipo,
      e.descricao,
      e.capacidade_carga::float,
      e.url_imagem
     FROM viagens v
     JOIN embarcacoes e ON e.id_embarcacao = v.id_embarcacao
     ${where}
     ORDER BY v.id_viagem`,
    params,
  );

  if (viagensResult.rows.length === 0) {
    return [];
  }

  const viagemIds = viagensResult.rows.map((row) => row.id_viagem);
  const paradasResult = await pool.query(
    `SELECT
      id_parada,
      id_viagem,
      nome_porto,
      ordem,
      to_char(horario_chegada, 'DD/MM/YYYY HH24:MI') AS horario_chegada,
      to_char(horario_saida, 'DD/MM/YYYY HH24:MI') AS horario_saida,
      preco_acumulado::float
     FROM paradas
     WHERE id_viagem = ANY($1)
     ORDER BY id_viagem, ordem`,
    [viagemIds],
  );

  const paradasPorViagem = new Map();
  for (const parada of paradasResult.rows) {
    const lista = paradasPorViagem.get(parada.id_viagem) || [];
    lista.push(parada);
    paradasPorViagem.set(parada.id_viagem, lista);
  }

  return viagensResult.rows.map((row) => ({
    id_viagem: row.id_viagem,
    nome_rota: row.nome_rota,
    status_viagem: row.status_viagem,
    vagas_disponiveis: row.vagas_disponiveis,
    embarcacao: {
      id_embarcacao: row.id_embarcacao,
      nome_e: row.nome_e,
      tipo: row.tipo,
      descricao: row.descricao,
      capacidade_carga: row.capacidade_carga,
      url_imagem: row.url_imagem,
    },
    paradas: paradasPorViagem.get(row.id_viagem) || [],
  }));
}

app.use((error, req, res, next) => {
  console.error(error);
  res.status(500).json({ message: 'Erro interno no servidor.' });
});

app.listen(port, () => {
  console.log(`Porto Certo API rodando em http://127.0.0.1:${port}/api`);
});
