@echo off
REM ClickforShine Flutter - Instalador para Windows
REM Este script configura o ambiente e instala todas as dependências

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   ClickforShine Flutter - Instalador
echo ========================================
echo.

REM Verificar se Flutter está instalado
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Flutter não está instalado!
    echo.
    echo Baixe Flutter em: https://flutter.dev/docs/get-started/install/windows
    echo Após instalar, execute este script novamente.
    pause
    exit /b 1
)

echo [OK] Flutter detectado
echo.

REM Verificar se Git está instalado
git --version >nul 2>&1
if errorlevel 1 (
    echo [AVISO] Git não está instalado
    echo Você pode precisar de Git para clonar repositórios
)

echo.
echo ========================================
echo   Instalando Dependências
echo ========================================
echo.

REM Instalar dependências do pubspec.yaml
echo [1/4] Executando: flutter pub get
call flutter pub get
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependências
    pause
    exit /b 1
)

echo.
echo [2/4] Limpando build anterior
call flutter clean

echo.
echo [3/4] Obtendo pacotes novamente
call flutter pub get

echo.
echo ========================================
echo   Configurando Firebase
echo ========================================
echo.

echo [4/4] Configurando Firebase...
echo.
echo Para configurar Firebase:
echo 1. Acesse: https://console.firebase.google.com
echo 2. Crie um novo projeto
echo 3. Execute: flutterfire configure
echo.
echo Deseja executar flutterfire configure agora? (S/N)
set /p choice=Resposta: 
if /i "%choice%"=="S" (
    call flutterfire configure
)

echo.
echo ========================================
echo   Configurando Variáveis de Ambiente
echo ========================================
echo.

if not exist ".env" (
    echo Copiando .env.example para .env...
    copy .env.example .env
    echo [OK] Arquivo .env criado
    echo.
    echo [IMPORTANTE] Edite o arquivo .env com suas chaves de API:
    echo - AZURE_VISION_KEY
    echo - OPENAI_API_KEY
    echo - GOOGLE_CLOUD_API_KEY
    echo - FIREBASE_API_KEY
    echo.
) else (
    echo [OK] Arquivo .env já existe
)

echo.
echo ========================================
echo   Instalação Concluída!
echo ========================================
echo.
echo Próximos passos:
echo 1. Edite o arquivo .env com suas chaves de API
echo 2. Execute: flutter run
echo 3. Ou: flutter run -d chrome (para web)
echo.
echo Documentação:
echo - README.md - Visão geral
echo - QUICK_START.md - Setup rápido
echo - docs/ELITE_INTEGRATION.md - Integração com APIs
echo.

pause
