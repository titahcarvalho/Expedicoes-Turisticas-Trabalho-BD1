-- ==========================================
-- 01_Tabelas.sql = CREATE TABLE __ Estrutura do Banco
-- ==========================================
-- 1 VIAJANTE
-- ==========================================

CREATE TABLE IF NOT EXISTS viajante (
    id_viajante INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(30)
);
-- ==========================================
-- 2. VIAGEM
-- ==========================================

CREATE TABLE IF NOT EXISTS viagem (
    id_viagem INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
	data_fim DATE NOT NULL,
    orcamento NUMERIC(10,2),
	CONSTRAINT chk_periodo_viagem
    	CHECK (data_fim >= data_inicio)
);

-- ==========================================
-- 3. RESERVA: relacionamento VIAJANTE x VIAGEM (N:N)
-- ==========================================

CREATE TABLE IF NOT EXISTS reserva (
    id_viajante INTEGER NOT NULL,
    id_viagem INTEGER NOT NULL,

    PRIMARY KEY (id_viajante, id_viagem),

    FOREIGN KEY (id_viajante)
        REFERENCES viajante(id_viajante),

    FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem)
);

-- ==========================================
-- 4. PASSEIOS
-- ==========================================

CREATE TABLE IF NOT EXISTS passeios (
    id_passeio INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- ==========================================
-- 5. DESTINOS
-- ==========================================

CREATE TABLE IF NOT EXISTS destinos (
    id_destino INTEGER PRIMARY KEY,
    cidade VARCHAR(100),
    estado VARCHAR(100),
    pais VARCHAR(100),

    id_passeio INTEGER NOT NULL,

    FOREIGN KEY (id_passeio)
        REFERENCES passeios(id_passeio)
);

-- ==========================================
-- 6. DESTINO_VIA: relacionamento VIAGEM x DESTINOS (N:N)
-- ==========================================

CREATE TABLE IF NOT EXISTS destino_via (
    id_viagem INTEGER NOT NULL,
    id_destino INTEGER NOT NULL,
    data_inicio DATE,
    data_fim DATE,

    PRIMARY KEY (id_viagem, id_destino),

    FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem),

    FOREIGN KEY (id_destino)
        REFERENCES destinos(id_destino)
);

-- ==========================================
-- 7. PASSEIO_VIAJ: relacionamento VIAGEM x PASSEIOS (N:N)
-- ==========================================

CREATE TABLE IF NOT EXISTS passeio_viaj (
    id_viagem INTEGER NOT NULL,
    id_passeio INTEGER NOT NULL,
    data_inicio DATE NOT NULL,
	data_fim DATE,
	turno VARCHAR(10) NOT NULL
	    CHECK (turno IN ('Manhã', 'Tarde', 'Noite')),

    PRIMARY KEY (id_viagem, id_passeio),
    CONSTRAINT uq_passeio_data_turno
    UNIQUE (id_viagem, data_inicio, turno),

    FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem),

    FOREIGN KEY (id_passeio)
        REFERENCES passeios(id_passeio)
);

-- ==========================================
-- 8. DESPESAS
-- ==========================================

CREATE TABLE IF NOT EXISTS despesas (
    id_despesas INTEGER PRIMARY KEY,
    nome VARCHAR(100),
    valor NUMERIC(10,2),
    id_viagem INTEGER NOT NULL,

    FOREIGN KEY (id_viagem)
        REFERENCES viagem(id_viagem)
);

-- ==========================================
-- 9. TRANSPORTE: especialização de DESPESAS
-- ==========================================

CREATE TABLE IF NOT EXISTS transporte (
    id_despesas INTEGER PRIMARY KEY,
    tipo VARCHAR(50),
    data_hora_partida TIMESTAMP NOT NULL,
	data_hora_chegada TIMESTAMP NOT NULL,
    loc_origem VARCHAR(100),
    loc_destino VARCHAR(100),
    nome_empresa VARCHAR(100),

    FOREIGN KEY (id_despesas)
        REFERENCES despesas(id_despesas),
        
    CONSTRAINT chk_periodo_transporte
    CHECK (data_hora_chegada > data_hora_partida)
);

-- ==========================================
-- 10. HOSPEDAGEM: especialização de DESPESAS
-- ==========================================

CREATE TABLE IF NOT EXISTS hospedagem (
    id_despesas INTEGER PRIMARY KEY,
    nome_local VARCHAR(100),
    tipo VARCHAR(50),
    data_entrada DATE NOT NULL,
	data_saida DATE NOT NULL,

    FOREIGN KEY (id_despesas)
        REFERENCES despesas(id_despesas),
         
    CONSTRAINT chk_periodo_hospedagem
    CHECK (data_saida > data_entrada)
);
