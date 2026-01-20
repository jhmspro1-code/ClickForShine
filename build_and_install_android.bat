@echo off
REM ClickforShine Flutter - Build e Instalação Automática Android (Windows)
REM Este script compila o APK e instala automaticamente no dispositivo

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   ClickforShine - Build Android
echo ========================================
echo.

REM Verificar se Flutter está instalado
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Flutter não está instalado!
    pause
    exit /b 1
)

echo [OK] Flutter detectado
echo.

REM Verificar se Android SDK está instalado
adb version >nul 2>&1
if errorlevel 1 (
    echo [AVISO] Android Debug Bridge (adb) não encontrado
    echo Certifique-se de que Android SDK está instalado
)

echo.
echo ========================================
echo   Verificando Dispositivo
echo ========================================
echo.

echo Dispositivos conectados:
adb devices

echo.
echo Aguardando dispositivo...
adb wait-for-device

echo [OK] Dispositivo detectado
echo.

echo ========================================
echo   Compilando APK
echo ========================================
echo.

REM Limpar build anterior
echo [1/3] Limpando build anterior...
call flutter clean

REM Obter dependências
echo [2/3] Obtendo dependências...
call flutter pub get

REM Compilar APK em release
echo [3/3] Compilando APK (release)...
call flutter build apk --release

echo.
echo ========================================
echo   Instalando no Dispositivo
echo ========================================
echo.

REM Encontrar o APK compilado
set APK_PATH=build\app\outputs\flutter-apk\app-release.apk

if not exist "%APK_PATH%" (
    echo [ERRO] APK não encontrado em %APK_PATH%
    pause
    exit /b 1
)

echo [OK] APK encontrado: %APK_PATH%
echo.

REM Instalar no dispositivo
echo Instalando no dispositivo...
call adb install -r "%APK_PATH%"

echo.
echo ========================================
echo   Instalação Concluída!
echo ========================================
echo.
echo [OK] ClickforShine instalado com sucesso!
echo.
echo O app deve aparecer na tela inicial do seu celular
echo Procure por: ClickforShine
echo.
echo Próximos passos:
echo 1. Abra o app no seu celular
echo 2. Configure as chaves de API no arquivo .env
echo 3. Comece a usar!
echo.

pause
