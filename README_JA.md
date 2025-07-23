# Claude Code マルチプロバイダー版

[中文](README.md) | [English](README_EN.md) | **日本語** | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

Alibaba Cloud Qwen、Kimi、その他のAIモデルを使用してClaude Codeを駆動し、低コスト・高性能のAIプログラミングアシスタントソリューションを提供します。

## ✨ 機能

- 🚀 **マルチプロバイダー対応**: Alibaba Cloud Qwen、Kimi、その他のAIモデルをサポート
- 💰 **コスト効率**: 高価なAnthropic Claude APIの代わりに国産AI APIを使用
- 🔧 **ワンクリックインストール**: Linux/macOSとWindows用の自動インストールスクリプト
- 🔄 **シームレスな統合**: 既存のClaude Codeワークフローと完全に互換
- 🤖 **最新モデル**:
  - **Qwen（推奨）**: Alibaba Cloud Qwenシリーズ（qwen-plus、qwen-maxなど）
  - **Kimi**: Moonshot AI kimi-k2-0711-previewモデル
- 🛡️ **安全で信頼性**: 安全なAPI key管理と環境変数設定
- 🌐 **柔軟な設定**: カスタムBASE_URLをサポート、プロバイダー間の簡単な切り替え

## 📋 システム要件

- Node.js 18.0以上
- npmパッケージマネージャー
- 有効なAPI Key（Alibaba Cloud QwenまたはMoonshot Kimi）

## 🚀 クイックインストール

### 📝 API Keyの取得

1. Kimi Open PlatformでAPI Keyを申請

   👉 [Kimi Open Platform](https://platform.moonshot.cn/)

2. アカウントを登録/ログインしてユーザーセンターに入る
3. ナビゲート：**ユーザーセンター** → **API Key管理** → **新しいAPI Keyを作成**
4. 生成されたAPI Key（`sk-`で始まる）をコピー

### 💻 Linux / macOSインストール

クイックインストール - API Keyの入力を求められますので、最後にEnterを押してください：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Windowsインストール

#### 方法1：インストールスクリプトのダウンロード（推奨）

1. インストールスクリプトをダウンロード：[install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. 右クリックして「管理者として実行」を選択
3. プロンプトに従ってMoonshot API Keyを入力
4. インストールの完了を待つ

#### 方法2：コマンドラインインストール

PowerShellで：

```powershell
# インストールスクリプトをダウンロードして実行
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

またはコマンドプロンプトで：

```cmd
# curlを使用してダウンロード（Windows 10 1803+）
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ インストールの確認

インストール後、ターミナルを再起動して実行：

```bash
claude --version  # バージョン情報を確認
claude           # Claude Codeの使用を開始
```

## 🔧 手動設定

自動インストールで問題が発生した場合、環境変数を手動で設定できます：

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**コマンドプロンプト (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**永続的な設定（推奨）:**
1. 「このPC」を右クリック → プロパティ → システムの詳細設定 → 環境変数
2. 「ユーザー変数」に上記の2つの環境変数を追加

## 🎯 使用方法

インストール後、元のClaude Codeと同じように使用できます：

```bash
claude  # インタラクティブな会話を開始
```

## 🔍 トラブルシューティング

### よくある問題

**Q: "claude は内部コマンドまたは外部コマンドとして認識されません"**
- ターミナルウィンドウを再起動
- Node.jsとnpmが正しくインストールされているか確認
- 再インストール：`npm install -g @anthropic-ai/claude-code`

**Q: "Invalid API key"エラー**
- API Keyが正しく設定されているか確認
- API Keyが`sk-`で始まっているか確認
- インストールスクリプトを再実行

**Q: Windows環境変数が機能しない**
- コマンドラインウィンドウを再起動
- システムに再ログイン
- 管理者権限でインストールスクリプトを実行

### 環境変数テスト

**環境変数が正しく設定されているかチェック：**

Linux/macOS:
```bash
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_API_KEY
```

Windows CMD:
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_API_KEY%
```

Windows PowerShell:
```powershell
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_API_KEY
```

## 🤝 貢献

このプロジェクトを改善するためのIssuesとPull Requestsを歓迎します！

1. このリポジトリをフォーク
2. 機能ブランチを作成（`git checkout -b feature/AmazingFeature`）
3. 変更をコミット（`git commit -m 'Add some AmazingFeature'`）
4. ブランチにプッシュ（`git push origin feature/AmazingFeature`）
5. Pull Requestを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細は[LICENSE](LICENSE)ファイルを参照してください。

## 🔗 関連リンク

- 🌐 [Kimi Open Platform](https://platform.moonshot.cn/)
- 📖 [Claude Code公式ドキュメント](https://docs.anthropic.com/claude/docs)
- 🐛 [問題報告](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [ディスカッション](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ サポート

このプロジェクトが役に立った場合は、⭐️をください！

---

**免責事項**: このプロジェクトは学習と研究目的のみです。関連APIの利用規約を遵守してください。 
