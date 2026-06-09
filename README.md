# iOSEngineerTest

シンプルな TODO 管理アプリ。タイトル・内容・期限を登録し、一覧／詳細を確認できる UIKit ベースの iOS アプリです。

## 機能

- **一覧画面 (`TodoListViewController`)**
  - 登録済み TODO を期限の昇順（同一期限内は作成日時の降順）で表示
  - `UITableViewDiffableDataSource` による差分更新
  - 右下のフローティング `+` ボタンで追加画面を表示
  - 引っ張って更新（Pull to Refresh）対応
- **追加画面 (`AddTodoViewController`)**
  - タイトル・内容・期限（`UIDatePicker`）を入力
  - タイトル必須（空文字では保存ボタンが無効化）
  - シート表示（`.medium` / `.large` detent、グラバー表示）
- **詳細画面 (`TodoDetailViewController`)**
  - 選択した TODO のタイトル・内容・期限を表示
- **セル表示 (`TodoCell`)**
  - 期限切れの項目は期限ラベルを赤色で強調

## 構成

```
iOSEngineerTest/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Info.plist
├── Base.lproj/
│   ├── Main.storyboard
│   └── LaunchScreen.storyboard
├── Models/
│   └── Todo.swift                 // id / title / content / deadline / createdAt
├── Views/
│   └── TodoCell.swift
├── Controllers/
│   ├── TodoListViewController.swift
│   ├── AddTodoViewController.swift
│   └── TodoDetailViewController.swift
├── Services/
│   └── TodoStorage.swift          // UserDefaults + JSONEncoder/Decoder
└── Assets.xcassets/
```

## 永続化

`TodoStorage` が `UserDefaults` にキー `iOSEngineerTest.todos.v1` で `[Todo]` を JSON エンコードして保存します。

## 動作環境

- Xcode 26.5 以降
- iOS 26.5 以降 / iPhone・iPad
- Swift 5.0

## ビルド・実行

```sh
open iOSEngineerTest.xcodeproj
```

Xcode でスキーム `iOSEngineerTest` を選択し、シミュレータまたは実機で実行してください。
