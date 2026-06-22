-- ============================================================================
-- Lívia Fiorelli — SCHEMA COMPLETO (estado final, em UM único arquivo)
--
-- COMO USAR (jeito mais fácil):
--   1. Crie um projeto novo no Supabase.
--   2. Abra SQL Editor > New query.
--   3. Cole TODO este arquivo e clique em Run.
--
-- Apenas estrutura (sem dados). Usa só funções nativas do Postgres
-- (gen_random_uuid(), now()) — nenhuma extensão extra necessária.
-- ============================================================================

-- Tabela 1: Central de leads
CREATE TABLE public.livia_fiorelli_tabela_1_leads (
  lead_id              uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at           timestamptz NOT NULL DEFAULT now(),
  manychat_contact_id  text,
  nome                 text,
  email                text,
  whatsapp             text        NOT NULL,
  cpf                  text,
  CONSTRAINT livia_fiorelli_tabela_1_leads_pkey PRIMARY KEY (lead_id),
  CONSTRAINT livia_fiorelli_tabela_1_leads_whatsapp_key UNIQUE (whatsapp),
  CONSTRAINT livia_fiorelli_tabela_1_leads_cpf_key UNIQUE (cpf)
);
COMMENT ON TABLE public.livia_fiorelli_tabela_1_leads IS 'Central de leads da Lívia Fiorelli';

-- Tabela 2: Participações
CREATE TABLE public.livia_fiorelli_tabela_2_participacoes (
  id_tabela_2    uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at     timestamptz NOT NULL DEFAULT now(),
  lead_fk        uuid        NOT NULL,
  evento_origem  text        NOT NULL,
  CONSTRAINT livia_fiorelli_tabela_2_participacoes_pkey PRIMARY KEY (id_tabela_2),
  CONSTRAINT livia_fiorelli_tabela_2_participacoes_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.livia_fiorelli_tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.livia_fiorelli_tabela_2_participacoes IS 'Participações dos leads da Lívia Fiorelli';
CREATE INDEX livia_fiorelli_tabela_2_participacoes_created_at_idx
  ON public.livia_fiorelli_tabela_2_participacoes USING btree (created_at);
CREATE INDEX livia_fiorelli_tabela_2_participacoes_evento_origem_idx
  ON public.livia_fiorelli_tabela_2_participacoes USING btree (evento_origem);
CREATE UNIQUE INDEX livia_fiorelli_tabela_2_participacoes_lead_evento_idx
  ON public.livia_fiorelli_tabela_2_participacoes USING btree (lead_fk, evento_origem);

-- Tabela 3: Pré-checkout
CREATE TABLE public.livia_fiorelli_tabela_3_precheckout (
  id_tabela_3    uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at     timestamptz NOT NULL DEFAULT now(),
  lead_fk        uuid        NOT NULL,
  produto        text        NOT NULL,
  evento_origem  text        NOT NULL,
  CONSTRAINT livia_fiorelli_tabela_3_precheckout_pkey PRIMARY KEY (id_tabela_3),
  CONSTRAINT livia_fiorelli_tabela_3_precheckout_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.livia_fiorelli_tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.livia_fiorelli_tabela_3_precheckout IS 'Leads da Lívia Fiorelli que preencheram o precheckout';
CREATE UNIQUE INDEX livia_fiorelli_tabela_3_precheckout_lead_produto_evento_idx
  ON public.livia_fiorelli_tabela_3_precheckout USING btree (lead_fk, produto, evento_origem);

-- Tabela 4: Alunos (compradores)
CREATE TABLE public.livia_fiorelli_tabela_4_alunos (
  id_compra           uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at          timestamptz NOT NULL DEFAULT now(),
  lead_fk             uuid        NOT NULL,
  evento_origem       text        NOT NULL,
  codigo_transacao    text        NOT NULL,
  nome_produto        text        NOT NULL,
  forma_de_pagamento  text        NOT NULL,
  moeda               text        NOT NULL,
  valor               numeric     NOT NULL,
  CONSTRAINT livia_fiorelli_tabela_4_alunos_pkey PRIMARY KEY (id_compra),
  CONSTRAINT livia_fiorelli_tabela_4_alunos_codigo_transacao_key UNIQUE (codigo_transacao),
  CONSTRAINT livia_fiorelli_tabela_4_alunos_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.livia_fiorelli_tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.livia_fiorelli_tabela_4_alunos IS 'Compradores de cursos da Lívia Fiorelli';

-- Row Level Security (habilitado, sem policies)
ALTER TABLE public.livia_fiorelli_tabela_1_leads         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.livia_fiorelli_tabela_2_participacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.livia_fiorelli_tabela_3_precheckout   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.livia_fiorelli_tabela_4_alunos        ENABLE ROW LEVEL SECURITY;
