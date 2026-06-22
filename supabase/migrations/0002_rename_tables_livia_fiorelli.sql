-- =============================================================
-- Renomeia as 4 tabelas com o prefixo livia_fiorelli_ e adapta
-- TODOS os objetos dependentes (PKs, uniques, foreign keys, índices).
-- As FKs seguem o rename por OID; aqui ajustamos também os NOMES.
-- =============================================================

-- 1) Renomear as tabelas
ALTER TABLE public.tabela_1_leads         RENAME TO livia_fiorelli_tabela_1_leads;
ALTER TABLE public.tabela_2_participacoes RENAME TO livia_fiorelli_tabela_2_participacoes;
ALTER TABLE public.tabela_3_precheckout   RENAME TO livia_fiorelli_tabela_3_precheckout;
ALTER TABLE public.tabela_4_alunos        RENAME TO livia_fiorelli_tabela_4_alunos;

-- 2) Renomear explicitamente os índices "standalone" (nomes genéricos/longos)
--    para nomes limpos e dentro do limite de 63 caracteres do Postgres.
ALTER INDEX public.idx_created_at
  RENAME TO livia_fiorelli_tabela_2_participacoes_created_at_idx;
ALTER INDEX public.idx_evento_origem
  RENAME TO livia_fiorelli_tabela_2_participacoes_evento_origem_idx;
ALTER INDEX public.tabela_2_participacoes_lead_fk_evento_origem_idx
  RENAME TO livia_fiorelli_tabela_2_participacoes_lead_evento_idx;
ALTER INDEX public.tabela_3_precheckout_lead_fk_produto_evento_origem_idx
  RENAME TO livia_fiorelli_tabela_3_precheckout_lead_produto_evento_idx;

-- 3) Prefixar todas as CONSTRAINTS restantes (PK, UNIQUE, FK) com livia_fiorelli_
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT rel.relname AS tbl, con.conname
    FROM pg_constraint con
    JOIN pg_class rel ON rel.oid = con.conrelid
    JOIN pg_namespace ns ON ns.oid = rel.relnamespace
    WHERE ns.nspname = 'public'
      AND rel.relname LIKE 'livia_fiorelli_%'
      AND con.conname NOT LIKE 'livia_fiorelli_%'
  LOOP
    EXECUTE format('ALTER TABLE public.%I RENAME CONSTRAINT %I TO %I',
                   r.tbl, r.conname, 'livia_fiorelli_' || r.conname);
  END LOOP;
END $$;

-- 4) Prefixar quaisquer ÍNDICES restantes (pkey/unique) com livia_fiorelli_
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT i.relname AS idxname
    FROM pg_class i
    JOIN pg_index ix ON ix.indexrelid = i.oid
    JOIN pg_class t  ON t.oid = ix.indrelid
    JOIN pg_namespace ns ON ns.oid = i.relnamespace
    WHERE ns.nspname = 'public'
      AND t.relname LIKE 'livia_fiorelli_%'
      AND i.relname NOT LIKE 'livia_fiorelli_%'
  LOOP
    EXECUTE format('ALTER INDEX public.%I RENAME TO %I',
                   r.idxname, 'livia_fiorelli_' || r.idxname);
  END LOOP;
END $$;
