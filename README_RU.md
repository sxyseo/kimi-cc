# Claude Code Мульти-Провайдер Издание

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | **Русский**

Используйте Alibaba Cloud Qwen, Kimi или другие ИИ-модели для работы с Claude Code, предоставляя недорогое, высокопроизводительное решение ИИ-ассистента программирования.

## ✨ Функции

- 🚀 **Экономически эффективно**: Используйте Kimi API вместо дорогого Anthropic Claude API
- 🔧 **Установка в один клик**: Автоматизированные скрипты установки для Linux/macOS и Windows
- 🔄 **Бесшовная интеграция**: Полностью совместимо с существующими рабочими процессами Claude Code
- 🤖 **Новейшая модель**: Работает на модели kimi-k2-0711-preview от Kimi
- 🛡️ **Безопасно и надежно**: Безопасное управление API-ключами и настройка переменных окружения

## 📋 Системные требования

- Node.js 18.0 или выше
- Менеджер пакетов npm
- Действительный API-ключ Moonshot

## 🚀 Быстрая установка

### 📝 Получение API-ключа

1. Перейдите на открытую платформу Kimi для подачи заявки на API-ключ

   👉 [Открытая платформа Kimi](https://platform.moonshot.cn/)

2. Зарегистрируйтесь/войдите в свою учетную запись и перейдите в пользовательский центр
3. Перейдите к: **Пользовательский центр** → **Управление API-ключами** → **Создать новый API-ключ**
4. Скопируйте сгенерированный API-ключ (начинается с `sk-`)

### 💻 Установка Linux / macOS

Быстрая установка - вам будет предложено ввести ваш API-ключ, затем нажмите Enter для завершения:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Установка Windows

#### Метод 1: Скачать скрипт установки (Рекомендуется)

1. Скачайте скрипт установки: [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. Щелкните правой кнопкой мыши и выберите "Запуск от имени администратора"
3. Следуйте подсказкам для ввода вашего API-ключа Moonshot
4. Дождитесь завершения установки

#### Метод 2: Установка через командную строку

В PowerShell:

```powershell
# Скачать и выполнить скрипт установки
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

Или в командной строке:

```cmd
# Использовать curl для скачивания (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ Проверка установки

После установки перезапустите терминал и выполните:

```bash
claude --version  # Проверить информацию о версии
claude           # Начать использование Claude Code
```

## 🔧 Ручная настройка

Если автоматическая установка сталкивается с проблемами, вы можете вручную настроить переменные окружения:

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**Командная строка (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**Постоянная настройка (Рекомендуется):**
1. Щелкните правой кнопкой мыши "Этот компьютер" → Свойства → Дополнительные параметры системы → Переменные среды
2. Добавьте вышеуказанные две переменные окружения в "Пользовательские переменные"

## 🎯 Использование

После установки вы можете использовать его как оригинальный Claude Code:

```bash
claude  # Начать интерактивную беседу
```

## 🔍 Устранение неполадок

### Распространенные проблемы

**В: "claude не распознается как внутренняя или внешняя команда"**
- Перезапустите окно терминала
- Проверьте, правильно ли установлены Node.js и npm
- Переустановите: `npm install -g @anthropic-ai/claude-code`

**В: Ошибка "Invalid API key"**
- Проверьте, правильно ли установлен API-ключ
- Убедитесь, что API-ключ начинается с `sk-`
- Повторно запустите скрипт установки

**В: Переменные окружения Windows не работают**
- Перезапустите окно командной строки
- Повторно войдите в систему
- Запустите скрипт установки с правами администратора

### Тестирование переменных окружения

**Проверьте, правильно ли установлены переменные окружения:**

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

## 🤝 Вклад

Мы приветствуем Issues и Pull Requests для улучшения этого проекта!

1. Сделайте форк этого репозитория
2. Создайте ветку функции (`git checkout -b feature/AmazingFeature`)
3. Зафиксируйте ваши изменения (`git commit -m 'Add some AmazingFeature'`)
4. Отправьте в ветку (`git push origin feature/AmazingFeature`)
5. Создайте Pull Request

## 📄 Лицензия

Этот проект лицензирован под лицензией MIT - см. файл [LICENSE](LICENSE) для подробностей.

## 🔗 Связанные ссылки

- 🌐 [Открытая платформа Kimi](https://platform.moonshot.cn/)
- 📖 [Официальная документация Claude Code](https://docs.anthropic.com/claude/docs)
- 🐛 [Сообщение о проблемах](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [Обсуждения](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ Поддержка

Если этот проект помогает вам, дайте нам ⭐️!

---

**Отказ от ответственности**: Этот проект предназначен только для обучения и исследований. Пожалуйста, соблюдайте условия использования соответствующих API. 
