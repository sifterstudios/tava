-- Tava core schema
create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text,
  category text not null,
  target_bpm int,
  target_duration_ms bigint,
  source text,
  tags text[] not null default '{}',
  is_favorite boolean not null default false,
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.practice_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  start_time timestamptz not null,
  end_time timestamptz,
  duration_ms bigint not null default 0,
  is_active boolean not null default true,
  energy_level int,
  focus_level int,
  sleep_quality int,
  had_alcohol boolean,
  mood_notes text,
  weather_condition text,
  weather_temperature double precision,
  weather_humidity int,
  weather_pressure double precision,
  weather_recorded_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.exercise_records (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.practice_sessions(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  exercise_id uuid references public.exercises(id) on delete set null,
  name text not null,
  bpm int,
  duration_ms bigint not null default 0,
  rating int,
  notes text,
  created_at timestamptz not null default now()
);

create table if not exists public.metronome_presets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  bpm int not null,
  beats_per_measure int not null default 4,
  beat_unit int not null default 4,
  accent_pattern int[] not null default '{2,1,1,1}',
  sound_type text not null default 'click',
  is_favorite boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.bpm_samples (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  recorded_on date not null,
  average_bpm double precision not null,
  sample_count int not null default 1,
  created_at timestamptz not null default now(),
  unique (user_id, recorded_on)
);

create index if not exists exercises_user_id_idx on public.exercises(user_id);
create index if not exists practice_sessions_user_id_idx on public.practice_sessions(user_id);
create index if not exists exercise_records_session_id_idx on public.exercise_records(session_id);
create index if not exists metronome_presets_user_id_idx on public.metronome_presets(user_id);

alter table public.profiles enable row level security;
alter table public.exercises enable row level security;
alter table public.practice_sessions enable row level security;
alter table public.exercise_records enable row level security;
alter table public.metronome_presets enable row level security;
alter table public.bpm_samples enable row level security;

create policy "profiles_own" on public.profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);
create policy "exercises_own" on public.exercises
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "sessions_own" on public.practice_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "records_own" on public.exercise_records
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "presets_own" on public.metronome_presets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "bpm_own" on public.bpm_samples
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
