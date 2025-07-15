# Kimi CC

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | **Deutsch** | [Español](README_ES.md) | [Русский](README_RU.md)

Nutzen Sie Kimis neuestes Modell (kimi-k2-0711-preview) für Ihren Claude Code und bieten Sie eine kostengünstige KI-Programmierassistenten-Lösung.

## ✨ Funktionen

- 🚀 **Kosteneffizient**: Verwenden Sie die Kimi API anstelle der teuren Anthropic Claude API
- 🔧 **Ein-Klick-Installation**: Automatisierte Installationsskripte für Linux/macOS und Windows
- 🔄 **Nahtlose Integration**: Vollständig kompatibel mit bestehenden Claude Code-Workflows
- 🤖 **Neuestes Modell**: Angetrieben von Kimis kimi-k2-0711-preview-Modell
- 🛡️ **Sicher und zuverlässig**: Sichere API-Schlüsselverwaltung und Umgebungsvariablenkonfiguration

## 📋 Systemanforderungen

- Node.js 18.0 oder höher
- npm-Paketmanager
- Gültiger Moonshot API-Schlüssel

## 🚀 Schnellinstallation

### 📝 API-Schlüssel erhalten

1. Gehen Sie zur Kimi Open Platform, um einen API-Schlüssel zu beantragen

   👉 [Kimi Open Platform](https://platform.moonshot.cn/)

2. Registrieren/melden Sie sich bei Ihrem Konto an und gehen Sie zum Benutzerzentrum
3. Navigieren Sie zu: **Benutzerzentrum** → **API-Schlüsselverwaltung** → **Neuen API-Schlüssel erstellen**
4. Kopieren Sie den generierten API-Schlüssel (beginnt mit `sk-`)

### 💻 Linux / macOS Installation

Schnellinstallation - Sie werden aufgefordert, Ihren API-Schlüssel einzugeben, dann drücken Sie Enter zum Abschließen:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Windows Installation

#### Methode 1: Installationsskript herunterladen (Empfohlen)

1. Laden Sie das Installationsskript herunter: [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. Rechtsklick und "Als Administrator ausführen" auswählen
3. Folgen Sie den Anweisungen zur Eingabe Ihres Moonshot API-Schlüssels
4. Warten Sie auf den Abschluss der Installation

#### Methode 2: Kommandozeilen-Installation

In PowerShell:

```powershell
# Installationsskript herunterladen und ausführen
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

Oder in der Eingabeaufforderung:

```cmd
# Curl zum Herunterladen verwenden (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ Installationsüberprüfung

Nach der Installation starten Sie Ihr Terminal neu und führen aus:

```bash
claude --version  # Versionsinformationen überprüfen
claude           # Claude Code verwenden beginnen
```

## 🔧 Manuelle Konfiguration

Wenn die automatische Installation auf Probleme stößt, können Sie Umgebungsvariablen manuell konfigurieren:

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**Eingabeaufforderung (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**Permanente Einrichtung (Empfohlen):**
1. Rechtsklick auf "Dieser PC" → Eigenschaften → Erweiterte Systemeinstellungen → Umgebungsvariablen
2. Fügen Sie die beiden obigen Umgebungsvariablen in "Benutzervariablen" hinzu

## 🎯 Verwendung

Nach der Installation können Sie es wie den ursprünglichen Claude Code verwenden:

```bash
claude  # Interaktives Gespräch starten
```

## 🔍 Fehlerbehebung

### Häufige Probleme

**F: "claude wird nicht als interner oder externer Befehl erkannt"**
- Terminal-Fenster neu starten
- Überprüfen Sie, ob Node.js und npm ordnungsgemäß installiert sind
- Neu installieren: `npm install -g @anthropic-ai/claude-code`

**F: "Invalid API key" Fehler**
- Überprüfen Sie, ob der API-Schlüssel korrekt gesetzt ist
- Stellen Sie sicher, dass der API-Schlüssel mit `sk-` beginnt
- Führen Sie das Installationsskript erneut aus

**F: Windows-Umgebungsvariablen funktionieren nicht**
- Kommandozeilenfenster neu starten
- Erneut am System anmelden
- Installationsskript mit Administratorrechten ausführen

### Umgebungsvariablen-Test

**Überprüfen Sie, ob Umgebungsvariablen korrekt gesetzt sind:**

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

## 🤝 Beitrag

Wir begrüßen Issues und Pull Requests zur Verbesserung dieses Projekts!

1. Forken Sie dieses Repository
2. Erstellen Sie Ihren Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushen Sie zum Branch (`git push origin feature/AmazingFeature`)
5. Erstellen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](LICENSE)-Datei für Details.

## 🔗 Verwandte Links

- 🌐 [Kimi Open Platform](https://platform.moonshot.cn/)
- 📖 [Claude Code Offizielle Dokumentation](https://docs.anthropic.com/claude/docs)
- 🐛 [Fehlermeldung](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [Diskussionen](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ Unterstützung

Wenn Ihnen dieses Projekt hilft, geben Sie uns einen ⭐️!

---

**Haftungsausschluss**: Dieses Projekt ist nur für Lern- und Forschungszwecke. Bitte beachten Sie die Nutzungsbedingungen der entsprechenden APIs. 