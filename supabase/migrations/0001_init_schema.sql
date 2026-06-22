-- =============================================================
-- Supabase schema — projeto Lívia Fiorelli
-- Schema: public  |  Apenas estrutura (sem dados)
-- Estrutura clonada do projeto BIORESSONÂNCIA.
-- =============================================================

-- Tabela 1: Central de leads
CREATE TABLE public.tabela_1_leads (
  lead_id              uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at           timestamptz NOT NULL DEFAULT now(),
  manychat_contact_id  text,
  nome                 text,
  email                text,
  whatsapp             text        NOT NULL,
  cpf                  text,
  CONSTRAINT tabela_1_leads_pkey PRIMARY KEY (lead_id),
  CONSTRAINT tabela_1_leads_whatsapp_key UNIQUE (whatsapp),
  CONSTRAINT tabela_1_leads_cpf_key UNIQUE (cpf)
);
COMMENT ON TABLE public.tabela_1_leads IS 'Central de leads da Patrícia Domingos';

-- Tabela 2: Participações
CREATE TABLE public.tabela_2_participacoes (
  id_tabela_2    uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at     timestamptz NOT NULL DEFAULT now(),
  lead_fk        uuid        NOT NULL,
  evento_origem  text        NOT NULL,
  CONSTRAINT tabela_2_participacoes_pkey PRIMARY KEY (id_tabela_2),
  CONSTRAINT tabela_2_participacoes_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.tabela_2_participacoes IS 'Participações dos leads da Patrícia Domingos';
CREATE INDEX idx_created_at ON public.tabela_2_participacoes USING btree (created_at);
CREATE INDEX idx_evento_origem ON public.tabela_2_participacoes USING btree (evento_origem);
CREATE UNIQUE INDEX tabela_2_participacoes_lead_fk_evento_origem_idx
  ON public.tabela_2_participacoes USING btree (lead_fk, evento_origem);

-- Tabela 3: Pré-checkout
CREATE TABLE public.tabela_3_precheckout (
  id_tabela_3    uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at     timestamptz NOT NULL DEFAULT now(),
  lead_fk        uuid        NOT NULL,
  produto        text        NOT NULL,
  evento_origem  text        NOT NULL,
  CONSTRAINT tabela_3_precheckout_pkey PRIMARY KEY (id_tabela_3),
  CONSTRAINT tabela_3_precheckout_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.tabela_3_precheckout IS 'Leads que preencheram o precheckout';
CREATE UNIQUE INDEX tabela_3_precheckout_lead_fk_produto_evento_origem_idx
  ON public.tabela_3_precheckout USING btree (lead_fk, produto, evento_origem);

-- Tabela 4: Alunos (compradores)
CREATE TABLE public.tabela_4_alunos (
  id_compra           uuid        NOT NULL DEFAULT gen_random_uuid(),
  created_at          timestamptz NOT NULL DEFAULT now(),
  lead_fk             uuid        NOT NULL,
  evento_origem       text        NOT NULL,
  codigo_transacao    text        NOT NULL,
  nome_produto        text        NOT NULL,
  forma_de_pagamento  text        NOT NULL,
  moeda               text        NOT NULL,
  valor               numeric     NOT NULL,
  CONSTRAINT tabela_4_alunos_pkey PRIMARY KEY (id_compra),
  CONSTRAINT tabela_4_alunos_codigo_transacao_key UNIQUE (codigo_transacao),
  CONSTRAINT tabela_4_alunos_lead_fk_fkey FOREIGN KEY (lead_fk)
    REFERENCES public.tabela_1_leads (lead_id) ON DELETE CASCADE
);
COMMENT ON TABLE public.tabela_4_alunos IS 'Compradores de cursos da Patrícia Domingos';

-- Row Level Security (habilitado, sem policies — igual à origem)
ALTER TABLE public.tabela_1_leads         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tabela_2_participacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tabela_3_precheckout   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tabela_4_alunos        ENABLE ROW LEVEL SECURITY;
