
-- ==========================================
-- PROJETO: EXPEDIÇÕES TURÍSTICAS
-- ARQUIVO: 03_Consultas.sql
-- Consultas e verificações das regras de negócio
-- ==========================================


-- ==========================================
-- 1. CONTAGEM DE REGISTROS DAS TABELAS
-- ==========================================

SELECT 'viajante' AS tabela, COUNT(*) AS registros FROM viajante
UNION ALL
SELECT 'viagem', COUNT(*) FROM viagem
UNION ALL
SELECT 'reserva', COUNT(*) FROM reserva
UNION ALL
SELECT 'passeios', COUNT(*) FROM passeios
UNION ALL
SELECT 'destinos', COUNT(*) FROM destinos
UNION ALL
SELECT 'destino_via', COUNT(*) FROM destino_via
UNION ALL
SELECT 'passeio_viaj', COUNT(*) FROM passeio_viaj
UNION ALL
SELECT 'despesas', COUNT(*) FROM despesas
UNION ALL
SELECT 'transporte', COUNT(*) FROM transporte
UNION ALL
SELECT 'hospedagem', COUNT(*) FROM hospedagem;


-- ==========================================
-- RN01: VERIFICAR PERÍODOS INVÁLIDOS DE VIAGENS
-- ==========================================

SELECT
    id_viagem,
    nome,
    data_inicio,
    data_fim
FROM viagem
WHERE data_fim < data_inicio;


-- ==========================================
-- RN02: CONSULTAR DESTINOS DAS VIAGENS
-- ==========================================

SELECT
    v.id_viagem,
    v.nome AS viagem,
    d.cidade,
    d.estado,
    d.pais
FROM viagem v
JOIN destino_via dv
    ON v.id_viagem = dv.id_viagem
JOIN destinos d
    ON dv.id_destino = d.id_destino
ORDER BY v.id_viagem, d.cidade;


-- RN02: Identificar viagens sem destinos

SELECT
    v.id_viagem,
    v.nome AS viagem
FROM viagem v
LEFT JOIN destino_via dv
    ON v.id_viagem = dv.id_viagem
WHERE dv.id_destino IS NULL;


-- ==========================================
-- RN03: CONSULTAR PASSEIOS AGENDADOS
-- ==========================================

SELECT
    pv.id_viagem,
    p.nome AS passeio,
    pv.data_inicio,
    pv.data_fim,
    pv.turno
FROM passeio_viaj pv
JOIN passeios p
    ON pv.id_passeio = p.id_passeio
ORDER BY pv.id_viagem, pv.data_inicio;


-- RN03: Verificar conflitos de agendamento
-- Mesmo dia e turno na mesma viagem

SELECT
    id_viagem,
    data_inicio,
    turno,
    COUNT(*) AS quantidade_passeios
FROM passeio_viaj
GROUP BY id_viagem, data_inicio, turno
HAVING COUNT(*) > 1;


-- ==========================================
-- RN04: CONTROLE DE ORÇAMENTO DAS VIAGENS
-- ==========================================

SELECT
    v.id_viagem,
    v.nome AS viagem,
    v.orcamento,
    COALESCE(SUM(d.valor), 0) AS total_despesas,
    CASE
        WHEN COALESCE(SUM(d.valor), 0) > v.orcamento
            THEN 'Orçamento excedido'
        ELSE 'Dentro do orçamento'
    END AS situacao
FROM viagem v
LEFT JOIN despesas d
    ON v.id_viagem = d.id_viagem
GROUP BY v.id_viagem, v.nome, v.orcamento
ORDER BY v.id_viagem;


-- ==========================================
-- RN05: VERIFICAR PERÍODOS INVÁLIDOS
-- DE HOSPEDAGEM
-- ==========================================

SELECT
    id_despesas,
    nome_local,
    data_entrada,
    data_saida
FROM hospedagem
WHERE data_saida <= data_entrada;


-- RN05: Hospedagens fora do período da viagem

SELECT
    v.nome AS viagem,
    h.nome_local AS hospedagem,
    v.data_inicio AS inicio_viagem,
    v.data_fim AS fim_viagem,
    h.data_entrada,
    h.data_saida
FROM hospedagem h
JOIN despesas d
    ON h.id_despesas = d.id_despesas
JOIN viagem v
    ON d.id_viagem = v.id_viagem
WHERE h.data_entrada < v.data_inicio
   OR h.data_saida > v.data_fim;


-- ==========================================
-- RN05: VERIFICAR HORÁRIOS INVÁLIDOS
-- DE TRANSPORTE
-- ==========================================

SELECT
    id_despesas,
    tipo,
    nome_empresa,
    data_hora_partida,
    data_hora_chegada
FROM transporte
WHERE data_hora_chegada <= data_hora_partida;


-- RN05: Transportes fora do período da viagem

SELECT
    v.nome AS viagem,
    t.tipo AS transporte,
    t.nome_empresa,
    v.data_inicio AS inicio_viagem,
    v.data_fim AS fim_viagem,
    t.data_hora_partida,
    t.data_hora_chegada
FROM transporte t
JOIN despesas d
    ON t.id_despesas = d.id_despesas
JOIN viagem v
    ON d.id_viagem = v.id_viagem
WHERE t.data_hora_partida::DATE < v.data_inicio
   OR t.data_hora_chegada::DATE > v.data_fim;


-- ==========================================
-- RN05: CONSULTAR HOSPEDAGENS DAS VIAGENS
-- ==========================================

SELECT
    v.id_viagem,
    v.nome AS viagem,
    v.data_inicio,
    v.data_fim,
    h.nome_local AS hospedagem,
    h.data_entrada,
    h.data_saida
FROM viagem v
JOIN despesas d
    ON d.id_viagem = v.id_viagem
JOIN hospedagem h
    ON h.id_despesas = d.id_despesas
ORDER BY v.id_viagem;
