-- ===== NUEVA ESTRUCTURA: BANCO DE PREGUNTAS POR TEMA =====

create table if not exists temas (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  created_at timestamptz default now()
);

create table if not exists banco_preguntas (
  id uuid primary key default gen_random_uuid(),
  tema_id uuid references temas(id) on delete cascade,
  tipo text not null,        -- mc | vf | open | complete
  texto text not null,
  opts jsonb,                 -- para mc / vf
  correcto int,               -- indice correcto para mc / vf
  respuesta text,             -- para open / complete
  created_at timestamptz default now()
);

-- Reemplazamos la tabla de examenes para que sea "armado" por temas+cantidades
drop table if exists resultados;
drop table if exists examenes;

create table examenes (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  tiempo_min int not null,
  puntaje_min int not null,
  config jsonb not null,      -- [{tema_id, tema_nombre, cantidad}]
  created_at timestamptz default now()
);

create table resultados (
  id uuid primary key default gen_random_uuid(),
  examen_id uuid references examenes(id),
  nombre_aprendiz text not null,
  documento text,
  programa text,
  puntaje int not null,
  respuestas jsonb,
  cambios_pestana int default 0,
  created_at timestamptz default now()
);

alter table temas enable row level security;
alter table banco_preguntas enable row level security;
alter table examenes enable row level security;
alter table resultados enable row level security;

create policy "lee temas" on temas for select using (true);
create policy "inserta temas" on temas for insert with check (true);
create policy "borra temas" on temas for delete using (true);

create policy "lee banco" on banco_preguntas for select using (true);
create policy "inserta banco" on banco_preguntas for insert with check (true);
create policy "borra banco" on banco_preguntas for delete using (true);

create policy "lee examenes" on examenes for select using (true);
create policy "inserta examenes" on examenes for insert with check (true);
create policy "borra examenes" on examenes for delete using (true);

create policy "inserta resultados" on resultados for insert with check (true);
create policy "lee resultados" on resultados for select using (true);
