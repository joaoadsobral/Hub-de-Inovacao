# Manual de Instalacao - Hub de Inovacao e Pesquisa de Recife

Este manual descreve como instalar, configurar e publicar o sistema que esta no zip `hub-inovacao-main.zip`.

## 1. Visao geral

O projeto e uma SPA em React + Vite com backend no Supabase.

Componentes principais:
- Frontend: React 19 + Vite
- Backend: Supabase (PostgreSQL, Auth e Realtime)
- Funcao de IA: Supabase Edge Function `simplify`
- Deploy do frontend: Vercel

## 2. Pre-requisitos

Antes de comecar, instale:
- Node.js 20 ou superior
- npm
- Conta no Supabase
- Conta no Vercel
- Git

Se quiser trabalhar a partir do zip, extraia o conteudo e abra a pasta do projeto principal:
- `hub-inovacao-main/hub-inovacao`

## 3. Instalar o projeto localmente

1. Entre na pasta do projeto:

```bash
cd hub-inovacao-main/hub-inovacao
```

2. Instale as dependencias:

```bash
npm install
```

3. Rode o projeto em modo desenvolvimento:

```bash
npm run dev
```

4. Abra o endereco exibido pelo Vite, normalmente:

```bash
http://localhost:5173
```

## 4. Configurar o Supabase

### 4.1 Criar o projeto

Crie um novo projeto no Supabase e escolha a regiao mais proxima do publico alvo. O README do projeto aponta `sa-east-1` como referencia.

### 4.2 Aplicar o schema

No painel do Supabase, abra o **SQL Editor** e execute o conteudo do arquivo:

```sql
supabase/schema.sql
```

Esse schema cria as tabelas e politicas principais:
- `profiles`
- `research_projects`
- `conversations`
- `messages`

Tambem habilita RLS e Realtime nas tabelas de chat.

### 4.3 Configurar autenticacao

No Supabase Auth, mantenha o login por email habilitado. O projeto usa o Auth do Supabase para controlar perfis e acesso por perfil:
- `researcher`
- `gov`
- `org`

### 4.4 Configurar a funcao de IA

O sistema usa a edge function `simplify` para transformar o texto tecnico em linguagem mais simples.

Publique a funcao e configure o segredo do Groq:

```bash
supabase functions deploy simplify --project-ref <project-id>
supabase secrets set GROQ_API_KEY=gsk_...
```

## 5. Variaveis de ambiente

O projeto usa estas variaveis no frontend:

```env
VITE_SUPABASE_URL=https://<project-id>.supabase.co
VITE_SUPABASE_ANON_KEY=seu_anon_key_aqui
```

Opcionalmente, se houver acesso no backend ou em scripts internos, mantenha a chave de service role fora do browser:

```env
SUPABASE_SERVICE_ROLE_KEY=sua_service_role_key
```

### 5.1 Arquivo local `.env`

Na raiz do frontend, crie um arquivo `.env` com as variaveis acima.

### 5.2 Variaveis na Vercel

Na Vercel, adicione as mesmas variaveis no painel do projeto:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 6. Deploy na Vercel

1. Envie o codigo para um repositorio GitHub.
2. No painel da Vercel, clique em **New Project**.
3. Conecte o repositorio do sistema.
4. Confirme o preset como **Vite**.
5. Configure:
   - Build Command: `npm run build`
   - Output Directory: `dist`
6. Adicione as variaveis de ambiente.
7. Clique em **Deploy**.

A partir dai, todo push na branch principal atualiza o deploy automaticamente.

## 7. Checklist final

Antes de considerar a instalacao pronta, confira:
- O projeto abre localmente com `npm run dev`
- O schema do Supabase foi aplicado sem erros
- As variaveis `.env` estao preenchidas
- A funcao `simplify` foi publicada no Supabase
- A Vercel esta apontando para o repositorio correto
- As variaveis de ambiente foram configuradas na Vercel

## 8. Estrutura relevante do projeto

Arquivos importantes para a configuracao:
- `src/lib/supabase.js`
- `supabase/schema.sql`
- `supabase/functions/simplify/index.ts`
- `.env.example`
- `package.json`

## 9. Observacao importante

Nunca exponha `SUPABASE_SERVICE_ROLE_KEY` no frontend. Use essa chave apenas em ambiente seguro, como scripts de backend ou configuracoes privadas do Supabase.