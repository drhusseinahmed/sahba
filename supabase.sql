-- جدول غرف لعبة «سَحبة» — يُنفَّذ مرة واحدة في مشروع Supabase
create table if not exists public.sahba_rooms (
  code       text primary key,
  v          integer not null default 1,
  state      jsonb   not null,
  updated_at timestamptz not null default now()
);

alter table public.sahba_rooms enable row level security;

grant select, insert, update, delete on public.sahba_rooms to anon, authenticated;

drop policy if exists "sahba read"   on public.sahba_rooms;
drop policy if exists "sahba insert" on public.sahba_rooms;
drop policy if exists "sahba update" on public.sahba_rooms;
drop policy if exists "sahba delete old" on public.sahba_rooms;

create policy "sahba read"   on public.sahba_rooms for select to anon, authenticated using (true);
create policy "sahba insert" on public.sahba_rooms for insert to anon, authenticated with check (true);
create policy "sahba update" on public.sahba_rooms for update to anon, authenticated using (true) with check (true);
-- الحذف مسموح فقط للغرف المهجورة منذ أكثر من يومين (تنظيف تلقائي عند إنشاء غرفة جديدة)
create policy "sahba delete old" on public.sahba_rooms for delete to anon, authenticated
  using (updated_at < now() - interval '2 days');
