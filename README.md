# FiveM 環境構築

DockerとtxAdminを使用して、ローカル環境にFiveMサーバーを構築します。

## 必要なソフトウェア

事前に、以下のソフトウェアをPCへインストールしてください。

- GTA V Legacy
- Docker Desktop
- Git

Docker Desktopは起動した状態にしておいてください。

---

## 1. リポジトリをクローンする

任意のフォルダでgit bashを開き、リポジトリをクローンします。

```bash
git clone <リポジトリのURL>
```

クローンしたフォルダへ移動します。

```bash
cd <リポジトリ名>
```

---

## 2. FiveMコンテナを起動する

次のコマンドを実行します。

```bash
docker compose up -d
```

コンテナが起動しているか確認します。

```bash
docker compose ps
```

`fivem-lesson`が起動していれば成功です。

---

## 3. txAdminの初期設定を行う

ブラウザで次のURLを開きます。

```text
http://localhost:40120
```

画面の案内に従って、txAdminの初期設定を完了してください。

セットアップ中に表示される`Server Data Folder`の値は、後ほど使用します。

例：

```text
/txData/FiveMBasicServerCFXDefault_XXXXXX.base/
```

末尾の`/`まで含めてコピーしてください。

---

## 4. `.env`ファイルを作成する

リポジトリ直下にある`.env.example`を複製し、ファイル名を`.env`へ変更します。

作成した`.env`を開き、txAdminに表示された`Server Data Folder`を設定します。

```env
SERVER_DATA_FOLDER=/txData/FiveMBasicServerCFXDefault_XXXXXX.base/
```

`SERVER_DATA_FOLDER`には、txAdminの画面に表示された値を、末尾の`/`まで含めてそのまま貼り付けてください。

---

## 5. ファイルのマウントを有効にする

`compose.yaml`を開き、2行のコメントアウトを外します。

変更前：

```yaml
## .envのSERVER_DATA_FOLDERを設定したらコメントアウトを外す
# - "./config/lesson.cfg:${SERVER_DATA_FOLDER:?SERVER_DATA_FOLDERを.envに設定してください}lesson.cfg:ro"
# - "./resources/[local]:${SERVER_DATA_FOLDER:?SERVER_DATA_FOLDERを.envに設定してください}resources/[local]"
```

変更後：

```yaml
## .envのSERVER_DATA_FOLDERを設定したらコメントアウトを外す
- "./config/lesson.cfg:${SERVER_DATA_FOLDER:?SERVER_DATA_FOLDERを.envに設定してください}lesson.cfg:ro"
- "./resources/[local]:${SERVER_DATA_FOLDER:?SERVER_DATA_FOLDERを.envに設定してください}resources/[local]"
```

---

## 6. `server.cfg`から`lesson.cfg`を読み込む

txAdminが作成したServer Data Folder内の`server.cfg`を開きます。

ホストPC側では、次のような場所にあります。

```text
volumes/txData/<サーバーデータフォルダ>/server.cfg
```

例：

```text
volumes/txData/FiveMBasicServerCFXDefault_XXXXXX.base/server.cfg
```

`server.cfg`の末尾へ、次の1行を追加します。

```cfg
exec lesson.cfg
```

これにより、Gitで管理されている設定ファイルが読み込まれます。

---

## 7. コンテナを再作成する

`.env`と`compose.yaml`の変更を反映するため、一度コンテナを停止・削除します。

```bash
docker compose down
```

その後、もう一度コンテナを起動します。

```bash
docker compose up -d
```

起動状態を確認します。

```bash
docker compose ps
```

---

## 8. Hello Worldの動作を確認する

ブラウザでtxAdminを開き、ゲームサーバーが起動していることを確認します。

```text
http://localhost:40120
```

FiveMクライアントを起動し、ローカルサーバーへ接続してください。

正常にセットアップできている場合、Client側とServer側の両方で、約5秒ごとにHello Worldが出力されます。

### Server側の確認

txAdminの`Live Console`を開きます。

約5秒ごとに、次のようなメッセージが表示されます。

```text
Server: Hello World
```

### Client側の確認

FiveMクライアント上で`F8`キーを押し、コンソールを開きます。（コンソールを閉じる場合は再度F8を入力します）

約5秒ごとに、次のようなメッセージが表示されます。

```text
Client: Hello World
```

Client側とServer側の両方でメッセージが確認できれば、環境構築は完了です。

---

## よく使うコマンド

### コンテナを起動する

```bash
docker compose up -d
```

### コンテナを停止・削除する

```bash
docker compose down
```

### コンテナの起動状態を確認する

```bash
docker compose ps
```

---

## フォルダ構成

```text
.
├─ compose.yaml
├─ .env.example
├─ .env
├─ config/
│  └─ lesson.cfg
├─ resources/
│  └─ [local]/
│     └─ hello_world/
└─ volumes/
   └─ txData/
      ├─ default/
      └─ FiveMBasicServerCFXDefault_XXXXXX.base/
         ├─ server.cfg
         └─ resources/
```

`.env`と`volumes`フォルダには、環境固有の設定、txAdminの管理情報、ログなどが含まれます。

これらはGitへコミットしないでください。

`.gitignore`には、少なくとも次の内容を追加してください。

```gitignore
.env
volumes/
```