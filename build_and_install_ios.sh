#!/bin/bash

# ClickforShine Flutter - Build e Instalação Automática iOS
# Este script compila o IPA e instala automaticamente no dispositivo

set -e

echo ""
echo "========================================"
echo "  ClickforShine - Build iOS"
echo "========================================"
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se está em macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}[ERRO] Este script só funciona em macOS!${NC}"
    echo "Para compilar para iOS, você precisa de um Mac"
    exit 1
fi

echo -e "${GREEN}[OK] macOS detectado${NC}"
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}[ERRO] Flutter não está instalado!${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Flutter detectado${NC}"
echo ""

# Verificar se Xcode está instalado
if ! command -v xcode-select &> /dev/null; then
    echo -e "${RED}[ERRO] Xcode não está instalado!${NC}"
    echo "Instale Xcode do App Store"
    exit 1
fi

echo -e "${GREEN}[OK] Xcode detectado${NC}"
echo ""

echo "========================================"
echo "  Verificando Dispositivo"
echo "========================================"
echo ""

# Listar dispositivos conectados
echo "Dispositivos iOS conectados:"
xcrun xdevice list

echo ""
echo "Aguardando dispositivo..."

echo ""
echo "========================================"
echo "  Compilando IPA"
echo "========================================"
echo ""

# Limpar build anterior
echo -e "${GREEN}[1/4] Limpando build anterior...${NC}"
flutter clean

# Obter dependências
echo -e "${GREEN}[2/4] Obtendo dependências...${NC}"
flutter pub get

# Instalar pods
echo -e "${GREEN}[3/4] Instalando CocoaPods...${NC}"
cd ios
pod install --repo-update
cd ..

# Compilar IPA em release
echo -e "${GREEN}[4/4] Compilando IPA (release)...${NC}"
flutter build ipa --release

echo ""
echo "========================================"
echo "  Instalação no Dispositivo"
echo "========================================"
echo ""

# Encontrar o IPA compilado
IPA_PATH="build/ios/ipa/clickforshine.ipa"

if [ ! -f "$IPA_PATH" ]; then
    echo -e "${YELLOW}[AVISO] IPA não encontrado em $IPA_PATH${NC}"
    echo ""
    echo "Para instalar no dispositivo iOS:"
    echo "1. Abra Xcode"
    echo "2. Vá para: Window > Devices and Simulators"
    echo "3. Selecione seu dispositivo"
    echo "4. Arraste o IPA para a lista de apps"
    echo ""
    echo "Ou use:"
    echo "  ios-deploy --bundle build/ios/ipa/clickforshine.ipa"
    exit 1
fi

echo -e "${GREEN}[OK] IPA encontrado: $IPA_PATH${NC}"
echo ""

# Instalar usando ios-deploy (se disponível)
if command -v ios-deploy &> /dev/null; then
    echo "Instalando no dispositivo..."
    ios-deploy --bundle "$IPA_PATH"
    
    echo ""
    echo "========================================"
    echo "  Instalação Concluída!"
    echo "========================================"
    echo ""
    echo -e "${GREEN}[OK] ClickforShine instalado com sucesso!${NC}"
else
    echo -e "${YELLOW}[AVISO] ios-deploy não encontrado${NC}"
    echo ""
    echo "Instale com:"
    echo "  npm install -g ios-deploy"
    echo ""
    echo "Depois execute este script novamente"
fi

echo ""
echo "O app deve aparecer na tela inicial do seu iPhone/iPad"
echo "Procure por: ClickforShine"
echo ""
echo "Próximos passos:"
echo "1. Abra o app no seu dispositivo"
echo "2. Configure as chaves de API no arquivo .env"
echo "3. Comece a usar!"
echo ""
