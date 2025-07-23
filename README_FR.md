# Claude Code Édition Multi-Fournisseurs

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | **Français** | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

Utilisez Alibaba Cloud Qwen, Kimi ou d'autres modèles IA pour alimenter votre Claude Code, offrant une solution d'assistant de programmation IA à faible coût et haute performance.

## ✨ Fonctionnalités

- 🚀 **Rentable**: Utilisez l'API Kimi au lieu de l'API Anthropic Claude coûteuse
- 🔧 **Installation en un clic**: Scripts d'installation automatisés pour Linux/macOS et Windows
- 🔄 **Intégration transparente**: Entièrement compatible avec les flux de travail Claude Code existants
- 🤖 **Modèle le plus récent**: Alimenté par le modèle kimi-k2-0711-preview de Kimi
- 🛡️ **Sécurisé et fiable**: Gestion sécurisée des clés API et configuration des variables d'environnement

## 📋 Configuration requise

- Node.js 18.0 ou supérieur
- Gestionnaire de paquets npm
- Clé API Moonshot valide

## 🚀 Installation rapide

### 📝 Obtenir une clé API

1. Rendez-vous sur la plateforme ouverte Kimi pour demander une clé API

   👉 [Plateforme ouverte Kimi](https://platform.moonshot.cn/)

2. Inscrivez-vous/connectez-vous à votre compte et accédez au centre utilisateur
3. Naviguez vers : **Centre utilisateur** → **Gestion des clés API** → **Créer une nouvelle clé API**
4. Copiez la clé API générée (commence par `sk-`)

### 💻 Installation Linux / macOS

Installation rapide - vous serez invité à saisir votre clé API, puis appuyez sur Entrée pour terminer :

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Installation Windows

#### Méthode 1 : Télécharger le script d'installation (Recommandé)

1. Téléchargez le script d'installation : [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. Clic droit et sélectionnez "Exécuter en tant qu'administrateur"
3. Suivez les invites pour entrer votre clé API Moonshot
4. Attendez que l'installation soit terminée

#### Méthode 2 : Installation en ligne de commande

Dans PowerShell :

```powershell
# Télécharger et exécuter le script d'installation
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

Ou dans l'invite de commande :

```cmd
# Utiliser curl pour télécharger (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ Vérification de l'installation

Après l'installation, redémarrez votre terminal et exécutez :

```bash
claude --version  # Vérifier les informations de version
claude           # Commencer à utiliser Claude Code
```

## 🔧 Configuration manuelle

Si l'installation automatique rencontre des problèmes, vous pouvez configurer manuellement les variables d'environnement :

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**Invite de commande (CMD) :**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell :**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**Configuration permanente (Recommandé) :**
1. Clic droit sur "Ce PC" → Propriétés → Paramètres système avancés → Variables d'environnement
2. Ajoutez les deux variables d'environnement ci-dessus dans "Variables utilisateur"

## 🎯 Utilisation

Après l'installation, vous pouvez l'utiliser comme le Claude Code original :

```bash
claude  # Démarrer une conversation interactive
```

## 🔍 Dépannage

### Problèmes courants

**Q : "claude n'est pas reconnu comme une commande interne ou externe"**
- Redémarrez la fenêtre du terminal
- Vérifiez si Node.js et npm sont correctement installés
- Réinstallez : `npm install -g @anthropic-ai/claude-code`

**Q : Erreur "Invalid API key"**
- Vérifiez si la clé API est correctement définie
- Assurez-vous que la clé API commence par `sk-`
- Relancez le script d'installation

**Q : Les variables d'environnement Windows ne fonctionnent pas**
- Redémarrez la fenêtre de ligne de commande
- Reconnectez-vous au système
- Exécutez le script d'installation avec des privilèges d'administrateur

### Test des variables d'environnement

**Vérifiez si les variables d'environnement sont correctement définies :**

Linux/macOS :
```bash
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_API_KEY
```

Windows CMD :
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_API_KEY%
```

Windows PowerShell :
```powershell
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_API_KEY
```

## 🤝 Contribution

Nous accueillons les Issues et Pull Requests pour améliorer ce projet !

1. Forkez ce dépôt
2. Créez votre branche de fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Validez vos modifications (`git commit -m 'Add some AmazingFeature'`)
4. Poussez vers la branche (`git push origin feature/AmazingFeature`)
5. Créez une Pull Request

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🔗 Liens connexes

- 🌐 [Plateforme ouverte Kimi](https://platform.moonshot.cn/)
- 📖 [Documentation officielle Claude Code](https://docs.anthropic.com/claude/docs)
- 🐛 [Signalement de problèmes](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [Discussions](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ Support

Si ce projet vous aide, donnez-nous une ⭐️ !

---

**Avertissement** : Ce projet est uniquement à des fins d'apprentissage et de recherche. Veuillez respecter les conditions d'utilisation des API concernées. 
