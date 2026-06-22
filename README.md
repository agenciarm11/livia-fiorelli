# Lívia Fiorelli — Supabase schema

Backup da estrutura do banco do projeto **Lívia Fiorelli** (Supabase).

- **Project ref:** `gdresjdzpfrdmxgrpkvw`
- **URL:** https://gdresjdzpfrdmxgrpkvw.supabase.co
- **Conteúdo:** apenas o schema (`public`) — **sem dados**.
- **Origem:** estrutura clonada integralmente do projeto BIORESSONÂNCIA.

## 🚀 Copiar em 30 segundos (jeito mais rápido)

1. Crie um **projeto novo** no [Supabase](https://supabase.com/dashboard).
2. Abra **SQL Editor → New query**.
3. Abra o arquivo **[`schema_completo.sql`](schema_completo.sql)**, copie tudo, cole e clique **Run**.

Pronto — todas as tabelas, índices, chaves e RLS criados de uma vez, na ordem certa. Sem instalar nada.

> 📘 Quer o caminho profissional (Supabase CLI) ou conectar Supabase ↔ GitHub? Veja o **[INSTRUCOES.md](INSTRUCOES.md)**.

## Estrutura

| Tabela | Descrição |
|---|---|
| `livia_fiorelli_tabela_1_leads` | Central de leads (PK `lead_id`; `whatsapp` e `cpf` únicos) |
| `livia_fiorelli_tabela_2_participacoes` | Participações dos leads (FK → `livia_fiorelli_tabela_1_leads`) |
| `livia_fiorelli_tabela_3_precheckout` | Leads que preencheram o pré-checkout (FK → `livia_fiorelli_tabela_1_leads`) |
| `livia_fiorelli_tabela_4_alunos` | Compradores de cursos (FK → `livia_fiorelli_tabela_1_leads`) |

As 3 foreign keys usam `ON DELETE CASCADE`. RLS está habilitado nas 4 tabelas (sem policies).

> As tabelas usam o prefixo `livia_fiorelli_` (aplicado pela migration `0002_rename_tables_livia_fiorelli.sql`). Aplique as migrations em ordem (`0001` → `0002` → `0003`) para chegar ao estado final.

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
