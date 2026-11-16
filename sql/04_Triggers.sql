-- ==========================================
-- PROJETO: EXPEDIÇÕES TURÍSTICAS
-- ARQUIVO: 04_Triggers.sql
-- RN05: Validação do período de hospedagem
-- ==========================================

CREATE OR REPLACE FUNCTION validar_periodo_hospedagem()
RETURNS TRIGGER AS $$
DECLARE
    inicio_viagem DATE;
    fim_viagem DATE;
BEGIN
    SELECT v.data_inicio, v.data_fim
    INTO inicio_viagem, fim_viagem
    FROM viagem v
    JOIN despesas d
        ON d.id_viagem = v.id_viagem
    WHERE d.id_despesas = NEW.id_despesas;

    IF NEW.data_entrada < inicio_viagem
       OR NEW.data_saida > fim_viagem THEN
        RAISE EXCEPTION
            'Hospedagem fora do período da viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- RN05: Trigger para validar hospedagens
-- ==========================================

CREATE TRIGGER trg_validar_periodo_hospedagem
BEFORE INSERT OR UPDATE
ON hospedagem
FOR EACH ROW
EXECUTE FUNCTION validar_periodo_hospedagem();



-- ==========================================
-- RN05: Validar transporte no período da viagem
-- ==========================================

CREATE OR REPLACE FUNCTION validar_periodo_transporte()
RETURNS TRIGGER AS $$
DECLARE
    inicio_viagem DATE;
    fim_viagem DATE;
BEGIN
    SELECT v.data_inicio, v.data_fim
    INTO inicio_viagem, fim_viagem
    FROM viagem v
    JOIN despesas d
        ON d.id_viagem = v.id_viagem
    WHERE d.id_despesas = NEW.id_despesas;

    IF NEW.data_hora_partida::DATE < inicio_viagem
       OR NEW.data_hora_chegada::DATE > fim_viagem THEN
        RAISE EXCEPTION
            'Transporte fora do período da viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ==========================================
-- RN05: Trigger para validar transportes
-- ==========================================

CREATE TRIGGER trg_validar_periodo_transporte
BEFORE INSERT OR UPDATE
ON transporte
FOR EACH ROW
EXECUTE FUNCTION validar_periodo_transporte();


-- ==========================================
-- RN05: Testar a trigger do transporte
-- ==========================================

DO $$
BEGIN
    UPDATE transporte
    SET data_hora_chegada = '2027-01-20 15:00:00'
    WHERE id_despesas = (
        SELECT t.id_despesas
        FROM transporte t
        JOIN despesas d
            ON t.id_despesas = d.id_despesas
        WHERE d.id_viagem = 101
        LIMIT 1
    );

    RAISE EXCEPTION 'Teste encerrado sem salvar alterações';
END;
$$;


-- ==========================================
-- RN05: Validação do período de transporte
-- ==========================================

CREATE OR REPLACE FUNCTION validar_periodo_transporte()
RETURNS TRIGGER AS $$
DECLARE
    inicio_viagem DATE;
    fim_viagem DATE;
BEGIN
    SELECT v.data_inicio, v.data_fim
    INTO inicio_viagem, fim_viagem
    FROM viagem v
    JOIN despesas d
        ON d.id_viagem = v.id_viagem
    WHERE d.id_despesas = NEW.id_despesas;

    IF NEW.data_hora_partida::DATE < inicio_viagem
       OR NEW.data_hora_chegada::DATE > fim_viagem THEN
        RAISE EXCEPTION
            'Transporte fora do período da viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ==========================================
-- RN05: Trigger para validar transportes
-- ==========================================

CREATE TRIGGER trg_validar_periodo_transporte
BEFORE INSERT OR UPDATE
ON transporte
FOR EACH ROW
EXECUTE FUNCTION validar_periodo_transporte();



SELECT
    table_name,
    column_name,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND (
      (table_name = 'hospedagem'
       AND column_name IN ('data_entrada', 'data_saida'))
      OR
      (table_name = 'transporte'
       AND column_name IN ('data_hora_partida', 'data_hora_chegada'))
  )
ORDER BY table_name, column_name;


-- RN05: Tornar as datas da hospedagem obrigatórias

ALTER TABLE hospedagem
    ALTER COLUMN data_entrada SET NOT NULL,
    ALTER COLUMN data_saida SET NOT NULL;




-- ==========================================
-- RN05: Validar alterações nas datas da viagem
-- ==========================================

-- ==========================================
-- RN05 e RN07: Validar alterações no período
-- da viagem (hospedagem, transporte e passeios)
-- ==========================================

CREATE OR REPLACE FUNCTION validar_alteracao_periodo_viagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar hospedagens
    IF EXISTS (
        SELECT 1
        FROM despesas d
        JOIN hospedagem h
            ON h.id_despesas = d.id_despesas
        WHERE d.id_viagem = NEW.id_viagem
          AND (
              h.data_entrada < NEW.data_inicio
              OR h.data_saida > NEW.data_fim
          )
    ) THEN
        RAISE EXCEPTION
            'Alteração inválida: hospedagem fora do período da viagem';
    END IF;

    -- Verificar transportes
    IF EXISTS (
        SELECT 1
        FROM despesas d
        JOIN transporte t
            ON t.id_despesas = d.id_despesas
        WHERE d.id_viagem = NEW.id_viagem
          AND (
              t.data_hora_partida::DATE < NEW.data_inicio
              OR t.data_hora_chegada::DATE > NEW.data_fim
          )
    ) THEN
        RAISE EXCEPTION
            'Alteração inválida: transporte fora do período da viagem';
    END IF;

    -- Verificar passeios
    IF EXISTS (
        SELECT 1
        FROM passeio_viaj pv
        WHERE pv.id_viagem = NEW.id_viagem
          AND (
              pv.data_inicio < NEW.data_inicio
              OR pv.data_inicio > NEW.data_fim
              OR pv.data_fim > NEW.data_fim
          )
    ) THEN
        RAISE EXCEPTION
            'Alteração inválida: passeio fora do período da viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- ==========================================
-- RN05: Trigger para validar alterações
-- no período da viagem
-- ==========================================

CREATE TRIGGER trg_validar_alteracao_periodo_viagem
BEFORE UPDATE OF data_inicio, data_fim
ON viagem
FOR EACH ROW
EXECUTE FUNCTION validar_alteracao_periodo_viagem();


-- ==========================================
-- RN05: Trigger para validar transferências
-- de despesas entre viagens
-- ==========================================

CREATE TRIGGER trg_validar_viagem_despesa
BEFORE UPDATE OF id_viagem
ON despesas
FOR EACH ROW
EXECUTE FUNCTION validar_viagem_despesa();

-- ==========================================
-- RN05: Validar transferência de despesas
-- entre viagens
-- ==========================================


-- ==========================================
-- RN05 e RN06: Validar transferência de despesas
-- entre viagens
-- ==========================================

CREATE OR REPLACE FUNCTION validar_viagem_despesa()
RETURNS TRIGGER AS $$
DECLARE
    inicio_viagem DATE;
    fim_viagem DATE;
BEGIN
    -- Identificar o período da nova viagem
    SELECT data_inicio, data_fim
    INTO inicio_viagem, fim_viagem
    FROM viagem
    WHERE id_viagem = NEW.id_viagem;

    -- ==========================================
    -- RN05: Validar período da hospedagem
    -- ==========================================

    IF EXISTS (
        SELECT 1
        FROM hospedagem h
        WHERE h.id_despesas = NEW.id_despesas
          AND (
              h.data_entrada < inicio_viagem
              OR h.data_saida > fim_viagem
          )
    ) THEN
        RAISE EXCEPTION
            'Hospedagem incompatível com o período da nova viagem';
    END IF;

    -- ==========================================
    -- RN05: Validar período do transporte
    -- ==========================================

    IF EXISTS (
        SELECT 1
        FROM transporte t
        WHERE t.id_despesas = NEW.id_despesas
          AND (
              t.data_hora_partida::DATE < inicio_viagem
              OR t.data_hora_chegada::DATE > fim_viagem
          )
    ) THEN
        RAISE EXCEPTION
            'Transporte incompatível com o período da nova viagem';
    END IF;

    -- ==========================================
    -- RN06: Validar destino da hospedagem
    -- ==========================================

    IF EXISTS (
        SELECT 1
        FROM hospedagem h
        WHERE h.id_despesas = NEW.id_despesas
          AND NOT EXISTS (
              SELECT 1
              FROM destino_via dv
              WHERE dv.id_viagem = NEW.id_viagem
                AND dv.id_destino = h.id_destino
          )
    ) THEN
        RAISE EXCEPTION
            'RN06: Destino da hospedagem não pertence à nova viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- ==========================================
-- RN05: Trigger para validar transferências
-- de despesas entre viagens
-- ==========================================

CREATE TRIGGER trg_validar_viagem_despesa
BEFORE UPDATE OF id_viagem
ON despesas
FOR EACH ROW
EXECUTE FUNCTION validar_viagem_despesa();


-- ==========================================
-- RN07: Validar datas dos passeios
-- ==========================================

CREATE OR REPLACE FUNCTION validar_periodo_passeio()
RETURNS TRIGGER AS $$
DECLARE
    inicio_viagem DATE;
    fim_viagem DATE;
BEGIN
    SELECT data_inicio, data_fim
    INTO inicio_viagem, fim_viagem
    FROM viagem
    WHERE id_viagem = NEW.id_viagem;

    IF NEW.data_inicio < inicio_viagem
       OR NEW.data_inicio > fim_viagem
       OR (
           NEW.data_fim IS NOT NULL
           AND (
               NEW.data_fim < NEW.data_inicio
               OR NEW.data_fim > fim_viagem
           )
       )
    THEN
        RAISE EXCEPTION
            'Passeio fora do período permitido da viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ==========================================
-- RN07: Trigger para validar datas dos passeios
-- ==========================================

CREATE TRIGGER trg_validar_periodo_passeio
BEFORE INSERT OR UPDATE
ON passeio_viaj
FOR EACH ROW
EXECUTE FUNCTION validar_periodo_passeio();



-- ==========================================
-- RN06: Validar destino da hospedagem
-- ==========================================

CREATE OR REPLACE FUNCTION validar_destino_hospedagem()
RETURNS TRIGGER AS $$
DECLARE
    viagem_hospedagem INTEGER;
BEGIN
    SELECT id_viagem
    INTO viagem_hospedagem
    FROM despesas
    WHERE id_despesas = NEW.id_despesas;

    IF NOT EXISTS (
        SELECT 1
        FROM destino_via
        WHERE id_viagem = viagem_hospedagem
          AND id_destino = NEW.id_destino
    ) THEN
        RAISE EXCEPTION
            'RN06: Destino da hospedagem não pertence à viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validar_destino_hospedagem
BEFORE INSERT OR UPDATE
ON hospedagem
FOR EACH ROW
EXECUTE FUNCTION validar_destino_hospedagem();



-- ==========================================
-- RN06: Validar destino do passeio na viagem
-- ==========================================

CREATE OR REPLACE FUNCTION validar_destino_passeio()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM destinos d
        JOIN destino_via dv
            ON dv.id_destino = d.id_destino
        WHERE d.id_passeio = NEW.id_passeio
          AND dv.id_viagem = NEW.id_viagem
    ) THEN
        RAISE EXCEPTION
            'RN06: Passeio não possui destino associado à viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ==========================================
-- RN06: Trigger para validar destino do passeio
-- ==========================================

CREATE TRIGGER trg_validar_destino_passeio
BEFORE INSERT OR UPDATE
ON passeio_viaj
FOR EACH ROW
EXECUTE FUNCTION validar_destino_passeio();



-- ==========================================
-- RN06: Proteger associações entre viagens
-- e destinos
-- ==========================================

CREATE OR REPLACE FUNCTION proteger_destino_viagem()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar hospedagens vinculadas ao destino
    IF EXISTS (
        SELECT 1
        FROM hospedagem h
        JOIN despesas de
            ON de.id_despesas = h.id_despesas
        WHERE de.id_viagem = OLD.id_viagem
          AND h.id_destino = OLD.id_destino
    ) THEN
        RAISE EXCEPTION
            'RN06: Destino utilizado por hospedagem da viagem';
    END IF;

    -- Verificar passeios que perderiam seu último destino válido
    IF EXISTS (
        SELECT 1
        FROM passeio_viaj pv
        JOIN destinos d
            ON d.id_passeio = pv.id_passeio
        WHERE pv.id_viagem = OLD.id_viagem
          AND d.id_destino = OLD.id_destino
          AND NOT EXISTS (
              SELECT 1
              FROM destinos d2
              JOIN destino_via dv2
                  ON dv2.id_destino = d2.id_destino
              WHERE d2.id_passeio = pv.id_passeio
                AND dv2.id_viagem = pv.id_viagem
                AND dv2.id_destino <> OLD.id_destino
          )
    ) THEN
        RAISE EXCEPTION
            'RN06: Destino necessário para passeio da viagem';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- ==========================================
-- RN06: Trigger de proteção dos destinos
-- ==========================================

CREATE TRIGGER trg_proteger_destino_viagem
BEFORE DELETE OR UPDATE OF id_viagem, id_destino
ON destino_via
FOR EACH ROW
EXECUTE FUNCTION proteger_destino_viagem();


-- ==========================================
-- RN06: Proteger alteração do passeio
-- associado a um destino
-- ==========================================

CREATE OR REPLACE FUNCTION proteger_passeio_destino()
RETURNS TRIGGER AS $$
BEGIN
    -- Permitir quando o passeio não for alterado
    IF NEW.id_passeio IS NOT DISTINCT FROM OLD.id_passeio THEN
        RETURN NEW;
    END IF;

    -- Impedir que uma viagem perca o último
    -- destino válido de um passeio programado
    IF EXISTS (
        SELECT 1
        FROM destino_via dv
        JOIN passeio_viaj pv
            ON pv.id_viagem = dv.id_viagem
           AND pv.id_passeio = OLD.id_passeio
        WHERE dv.id_destino = OLD.id_destino
          AND NOT EXISTS (
              SELECT 1
              FROM destinos d2
              JOIN destino_via dv2
                  ON dv2.id_destino = d2.id_destino
              WHERE d2.id_passeio = OLD.id_passeio
                AND dv2.id_viagem = dv.id_viagem
                AND d2.id_destino <> OLD.id_destino
          )
    ) THEN
        RAISE EXCEPTION
            'RN06: Alteração inválida. Passeio utilizado por uma viagem';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==========================================
-- RN06: Trigger para proteger passeios
-- associados aos destinos
-- ==========================================

CREATE TRIGGER trg_proteger_passeio_destino
BEFORE UPDATE OF id_passeio
ON destinos
FOR EACH ROW
EXECUTE FUNCTION proteger_passeio_destino();

