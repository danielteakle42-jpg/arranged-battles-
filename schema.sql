-- Platinum Pulse x Void — Arranged Battle Booking
-- Run this whole file once in your Supabase project's SQL editor
-- (Supabase dashboard -> SQL Editor -> New query -> paste -> Run)

create table if not exists app_state (
  id int primary key default 1,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Seed the single row the app reads/writes.
-- Safe to run more than once: does nothing if row 1 already exists.
insert into app_state (id, data)
values (1, '{"bookings":{},"matches":[],"roster":[],"avatars":{}}'::jsonb)
on conflict (id) do nothing;

-- Keep updated_at current on every write (optional, handy for debugging).
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists app_state_set_updated_at on app_state;
create trigger app_state_set_updated_at
before update on app_state
for each row execute function set_updated_at();

-- Row Level Security: the app connects with the public "anon" key,
-- so these policies control who can read/write.
alter table app_state enable row level security;

drop policy if exists "public read" on app_state;
create policy "public read" on app_state
  for select using (true);

drop policy if exists "public write" on app_state;
create policy "public write" on app_state
  for update using (true);

-- NOTE: "public write" means anyone with your anon key (i.e. anyone who
-- has the app's URL, since the key is visible in the page source) can
-- write to app_state. That's fine for a small agency tool nobody outside
-- the group has the link to. If you ever want to lock it down further,
-- swap this for Supabase Auth and restrict the policy to authenticated
-- users, or to a specific role you check in the policy.
