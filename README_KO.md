# Kimi CC

[中文](README.md) | [English](README_EN.md) | [日本語](README_JA.md) | **한국어** | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

Kimi의 최신 모델(kimi-k2-0711-preview)을 사용하여 Claude Code를 구동하고, 저비용 AI 프로그래밍 어시스턴트 솔루션을 제공합니다.

## ✨ 특징

- 🚀 **비용 효율적**: 비싼 Anthropic Claude API 대신 Kimi API 사용
- 🔧 **원클릭 설치**: Linux/macOS 및 Windows용 자동 설치 스크립트
- 🔄 **완벽한 통합**: 기존 Claude Code 워크플로우와 완전히 호환
- 🤖 **최신 모델**: Kimi의 kimi-k2-0711-preview 모델로 구동
- 🛡️ **안전하고 신뢰할 수 있음**: 안전한 API 키 관리 및 환경 변수 구성

## 📋 시스템 요구사항

- Node.js 18.0 이상
- npm 패키지 매니저
- 유효한 Moonshot API Key

## 🚀 빠른 설치

### 📝 API Key 획득

1. Kimi Open Platform에서 API Key를 신청

   👉 [Kimi Open Platform](https://platform.moonshot.cn/)

2. 계정을 등록/로그인하고 사용자 센터로 이동
3. 내비게이션: **사용자 센터** → **API Key 관리** → **새 API Key 생성**
4. 생성된 API Key(`sk-`로 시작)를 복사

### 💻 Linux / macOS 설치

빠른 설치 - API Key 입력을 요청하며, 마지막에 Enter를 눌러주세요:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Windows 설치

#### 방법 1: 설치 스크립트 다운로드 (권장)

1. 설치 스크립트 다운로드: [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. 마우스 오른쪽 클릭 후 "관리자 권한으로 실행" 선택
3. 프롬프트에 따라 Moonshot API Key 입력
4. 설치 완료까지 대기

#### 방법 2: 명령줄 설치

PowerShell에서:

```powershell
# 설치 스크립트 다운로드 및 실행
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

또는 명령 프롬프트에서:

```cmd
# curl을 사용하여 다운로드 (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ 설치 확인

설치 후 터미널을 재시작하고 실행:

```bash
claude --version  # 버전 정보 확인
claude           # Claude Code 사용 시작
```

## 🔧 수동 구성

자동 설치에 문제가 발생한 경우 환경 변수를 수동으로 구성할 수 있습니다:

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**명령 프롬프트 (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**영구 설정 (권장):**
1. "내 PC" 마우스 오른쪽 클릭 → 속성 → 고급 시스템 설정 → 환경 변수
2. "사용자 변수"에 위의 두 환경 변수 추가

## 🎯 사용법

설치 후 원래 Claude Code와 같은 방식으로 사용할 수 있습니다:

```bash
claude  # 대화형 대화 시작
```

## 🔍 문제 해결

### 일반적인 문제

**Q: "claude는 내부 또는 외부 명령으로 인식되지 않습니다"**
- 터미널 창 재시작
- Node.js와 npm이 올바르게 설치되었는지 확인
- 재설치: `npm install -g @anthropic-ai/claude-code`

**Q: "Invalid API key" 오류**
- API Key가 올바르게 설정되었는지 확인
- API Key가 `sk-`로 시작하는지 확인
- 설치 스크립트 재실행

**Q: Windows 환경 변수가 작동하지 않음**
- 명령줄 창 재시작
- 시스템에 다시 로그인
- 관리자 권한으로 설치 스크립트 실행

### 환경 변수 테스트

**환경 변수가 올바르게 설정되었는지 확인:**

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

## 🤝 기여

이 프로젝트를 개선하기 위한 Issues와 Pull Requests를 환영합니다!

1. 이 저장소를 포크
2. 기능 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시 (`git push origin feature/AmazingFeature`)
5. Pull Request 생성

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 라이선스가 부여됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🔗 관련 링크

- 🌐 [Kimi Open Platform](https://platform.moonshot.cn/)
- 📖 [Claude Code 공식 문서](https://docs.anthropic.com/claude/docs)
- 🐛 [문제 신고](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [토론](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ 지원

이 프로젝트가 도움이 되었다면 ⭐️를 주세요!

---

**면책조항**: 이 프로젝트는 학습 및 연구 목적으로만 사용됩니다. 관련 API의 사용 약관을 준수해 주세요. 