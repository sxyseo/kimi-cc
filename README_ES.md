# Kimi CC

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | **Español** | [Русский](README_RU.md)

Utiliza el último modelo de Kimi (kimi-k2-0711-preview) para impulsar tu Claude Code, proporcionando una solución de asistente de programación IA de bajo costo.

## ✨ Características

- 🚀 **Rentable**: Usa la API de Kimi en lugar de la costosa API de Anthropic Claude
- 🔧 **Instalación con un clic**: Scripts de instalación automatizados para Linux/macOS y Windows
- 🔄 **Integración perfecta**: Totalmente compatible con los flujos de trabajo existentes de Claude Code
- 🤖 **Modelo más reciente**: Impulsado por el modelo kimi-k2-0711-preview de Kimi
- 🛡️ **Seguro y confiable**: Gestión segura de claves API y configuración de variables de entorno

## 📋 Requisitos del sistema

- Node.js 18.0 o superior
- Administrador de paquetes npm
- Clave API de Moonshot válida

## 🚀 Instalación rápida

### 📝 Obtener clave API

1. Ve a la plataforma abierta de Kimi para solicitar una clave API

   👉 [Plataforma abierta de Kimi](https://platform.moonshot.cn/)

2. Regístrate/inicia sesión en tu cuenta y ve al centro de usuario
3. Navega a: **Centro de usuario** → **Gestión de claves API** → **Crear nueva clave API**
4. Copia la clave API generada (comienza con `sk-`)

### 💻 Instalación Linux / macOS

Instalación rápida - se te pedirá que ingreses tu clave API, luego presiona Enter para completar:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Instalación Windows

#### Método 1: Descargar script de instalación (Recomendado)

1. Descarga el script de instalación: [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. Haz clic derecho y selecciona "Ejecutar como administrador"
3. Sigue las indicaciones para ingresar tu clave API de Moonshot
4. Espera a que se complete la instalación

#### Método 2: Instalación por línea de comandos

En PowerShell:

```powershell
# Descargar y ejecutar script de instalación
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

O en el símbolo del sistema:

```cmd
# Usar curl para descargar (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ Verificación de instalación

Después de la instalación, reinicia tu terminal y ejecuta:

```bash
claude --version  # Verificar información de versión
claude           # Comenzar a usar Claude Code
```

## 🔧 Configuración manual

Si la instalación automática encuentra problemas, puedes configurar manualmente las variables de entorno:

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**Símbolo del sistema (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**Configuración permanente (Recomendado):**
1. Haz clic derecho en "Este equipo" → Propiedades → Configuración avanzada del sistema → Variables de entorno
2. Agrega las dos variables de entorno anteriores en "Variables de usuario"

## 🎯 Uso

Después de la instalación, puedes usarlo como el Claude Code original:

```bash
claude  # Iniciar conversación interactiva
```

## 🔍 Solución de problemas

### Problemas comunes

**P: "claude no se reconoce como un comando interno o externo"**
- Reinicia la ventana del terminal
- Verifica si Node.js y npm están instalados correctamente
- Reinstala: `npm install -g @anthropic-ai/claude-code`

**P: Error "Invalid API key"**
- Verifica si la clave API está configurada correctamente
- Asegúrate de que la clave API comience con `sk-`
- Vuelve a ejecutar el script de instalación

**P: Las variables de entorno de Windows no funcionan**
- Reinicia la ventana de línea de comandos
- Vuelve a iniciar sesión en el sistema
- Ejecuta el script de instalación con privilegios de administrador

### Prueba de variables de entorno

**Verifica si las variables de entorno están configuradas correctamente:**

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

## 🤝 Contribución

¡Damos la bienvenida a Issues y Pull Requests para mejorar este proyecto!

1. Haz fork de este repositorio
2. Crea tu rama de característica (`git checkout -b feature/AmazingFeature`)
3. Confirma tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Empuja a la rama (`git push origin feature/AmazingFeature`)
5. Crea un Pull Request

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🔗 Enlaces relacionados

- 🌐 [Plataforma abierta de Kimi](https://platform.moonshot.cn/)
- 📖 [Documentación oficial de Claude Code](https://docs.anthropic.com/claude/docs)
- 🐛 [Reporte de problemas](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [Discusiones](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ Soporte

¡Si este proyecto te ayuda, danos una ⭐️!

---

**Descargo de responsabilidad**: Este proyecto es solo para fines de aprendizaje e investigación. Por favor, cumple con los términos de uso de las APIs correspondientes. 