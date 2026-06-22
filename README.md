# Lívia Fiorelli — Banco de dados (Supabase)

Estrutura pronta de um banco **Supabase** para gestão de leads e vendas.
Este repositório guarda **só a estrutura** (tabelas, chaves e índices) — **sem dados**.

---

## 🚀 Copiar para o seu Supabase (em ~30 segundos)

1. Crie um **projeto novo** em [supabase.com/dashboard](https://supabase.com/dashboard).
2. No menu lateral, abra **SQL Editor → New query**.
3. Abra o arquivo **[`schema_completo.sql`](schema_completo.sql)** aqui do repositório e **copie tudo**.
4. **Cole** no SQL Editor e clique em **Run** (ou `Ctrl/Cmd + Enter`).
5. Pronto! Vá em **Table Editor** e veja as 4 tabelas criadas. ✅

> Não precisa instalar nada. O arquivo usa só funções nativas do Postgres (`gen_random_uuid()`, `now()`).

---

## O que é criado

| Tabela | Para que serve |
|---|---|
| `livia_fiorelli_tabela_1_leads` | Central de leads (WhatsApp e CPF únicos) |
| `livia_fiorelli_tabela_2_participacoes` | Participações de cada lead |
| `livia_fiorelli_tabela_3_precheckout` | Quem chegou no pré-checkout |
| `livia_fiorelli_tabela_4_alunos` | Compradores de cursos |

As tabelas 2, 3 e 4 se ligam à `livia_fiorelli_tabela_1_leads`. O **RLS** já vem habilitado — o banco fica protegido (só o back-end, com a chave secreta, acessa os dados).

---

<details>
<summary><strong>⚙️ Opções avançadas (Supabase CLI e deploy automático via GitHub)</strong></summary>

### Recriar usando o Supabase CLI

1. Baixe o repositório (**Code → Download ZIP**, ou `git clone https://github.com/agenciarm11/livia-fiorelli.git`).
2. `supabase login`
3. Crie um projeto e copie o **Reference ID** em **Project Settings → General**.
4. `supabase link --project-ref SEU_PROJECT_REF`
5. `supabase db push`  *(aplica as migrations de `supabase/migrations/` na ordem certa: `0001` → `0002` → `0003`)*

> Pelo SQL Editor, prefira o `schema_completo.sql` — ele já junta tudo num arquivo só. As migrations separadas existem para este caminho via CLI/integração.

### Conectar o seu Supabase a este repositório (deploy automático)

No **Dashboard do Supabase**: **Project Settings → Integrations → GitHub Integration → Authorize GitHub → Authorize Supabase**, escolha este repositório, em **Working directory** coloque `.` e clique **Enable integration**.

A partir daí, toda migration nova enviada para `supabase/migrations/` é aplicada no banco automaticamente.

</details>

---

## 🔒 Segurança

- Aqui tem **só a estrutura** — nenhum dado, senha ou chave.
- **Nunca** adicione a este repositório a senha do banco, a chave `service_role` ou tokens.
- O RLS está ligado **sem policies**: a API pública (`anon`) não lê nada até você criar as policies. Crie-as antes de expor dados publicamente.
