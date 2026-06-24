# Documentação do Modelo Entidade-Relacionamento e Integração Web

Este documento apresenta a arquitetura de dados do sistema de transporte fluvial e detalha como cada entidade modelada reflete nas interfaces e fluxos do sistema web simulado (Frontend).

---

## 1. Dicionário de Dados: Entidades e Atributos

A arquitetura do sistema baseia-se em cinco entidades principais que gerenciam a logística de transporte e a operação comercial.

### 1.1. [cite_start]Embarcacao [cite: 18]
Responsável por armazenar as características físicas e visuais do meio de transporte físico.
* [cite_start]**id_embarcacao**: Identificador único da embarcação[cite: 2].
* **nome_e**: Nome oficial da embarcação[cite: 3].
* **Tipo**: Categoria operacional (ex: Lancha Rápida, Navio Motor, Ajato)[cite: 27].
* [cite_start]**descricao**: Resumo textual das especificações[cite: 26].
* [cite_start]**capacidade_carga**: Limite de peso suportado para o transporte[cite: 25].
* [cite_start]**url_imagem**: Referência para o ativo de mídia consumido no frontend[cite: 4].

### 1.2. [cite_start]Viagem [cite: 21]
Atua como a entidade central da logística, definindo o trajeto macro de uma rota em uma data específica.
* [cite_start]**id_viagem**: Identificador único da execução da viagem[cite: 15].
* [cite_start]**id_embarcacao**: Chave estrangeira que vincula a viagem à embarcação designada[cite: 14].
* [cite_start]**origem_principal**: Ponto de partida inicial do percurso[cite: 23].
* **destino_principal**: Ponto de chegada final do percurso[cite: 31].
* **dt_hora_saida_v**: Data e hora de partida estipulada para o início da viagem[cite: 24].
* **status_viagem**: Situação operacional atual (ex: Confirmada, Embarque Próximo)[cite: 16].
* **vagas_disponiveis**: Controle de lotação dinâmico[cite: 29].

### 1.3. [cite_start]Parada [cite: 10]
Gerencia os nós operacionais (escalas) pertencentes a uma viagem, viabilizando a precificação fracionada e os embarques intermediários.
* [cite_start]**id_parada**: Identificador único do nó de escala[cite: 7].
* [cite_start]**id_viagem**: Chave estrangeira atrelando a escala a uma viagem específica[cite: 6].
* **nome_porto**: Nome da cidade ou localidade de atracação[cite: 11].
* **ordem**: Posição cronológica/geográfica da parada dentro do roteiro macro[cite: 6].
* [cite_start]**dt_hora_chegada_p**: Horário estimado de chegada ao porto[cite: 12].
* **dt_hora_saida_p**: Horário estimado de partida do porto[cite: 8].
* **preco_base**: Valor base empregado para o cálculo dinâmico de trechos[cite: 9].

### 1.4. [cite_start]Passageiro [cite: 50]
Armazena as credenciais e dados pessoais dos clientes cadastrados.
* [cite_start]**id_passageiro**: Identificador único do usuário[cite: 52].
* [cite_start]**nome_p**: Nome completo[cite: 48].
* **cpf**: Documento de identificação[cite: 47].
* [cite_start]**telefone**: Contato móvel[cite: 46].
* [cite_start]**email**: Endereço eletrônico utilizado como login[cite: 53].
* **senha**: Credencial de acesso (hash/criptografada)[cite: 51].

### 1.5. Passagem [cite: 39]
Entidade associativa que consolida a transação comercial (bilhete), ligando o cliente ao trecho percorrido.
* [cite_start]**id_passagem**: Código identificador único da reserva[cite: 41].
* **id_passageiro**: Identificador do titular da passagem[cite: 43].
* **id_viagem**: Identificador da viagem selecionada[cite: 34].
* **porto_embarque**: Referência ao ID da `Parada` onde o cliente inicia o trecho[cite: 38].
* **porto_desmbarque**: Referência ao ID da `Parada` onde o cliente finaliza o trecho[cite: 33].
* **valor_total**: Preço final calculado via subtração dos valores base das paradas selecionadas[cite: 37].
* **status_reserva**: Situação atual do bilhete (ex: Confirmada, Pendente, Cancelada)[cite: 42].

---

## 2. Integração com a Arquitetura do Sistema Web

As entidades descritas acima formam a base para o gerenciamento de estado e a renderização das telas do frontend (Flutter Web Simulacro). A correlação entre o diagrama e as interfaces ocorre das seguintes maneiras:

### 2.1. Controle de Sessão e Perfil
[cite_start]A entidade **`Passageiro`** [cite: 50] é diretamente manipulada pelas telas de **Login** e **Cadastro**. No frontend, seus dados são sustentados em memória através do gerenciador de estado (como um `AuthNotifier`), o que permite pré-preencher os dados em interfaces subsequentes (como "Meu Perfil" ou no momento do Checkout).

### 2.2. Vitrine e Motor de Busca
[cite_start]As interfaces de **HomeScreen** e **Resultados de Busca** consomem uma agregação das entidades **`Viagem`** [cite: 21] [cite_start]e **`Embarcacao`**[cite: 18]. [cite_start]O frontend realiza filtros sobre `origem_principal` [cite: 23] [cite_start]e `destino_principal` [cite: 31] [cite_start]para exibir cards com informações operacionais básicas (horários, status e vagas) e informações visuais do barco (`url_imagem` [cite: 4][cite_start], `Tipo` [cite: 27]).

### 2.3. Roteamento Dinâmico (Detalhes da Viagem)
[cite_start]A tela de **Detalhes da Viagem** aprofunda a exibição da viagem selecionada iterando sobre os registros da entidade **`Parada`** [cite: 10] associados a ela. [cite_start]Os campos `dt_hora_chegada_p` [cite: 12] [cite_start]e `dt_hora_saida_p` [cite: 8] [cite_start]são utilizados para construir a "Linha do Tempo" visual, enquanto os atributos `nome_porto` [cite: 11] alimentam as opções de *dropdown* para a seleção do trecho exato de interesse do passageiro.

### 2.4. Carrinho de Compras e Finalização (Checkout)
A tela de **Compra de Passagem** atua como o integrador final. [cite_start]Ela recebe os dados de sessão do **`Passageiro`** [cite: 50][cite_start], o contexto da **`Viagem`** [cite: 21][cite_start], e as chaves de **`porto_embarque`** [cite: 38] [cite_start]e **`porto_desmbarque`** [cite: 33] escolhidas na tela anterior. [cite_start]Ao confirmar a transação, o frontend instancia um novo objeto do tipo **`Passagem`** [cite: 39] [cite_start]gravando o `valor_total` [cite: 37] calculado dinamicamente, concluindo o fluxo e permitindo a renderização do comprovante final na tela "Minhas Viagens".