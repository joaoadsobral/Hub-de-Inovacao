-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.profiles (
  id uuid NOT NULL,
  name text NOT NULL,
  role text NOT NULL CHECK (role = ANY (ARRAY['researcher'::text, 'gov'::text, 'org'::text, 'investidor'::text])),
  institution text,
  avatar text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.research_projects (
  id bigint NOT NULL DEFAULT nextval('research_projects_id_seq'::regclass),
  title text NOT NULL,
  institution text NOT NULL,
  area text NOT NULL,
  type text NOT NULL,
  keywords ARRAY DEFAULT '{}'::text[],
  ods ARRAY DEFAULT '{}'::integer[],
  status text NOT NULL DEFAULT 'draft'::text CHECK (status = ANY (ARRAY['draft'::text, 'review'::text, 'published'::text, 'hidden'::text])),
  researcher_id uuid NOT NULL,
  abstract text,
  simplified text,
  year integer NOT NULL DEFAULT EXTRACT(year FROM now()),
  views integer DEFAULT 0,
  connections_count integer DEFAULT 0,
  tags ARRAY DEFAULT '{}'::text[],
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT research_projects_pkey PRIMARY KEY (id),
  CONSTRAINT research_projects_researcher_id_fkey FOREIGN KEY (researcher_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.conversations (
  id bigint NOT NULL DEFAULT nextval('conversations_id_seq'::regclass),
  project_id bigint NOT NULL,
  org_user_id uuid NOT NULL,
  researcher_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT conversations_pkey PRIMARY KEY (id),
  CONSTRAINT conversations_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.research_projects(id),
  CONSTRAINT conversations_org_user_id_fkey FOREIGN KEY (org_user_id) REFERENCES public.profiles(id),
  CONSTRAINT conversations_researcher_id_fkey FOREIGN KEY (researcher_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.messages (
  id bigint NOT NULL DEFAULT nextval('messages_id_seq'::regclass),
  conversation_id bigint NOT NULL,
  sender_id uuid NOT NULL,
  text text NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id)
);