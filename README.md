# MySQL ロック状態検証環境

このプロジェクトはMySQLでの動作を検証するためのデモ環境です。

## 環境構成

- MySQL 8.0
- テーブル構成:
  - User
  - Organization
  - OrganizationUser (中間テーブル)
- ER図
  ```mermaid
  erDiagram
    users {
      INT id PK
      VARCHAR name
      VARCHAR email（UNIQUE）
    }
    organizations {
      INT id PK
      VARCHAR name
      VARCHAR code（UNIQUE）
    }
    organization_users {
      INT id PK
      INT organization_id FK
      INT user_id FK
      VARCHAR name
      VARCHAR code（UNIQUE）
      BOOLEAN inactive
      *composite_key organization_id--user_id--inactive
    }

    users ||--o{ organization_users : has
    organizations ||--o{ organization_users : has
  ```

## セットアップ手順

### 環境の起動

`Docker Desktop`を起動させ、以下を実行します:

```bash
# コンテナの起動
docker compose up -d

# 状態確認
docker compose ps
```

### MySQLへの接続

コンテナが起動したら、以下のコマンドでMySQLへ接続できます:

```bash
# demouserとして接続
docker exec -it mysql_demo mysql -u demouser -pdemopass mysql_demo
# rootユーザーとして接続
docker exec -it mysql_demo mysql -u root -prootpass mysql_demo
```

## テストデータの準備
これは例です:
```sql
-- テストデータ追加
INSERT INTO users (id, name, email) VALUES
(1, 'Alice', 'alice@example.com'),
(3, 'Bob', 'bob@example.com'),
(5, 'Charlie', 'charlie@example.com');

INSERT INTO organizations (id, name, code) VALUES
(10, 'Org A', 'A001'),
(20, 'Org B', 'B002'),
(30, 'Org C', 'C005');

INSERT INTO organization_users (id, organization_id, user_id, name, code, inactive) VALUES
(100, 10, 1, 'Alpha', 'X001', TRUE),
(105, 10, 3, 'Beta', 'X002', FALSE),
(110, 20, 3, 'Gamma', 'X005', TRUE),
(120, 30, 1, 'Delta', 'X007', TRUE),
(130, 30, 5, 'Zeta', 'X010', FALSE);
```

### ロック情報の確認

ロック発生時に以下のコマンドでロック情報を確認できます:

```sql
-- ロック情報の確認
SELECT * FROM performance_schema.data_locks\G

-- 最後に発生したデッドロックの情報
SHOW ENGINE INNODB STATUS\G
```

## 環境の停止・削除

```bash
# 停止
docker compose down

# 完全削除（ボリュームも削除）
docker compose down -v
```
