-- CYPARK Database Schema
-- Import with: sqlite3 data/cypark.db < schema.sql

CREATE TABLE IF NOT EXISTS users (
    username TEXT PRIMARY KEY,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    email TEXT DEFAULT '',
    role TEXT DEFAULT 'user',
    created TEXT,
    blocked INTEGER DEFAULT 0,
    failed_logins INTEGER DEFAULT 0,
    last_login TEXT,
    discount_type TEXT DEFAULT 'none',
    id_card_filename TEXT DEFAULT ''
);

CREATE TABLE IF NOT EXISTS slots (
    slot_id TEXT PRIMARY KEY,
    floor TEXT,
    zone TEXT,
    occupied INTEGER DEFAULT 0,
    plate TEXT,
    session_id TEXT,
    entry_time TEXT,
    slot_type TEXT DEFAULT 'regular',
    reserved INTEGER DEFAULT 0,
    reserved_by TEXT,
    reserved_until TEXT
);

CREATE TABLE IF NOT EXISTS sessions (
    session_id TEXT PRIMARY KEY,
    slot_id TEXT,
    plate TEXT,
    username TEXT,
    entry TEXT,
    exit TEXT,
    fee REAL,
    discount_type TEXT DEFAULT 'none',
    status TEXT DEFAULT 'active',
    qr_data TEXT,
    invalid_qr_attempts INTEGER DEFAULT 0,
    paid_before_exit INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS reservations (
    id TEXT PRIMARY KEY,
    username TEXT,
    plate TEXT,
    slot_id TEXT,
    reserved_at TEXT,
    expires_at TEXT,
    status TEXT DEFAULT 'active',
    fee REAL DEFAULT 50
);

CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    slot_id TEXT,
    plate TEXT,
    session_id TEXT,
    amount REAL DEFAULT 0,
    username TEXT,
    created TEXT
);

CREATE TABLE IF NOT EXISTS queue (
    id TEXT PRIMARY KEY,
    username TEXT,
    plate TEXT,
    joined_at TEXT,
    status TEXT DEFAULT 'waiting'
);

CREATE TABLE IF NOT EXISTS payments (
    id TEXT PRIMARY KEY,
    session_id TEXT,
    plate TEXT,
    hours REAL,
    rate REAL,
    discount_pct REAL,
    discount_type TEXT,
    subtotal REAL,
    discount_amount REAL,
    penalty REAL,
    total REAL,
    created TEXT,
    username TEXT,
    paid_before_exit INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS violations (
    id TEXT PRIMARY KEY,
    plate TEXT,
    slot_id TEXT,
    violation_type TEXT,
    detail TEXT,
    created TEXT,
    resolved INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY,
    username TEXT,
    message TEXT,
    type TEXT DEFAULT 'info',
    created TEXT,
    read INTEGER DEFAULT 0
);

-- Default admin account (password: admin123)
INSERT OR IGNORE INTO users (username, password, name, email, role, created, blocked)
VALUES ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
        'Administrator', 'admin@cypark.ph', 'admin', datetime('now'), 0);

-- Parking layout: A=Ground, B=Level 2, C=Rooftop  (North & South, 5 slots each)
INSERT OR IGNORE INTO slots (slot_id, floor, zone) VALUES
  ('AN-01','A','North'),('AN-02','A','North'),('AN-03','A','North'),('AN-04','A','North'),('AN-05','A','North'),
  ('AS-01','A','South'),('AS-02','A','South'),('AS-03','A','South'),('AS-04','A','South'),('AS-05','A','South'),
  ('BN-01','B','North'),('BN-02','B','North'),('BN-03','B','North'),('BN-04','B','North'),('BN-05','B','North'),
  ('BS-01','B','South'),('BS-02','B','South'),('BS-03','B','South'),('BS-04','B','South'),('BS-05','B','South'),
  ('CN-01','C','North'),('CN-02','C','North'),('CN-03','C','North'),('CN-04','C','North'),('CN-05','C','North'),
  ('CS-01','C','South'),('CS-02','C','South'),('CS-03','C','South'),('CS-04','C','South'),('CS-05','C','South');
