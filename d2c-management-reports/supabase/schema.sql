-- D2C Management Reports: run this entire script in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  brand text,
  marketplace text not null default 'Amazon India',
  contact_name text,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.performance_entries (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  client_id uuid not null references public.clients(id) on delete cascade,
  period_start date not null,
  period_end date not null,
  sales numeric(14,2) not null default 0,
  units integer not null default 0,
  orders integer not null default 0,
  sessions integer not null default 0,
  ad_spend numeric(14,2) not null default 0,
  ad_sales numeric(14,2) not null default 0,
  returns integer not null default 0,
  notes text,
  created_at timestamptz not null default now(),
  constraint valid_period check (period_end >= period_start)
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  client_id uuid not null references public.clients(id) on delete cascade,
  title text not null,
  description text,
  cadence text not null default 'weekly' check (cadence in ('daily','weekly','monthly','one-time')),
  due_date date not null,
  status text not null default 'pending' check (status in ('pending','done')),
  priority text not null default 'medium' check (priority in ('low','medium','high')),
  created_at timestamptz not null default now(),
  completed_at timestamptz
);

create index if not exists clients_owner_idx on public.clients(owner_id);
create index if not exists performance_client_period_idx on public.performance_entries(client_id, period_start desc);
create index if not exists tasks_client_due_idx on public.tasks(client_id, due_date, status);

alter table public.clients enable row level security;
alter table public.performance_entries enable row level security;
alter table public.tasks enable row level security;

drop policy if exists "clients owner access" on public.clients;
create policy "clients owner access" on public.clients for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
drop policy if exists "performance owner access" on public.performance_entries;
create policy "performance owner access" on public.performance_entries for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
drop policy if exists "tasks owner access" on public.tasks;
create policy "tasks owner access" on public.tasks for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

-- Additional protection: a user can only attach data to a client they own.
create or replace function public.check_client_owner() returns trigger language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from public.clients c where c.id = new.client_id and c.owner_id = auth.uid()) then
    raise exception 'Client does not belong to the signed-in user';
  end if;
  return new;
end; $$;
drop trigger if exists performance_client_owner on public.performance_entries;
create trigger performance_client_owner before insert or update on public.performance_entries for each row execute function public.check_client_owner();
drop trigger if exists tasks_client_owner on public.tasks;
create trigger tasks_client_owner before insert or update on public.tasks for each row execute function public.check_client_owner();
