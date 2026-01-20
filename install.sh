#!/bin/bash

# ClickforShine Flutter - Instalador para macOS/Linux
# Este script configura o ambiente e instala todas as dependências

set -e

echo ""
echo "========================================"
echo "  ClickforShine Flutter - Instalador"
echo "========================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}[ERRO] Flutter não está instalado!${NC}"
    echo ""
    echo "Baixe Flutter em: https://flutter.dev/docs/get-started/install"
    echo "Após instalar, execute este script novamente."
    exit 1
fi

echo -e "${GREEN}[OK] Flutter detectado${NC}"
flutter --version
echo ""

# Verificar se Git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}[AVISO] Git não está instalado${NC}"
    echo "Você pode precisar de Git para clonar repositórios"
fi

echo ""
echo "========================================"
echo "  Instalando Dependências"
echo "========================================"
echo ""

# Instalar dependências do pubspec.yaml
echo -e "${GREEN}[1/4] Executando: flutter pub get${NC}"
flutter pub get

echo ""
echo -e "${GREEN}[2/4] Limpando build anterior${NC}"
flutter clean

echo ""
echo -e "${GREEN}[3/4] Obtendo pacotes novamente${NC}"
flutter pub get

echo ""
echo "========================================"
echo "  Configurando Firebase"
echo "========================================"
echo ""

echo -e "${GREEN}[4/4] Configurando Firebase...${NC}"
echo ""
echo "Para configurar Firebase:"
echo "1. Acesse: https://console.firebase.google.com"
echo "2. Crie um novo projeto"
echo "3. Execute: flutterfire configure"
echo ""
read -p "Deseja executar flutterfire configure agora? (s/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    flutterfire configure
fi

echo ""
echo "========================================"
echo "  Configurando Variáveis de Ambiente"
echo "========================================"
echo ""

if [ ! -f ".env" ]; then
    echo "Copiando .env.example para .env..."
    cp .env.example .env
    echo -e "${GREEN}[OK] Arquivo .env criado${NC}"
    echo ""
    echo -e "${YELLOW}[IMPORTANTE] Edite o arquivo .env com suas chaves de API:${NC}"
    echo "- AZURE_VISION_KEY"
    echo "- OPENAI_API_KEY"
    echo "- GOOGLE_CLOUD_API_KEY"
    echo "- FIREBASE_API_KEY"
    echo ""
else
    echo -e "${GREEN}[OK] Arquivo .env já existe${NC}"
fi

echo ""
echo "========================================"
echo "  Instalação Concluída!"
echo "========================================"
echo ""
echo "Próximos passos:"
echo "1. Edite o arquivo .env com suas chaves de API"
echo "2. Execute: flutter run"
echo "3. Ou: flutter run -d chrome (para web)"
echo ""
echo "Documentação:"
echo "- README.md - Visão geral"
echo "- QUICK_START.md - Setup rápido"
echo "- docs/ELITE_INTEGRATION.md - Integração com APIs"
echo ""
