-- テーブル作成前に既存のテーブルがあれば削除
DROP TABLE IF EXISTS organization_users;
DROP TABLE IF EXISTS organizations;
DROP TABLE IF EXISTS users;

-- Userテーブルの作成
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Organizationテーブルの作成
CREATE TABLE organizations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- OrganizationUserテーブルの作成
CREATE TABLE organization_users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  organization_id INT NOT NULL,
  user_id INT NOT NULL,
  name VARCHAR(255),
  code VARCHAR(50),
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- 外部キー制約
  FOREIGN KEY (organization_id) REFERENCES organizations(id),
  FOREIGN KEY (user_id) REFERENCES users(id),

  -- 一意インデックス (organization_id, user_id, is_primary)
  UNIQUE INDEX idx_org_user_primary (organization_id, user_id, is_primary),

  -- nameのインデックス
  INDEX idx_name (name),

  -- codeの一意インデックス
  UNIQUE INDEX idx_code (code)
);

-- demoユーザーにパフォーマンススキーマへのアクセス権限を付与
GRANT SELECT ON performance_schema.* TO 'demouser'@'%';
