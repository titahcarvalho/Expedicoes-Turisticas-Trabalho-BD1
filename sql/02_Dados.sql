
-- ==========================================

-- Inserção dos dados na tabela VIAJANTE

-- ==========================================

INSERT INTO viajante (id_viajante, nome, tipo_documento)
VALUES
    (1, 'Angélica', 'Passaporte'),
    (2, 'Caique', 'CNH'),
    (3, 'Eduardo', 'Passaporte'),
    (4, 'Bruno', 'CNH'),
    (5, 'Cristiano', 'Passaporte');

-- ==========================================
-- TABELA 2: VIAGEM
-- ==========================================

INSERT INTO viagem
    (id_viagem, nome, data_inicio, data_fim, orcamento)
OVERRIDING SYSTEM VALUE    
VALUES
    (101, 'Férias em Manaus', '2027-01-11', '2027-01-19', 5000.00),
    (102, 'Cidades Históricas', '2027-02-10', '2027-02-15', 2500.00),
    (103, 'Carnaval no Rio', '2027-03-05', '2027-03-10', 3500.00),
    (104, 'Jalapão', '2027-07-01', '2027-07-08', 6000.00);


-- ==========================================
-- TABELA 3: RESERVA
-- Relacionamento N:N entre VIAJANTE e VIAGEM
-- ==========================================

INSERT INTO reserva (id_viajante, id_viagem)
VALUES
    (1, 101),  -- Angélica: Manaus
    (2, 101),  -- Caique: Manaus
    (3, 102),  -- Eduardo: Cidades Históricas
    (4, 103),  -- Bruno: Rio de Janeiro
    (5, 104),  -- Cristiano: Jalapão
    (1, 104);  -- Angélica: Jalapão
    

-- ==========================================
-- TABELA 4: PASSEIOS
-- ==========================================

INSERT INTO passeios (id_passeio, nome, descricao)
VALUES
    (201, 'Teatro Amazonas', 'Visita guiada ao teatro'),
    (202, 'Encontro das Águas', 'Passeio de barco'),
    (203, 'Museu da Inconfidência', 'Visita histórica'),
    (204, 'Cristo Redentor', 'Visita ao monumento'),
    (205, 'Dunas do Jalapão', 'Caminhada e contemplação');

-- ==========================================
-- TABELA 5: DESTINOS
-- ==========================================

INSERT INTO destinos
    (id_destino, cidade, estado, pais, id_passeio)
VALUES
    (301, 'Manaus', 'Amazonas', 'Brasil', 201),
    (302, 'Manaus', 'Amazonas', 'Brasil', 202),
    (303, 'Ouro Preto', 'Minas Gerais', 'Brasil', 203),
    (304, 'Rio de Janeiro', 'Rio de Janeiro', 'Brasil', 204),
    (305, 'Mateiros', 'Tocantins', 'Brasil', 205);

-- ==========================================
-- TABELA 6: DESTINO_VIA
-- Relacionamento N:N entre VIAGEM e DESTINOS
-- ==========================================

INSERT INTO destino_via
    (id_viagem, id_destino, data_inicio, data_fim)
VALUES
    (101, 301, '2027-01-11', '2027-01-19'),
    (101, 302, '2027-01-11', '2027-01-19'),
    (102, 303, '2027-02-10', '2027-02-15'),
    (103, 304, '2027-03-05', '2027-03-10'),
    (104, 305, '2027-07-01', '2027-07-08');

-- ==========================================
-- TABELA 7: PASSEIO_VIAJ
-- Relacionamento N:N entre VIAGEM e PASSEIOS
-- ==========================================

INSERT INTO passeio_viaj
    (id_viagem, id_passeio, data_inicio, data_fim, turno)
VALUES
    (101, 201, '2027-01-12', '2027-01-12', 'Manhã'),
    (101, 202, '2027-01-14', '2027-01-14', 'Manhã'),
    (102, 203, '2027-02-11', '2027-02-11', 'Tarde'),
    (103, 204, '2027-03-06', '2027-03-06', 'Manhã'),
    (104, 205, '2027-07-03', '2027-07-03', 'Tarde');

-- ==========================================
-- TABELA 8: DESPESAS
-- ==========================================

INSERT INTO despesas
    (id_despesas, nome, valor, id_viagem)
VALUES
    (401, 'Passagem aérea', 1420.00, 101),
    (402, 'Hospedagem Manaus', 1200.00, 101),
    (403, 'Transporte rodoviário', 180.00, 102),
    (404, 'Hospedagem Ouro Preto', 650.00, 102),
    (405, 'Passagem aérea', 950.00, 103),
    (406, 'Hospedagem Rio', 1100.00, 103),
    (407, 'Transporte 4x4', 850.00, 104),
    (408, 'Pousada Jalapão', 900.00, 104);

-- ==========================================
-- TABELA 9: TRANSPORTE
-- Especialização de DESPESAS
-- ==========================================

INSERT INTO transporte
    (id_despesas, tipo, data_hora_partida,
     data_hora_chegada, loc_origem,
     loc_destino, nome_empresa)
VALUES
    (401, 'Avião', '2027-01-11 08:00:00',
     '2027-01-11 11:00:00', 'Belo Horizonte',
     'Manaus', 'Azul'),

    (403, 'Ônibus', '2027-02-10 07:00:00',
     '2027-02-10 09:30:00', 'Belo Horizonte',
     'Ouro Preto', 'Viação Pássaro Verde'),

    (405, 'Avião', '2027-03-05 09:00:00',
     '2027-03-05 10:10:00', 'Belo Horizonte',
     'Rio de Janeiro', 'GOL'),

    (407, '4x4', '2027-07-01 08:00:00',
     '2027-07-01 14:00:00', 'Palmas',
     'Mateiros', 'Jalapão Turismo');
    
     
    
-- ==========================================
-- TABELA 10: HOSPEDAGEM
-- Especialização de DESPESAS
-- ==========================================


INSERT INTO hospedagem
    (id_despesas, nome_local, tipo,
     data_entrada, data_saida, id_destino)
VALUES
    (402, 'Hotel Saint Paul', 'Hotel',
     '2027-01-11', '2027-01-19', 301),

    (404, 'Pousada Imperial', 'Pousada',
     '2027-02-10', '2027-02-15', 303),

    (406, 'Hotel Atlântico', 'Hotel',
     '2027-03-05', '2027-03-10', 304),

    (408, 'Pousada Cerrado', 'Pousada',
     '2027-07-01', '2027-07-08', 305);

