# Lívia Fiorelli — Supabase schema

Backup da estrutura do banco do projeto **Lívia Fiorelli** (Supabase).

- **Project ref:** `gdresjdzpfrdmxgrpkvw`
- **URL:** https://gdresjdzpfrdmxgrpkvw.supabase.co
- **Conteúdo:** apenas o schema (`public`) — **sem dados**.
- **Origem:** estrutura clonada integralmente do projeto BIORESSONÂNCIA.

## Estrutura

| Tabela | Descrição |
|---|---|
| `tabela_1_leads` | Central de leads (PK `lead_id`; `whatsapp` e `cpf` únicos) |
| `tabela_2_participacoes` | Participações dos leads (FK → `tabela_1_leads`) |
| `tabela_3_precheckout` | Leads que preencheram o pré-checkout (FK → `tabela_1_leads`) |
| `tabela_4_alunos` | Compradores de cursos (FK → `tabela_1_leads`) |

As 3 foreign keys usam `ON DELETE CASCADE`. RLS está habilitado nas 4 tabelas (sem policies).

> Obs.: os comentários das tabelas ainda referenciam o projeto de origem ("Patrícia Domingos"), pois a estrutura foi clonada fielmente. Ajuste se desejar adequar ao contexto da Lívia.

## Como aplicar

Em um projeto Supabase novo/limpo:

```bash
# via Supabase CLI
supabase db push

# ou rode o SQL diretamente
psql "$DATABASE_URL" -f supabase/migrations/0001_init_schema.sql
```

> Requer apenas funções nativas do Postgres (`gen_random_uuid()`, `now()`) — nenhuma extensão custom.
