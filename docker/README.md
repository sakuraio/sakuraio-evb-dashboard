# sakuraio-evb-dashboard Docker

sakura.io 評価ボードから送信されてきたデータを手軽に確認するためのツールです。

環境変数としてWebSocket連携サービスのトークンと表示対象の通信モジュールIDを渡すだけで、sakura.ioとWebSocketで自動的に接続し、グラフを表示します。

sakura.io 評価ボードには [sakura.io Evaluation Board Standard](https://os.mbed.com/teams/SAKURA-Internet/code/SakuraIO_Evaluation_Board_Standard/)が書き込まれている必要があります。

Node-REDをベースに構築されており、Dockerを用いて簡単にデプロイが可能となっています。

## quickstart
```
docker run -d -p %UI_PORT%:8080 -v /host-datadir:/log -e MODULE_ID=uXXXXXXXXXX -e WEBSOCKET_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx misodengaku/sakuraio-evb-dashboard
```

### ポート

8080番ポートにHTTPでアクセスすることによりグラフが表示できます。8080番ポートはnginxによりNode-REDのグラフ表示画面のみにアクセスが可能なように設定されています。

--exposeなどで1880番ポートを公開し、1880番ポートへHTTPでアクセスすることによりNode-REDのフロー編集画面へアクセスできますが、認証などが設定されていないため公開は推奨しません。


### 環境変数

モジュールIDを `MODULE_ID` 、WebSocket連携サービスのトークンを `WEBSOCKET_TOKEN` として環境変数に設定し、コンテナを起動させてください。

```
docker run -e MODULE_ID=uXXXXXXXXXX -e WEBSOCKET_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx misodengaku/sakuraio-evb-dashboard
```


### データの永続化

グラフデータはコンテナ内の `/log` に保存されます。

`/log` をホスト側の任意のディレクトリにマウントすることで、グラフデータを永続化できます。

永続化されたグラフデータはコンテナ起動時に自動で読み込まれます。



## 開発
### build
```
docker build -t sakuraio-evb-dashboard .
```

### フローに変更を加えたい場合

フローについては永続化が行われないため、フローエディタ上でフローを編集してもコンテナの停止時に変更内容が消失します。

コンテナ上で稼働するフローを変更したい場合は、起動時に読み込まれるフローを編集し、コンテナをビルドし直すことを推奨します。

起動時に読み込まれるフローは[evb_flow.json.template](./evb_flow.json.template)に記述されています。

evb_flow.json.templateには、Node-RED フローエディタからエクスポートしたJSON形式のフローを記述してください。
evb_flow.json.templateに含まれる `%WEBSOCKET_TOKEN%` と `%MODULE_ID%` はコンテナ起動時に環境変数で与えられたトークンとモジュールIDに置き換えられます。



