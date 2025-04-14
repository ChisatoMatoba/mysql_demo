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
docker exec -it mysql_deadlock_demo mysql -u demouser -pdemopass deadlock_demo

# rootユーザーとして接続
docker exec -it mysql_deadlock_demo mysql -u root -prootpass deadlock_demo
```

## デッドロック検証方法(例)

### テストデータの準備

```sql
-- テストデータ追加
INSERT INTO users (name, email) VALUES ('ユーザー1', 'user1@example.com');
INSERT INTO organizations (name, code) VALUES ('組織1', 'ORG001');
INSERT INTO organization_users (organization_id, user_id, name, code, is_primary) 
VALUES (1, 1, 'ユーザー1（組織1）', 'USER001', true);
```

### デッドロック発生手順

1. 2つの異なるターミナルウィンドウを開き、それぞれでMySQLに接続します

2. ターミナル1で実行:
```sql
START TRANSACTION;
UPDATE organization_users SET name = 'Updated Name 1' WHERE user_id = 1;
-- 少し待つ
UPDATE organizations SET name = 'Updated Org 1' WHERE id = 1;
COMMIT;
```

3. ターミナル2で実行:
```sql
START TRANSACTION;
UPDATE organizations SET name = 'Updated Org 2' WHERE id = 1;
-- 少し待つ
UPDATE organization_users SET name = 'Updated Name 2' WHERE user_id = 1;
COMMIT;
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
