# MySQL デッドロック検証環境

このプロジェクトはMySQLでの動作を検証するためのデモ環境です。

## 環境構成

- MySQL 8.0
- テーブル構成:
  - User
  - Organization
  - OrganizationUser (中間テーブル)

## セットアップ手順

### 環境の起動

最新のDockerでは `docker compose` コマンド（スペース区切り）を使用します:

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

## デッドロック検証方法(例)

### デッドロック発生手順

1. 2つの異なるターミナルウィンドウを開き、それぞれでMySQLに接続します

2. ターミナル1で実行:
```sql
(WIP)
```

3. ターミナル2で実行:
```sql
(WIP)
```

### デッドロック情報の確認

デッドロック発生時に以下のコマンドでロック情報を確認できます:

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
