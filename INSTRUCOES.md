# Guia completo — como usar este repositório

Este repositório guarda a **estrutura (schema)** de um projeto Supabase — **sem dados**.
Aqui você aprende a:

- **Parte A** → criar uma **cópia deste projeto** dentro do **seu** Supabase
- **Parte B** → **conectar o seu Supabase ao seu GitHub**, para que mudanças futuras de schema sejam versionadas e aplicadas automaticamente

> Repositório: `agenciarm11/livia-fiorelli`
> Projeto de origem (Supabase ref): `gdresjdzpfrdmxgrpkvw`

---

## Pré-requisitos

- Uma conta no **Supabase** → https://supabase.com
- Uma conta no **GitHub** (a dona deste repositório)
- Para o caminho via terminal: o **Supabase CLI** instalado → https://supabase.com/docs/guides/cli
  (e, opcionalmente, o **Git**)

---

## Parte A — Criar uma cópia deste projeto no seu Supabase

Há dois caminhos. O **Método 1** é o mais rápido (não instala nada). O **Método 2** é o profissional/reproduzível.

### Método 1 — SQL Editor (mais rápido)

1. Acesse https://supabase.com/dashboard e clique em **New project**. Dê um nome, escolha a região (ex.: *South America (São Paulo)*) e **guarde a senha do banco**.
2. Espere o projeto subir. No menu lateral, abra **SQL Editor** → **New query**.
3. Neste repositório, abra o arquivo **`supabase/migrations/0001_init_schema.sql`** e **copie todo o conteúdo**.
4. **Cole** no SQL Editor e clique em **Run** (ou `Ctrl/Cmd + Enter`).
5. Pronto. Vá em **Table Editor** e confirme as 4 tabelas: `livia_fiorelli_tabela_1_leads`, `livia_fiorelli_tabela_2_participacoes`, `livia_fiorelli_tabela_3_precheckout`, `livia_fiorelli_tabela_4_alunos`.

> ℹ️ Pelo SQL Editor, rode **na ordem**: `0001_init_schema.sql` (cria as tabelas) → `0002_rename_tables_livia_fiorelli.sql` (aplica o prefixo `livia_fiorelli_`) → `0003_update_comments.sql` (ajusta os comentários).

### Método 2 — Supabase CLI (recomendado)

1. Baixe o repositório: botão verde **Code → Download ZIP**, ou `git clone https://github.com/agenciarm11/livia-fiorelli.git`
2. Abra o terminal **dentro da pasta** do repositório e faça login:
   ```bash
   supabase login        # abre o navegador para autenticar
   ```
3. Crie um projeto novo no dashboard (ou use um vazio) e copie o **Reference ID** em **Project Settings → General**.
4. Conecte a pasta local ao seu projeto:
   ```bash
   supabase link --project-ref SEU_PROJECT_REF
   ```
5. Aplique as migrations (isso cria as tabelas no seu banco):
   ```bash
   supabase db push
   ```
6. Confira no **Table Editor**.

> O schema usa apenas funções nativas do Postgres (`gen_random_uuid()`, `now()`). **Não** precisa de nenhuma extensão extra.

---

## Parte B — Conectar o seu Supabase ao seu GitHub

Isso liga o seu projeto Supabase a este repositório usando o recurso **Branching / GitHub Integration**. A partir daí, todo arquivo novo em `supabase/migrations/` enviado ao GitHub é aplicado automaticamente no banco.

### Antes de começar
- O repositório precisa ter a pasta **`supabase/`** com **`config.toml`** e **`migrations/`** — este repositório **já vem com elas**.
- Você precisa ser **dono/admin** do projeto Supabase **e** deste repositório no GitHub.

### Passo a passo (no Dashboard do Supabase)

1. Abra o seu projeto em https://supabase.com/dashboard
2. Vá em **Project Settings → Integrations**
3. Em **GitHub Integration**, clique **Authorize GitHub**
4. Na tela do GitHub, clique **Authorize Supabase** e **instale o app** na conta/repositório desejado
5. De volta ao Supabase, **escolha o repositório** a conectar (`agenciarm11/livia-fiorelli`)
6. No campo **Working directory**, digite **`.`** (a pasta `supabase/` está na raiz do repositório)
7. *(Opcional)* Ative **Automatic branching** para espelhar branches do GitHub em branches do Supabase
8. Clique em **Enable integration**

### Como funciona depois de conectado

- **Push na branch de produção** (normalmente `main`) → o Supabase roda as migrations novas no banco de **produção**.
- **Abriu um Pull Request** → o Supabase cria um **Preview Branch** (um banco temporário isolado) com as mudanças e comenta o status no PR. Ao **mergear**, as migrations vão para produção.
- **Para registrar uma mudança futura de schema:** crie um arquivo novo em `supabase/migrations/` (ex.: `0002_nova_coluna.sql`), faça `commit` e `push`.

> 💡 Para capturar o estado atual de um banco **já existente** como migration, rode `supabase db pull` (gera o SQL a partir do banco) e comite o arquivo gerado.

---

## Estrutura deste repositório

```
supabase/
  config.toml               # configuração do projeto (CLI + integração GitHub)
  migrations/
    0001_init_schema.sql                    # cria as 4 tabelas, FKs (ON DELETE CASCADE), índices e RLS
    0002_rename_tables_livia_fiorelli.sql   # aplica o prefixo livia_fiorelli_ em tabelas, constraints e índices
    0003_update_comments.sql                # ajusta os comentários das tabelas (contexto Lívia Fiorelli)
README.md
INSTRUCOES.md                # este guia
```

## Segurança (importante)

- **Nunca** comite segredos: senha do banco, chave `service_role`, tokens. Versione **apenas o schema**.
- O **RLS está habilitado** nas tabelas, porém **sem policies** — apenas a chave `service_role` (back-end) acessa os dados. Antes de usar a API pública (`anon`), **crie policies** adequadas.
