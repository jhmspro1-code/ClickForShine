#!/bin/bash

# ClickforShine Flutter - Build e Instalação Automática Android
# Este script compila o APK e instala automaticamente no dispositivo

set -e

echo ""
echo "========================================"
echo "  ClickforShine - Build Android"
echo "========================================"
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}[ERRO] Flutter não está instalado!${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Flutter detectado${NC}"
echo ""

# Verificar se Android SDK está instalado
if ! command -v adb &> /dev/null; then
    echo -e "${YELLOW}[AVISO] Android Debug Bridge (adb) não encontrado${NC}"
    echo "Certifique-se de que Android SDK está instalado"
fi

echo ""
echo "========================================"
echo "  Verificando Dispositivo"
echo "========================================"
echo ""

# Listar dispositivos conectados
adb devices

echo ""
echo "Aguardando dispositivo..."
adb wait-for-device

echo -e "${GREEN}[OK] Dispositivo detectado${NC}"
echo ""

echo "========================================"
echo "  Compilando APK"
echo "========================================"
echo ""

# Limpar build anterior
echo -e "${GREEN}[1/3] Limpando build anterior...${NC}"
flutter clean

# Obter dependências
echo -e "${GREEN}[2/3] Obtendo dependências...${NC}"
flutter pub get

# Compilar APK em release
echo -e "${GREEN}[3/3] Compilando APK (release)...${NC}"
flutter build apk --release

echo ""
echo "========================================"
echo "  Instalando no Dispositivo"
echo "========================================"
echo ""

# Encontrar o APK compilado
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ ! -f "$APK_PATH" ]; then
    echo -e "${RED}[ERRO] APK não encontrado em $APK_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] APK encontrado: $APK_PATH${NC}"
echo ""

# Instalar no dispositivo
echo "Instalando no dispositivo..."
adb install -r "$APK_PATH"

echo ""
echo "========================================"
echo "  Instalação Concluída!"
echo "========================================"
echo ""
echo -e "${GREEN}[OK] ClickforShine instalado com sucesso!${NC}"
echo ""
echo "O app deve aparecer na tela inicial do seu celular"
echo "Procure por: ClickforShine"
echo ""
echo "Próximos passos:"
echo "1. Abra o app no seu celular"
echo "2. Configure as chaves de API no arquivo .env"
echo "3. Comece a usar!"
echo ""
