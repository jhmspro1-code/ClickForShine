# Algoritmo SmartShine - Documentação Técnica

## 🎯 Objetivo

O algoritmo SmartShine calcula automaticamente as recomendações de polimento baseado em:
1. **Dureza da Superfície** (S): 1-10
2. **Nível de Dano** (D): 1-10
3. **Setor Especializado**: Automotivo, Náutico, Aeronáutico, Industrial

## 📐 Fórmula Principal

```
Agressividade = (S × 0.4) + (D × 0.6)
```

**Interpretação**:
- O dano tem **60% de peso** (mais importante)
- A dureza tem **40% de peso** (menos importante)
- Resultado: 0-10 (onde 10 é máxima agressividade)

## 📊 Tabela de Decisão

| Agressividade | Nível de Corte | Ação Recomendada |
|---|---|---|
| < 3 | 0 | Apenas Lustro e Proteção |
| 3-5 | 1 | Refino leve com composto suave |
| 5-7 | 2 | Corte pesado com composto agressivo |
| > 7 | 3 | Lixamento + Corte pesado |

## 🚗 Recomendações por Setor

### Automotivo

**Superfícies**:
- Verniz Macio (S=3): Típico de carros asiáticos
- Verniz Médio (S=5): Padrão europeu
- Verniz Duro (S=7): Alta dureza
- Revestimento Cerâmico (S=9): Proteção premium

**Defeitos Comuns**:
- Swirls (D=2): Marcas de lavagem
- Hologramas (D=3): Reflexo ondulado
- Riscos (D=5): RIDs profundos
- Oxidação (D=6): Oxidação superficial

**Exemplo**:
```
Verniz Médio + Swirls
S = 5, D = 2
Agressividade = (5 × 0.4) + (2 × 0.6) = 2.0 + 1.2 = 3.2

Resultado:
- Nível: 1 (Refino leve)
- RPM: 1200-1600
- Pad: Espuma Fina
- Composto: Refino Suave
- Segurança: 8.0/10
```

### Náutico

**Superfícies**:
- Gel Coat ISO (S=6): Padrão internacional
- Gel Coat NPG (S=5): Mais flexível
- Gel Coat Ortoftálico (S=4): Econômico
- Madeira Teca (S=5): Verniz náutico

**Defeitos Comuns**:
- Oxidação (D=6): Oxidação superficial
- Calcinação (D=4): Depósitos minerais
- Degradação (D=7): Deterioração do Gel Coat

**Exemplo**:
```
Gel Coat ISO + Oxidação
S = 6, D = 6
Agressividade = (6 × 0.4) + (6 × 0.6) = 2.4 + 3.6 = 6.0

Resultado:
- Nível: 2 (Corte pesado)
- RPM: 1400-1800
- Pad: Espuma Média
- Composto: Corte Gel Coat
- Segurança: 7.0/10
```

### Aeronáutico

**Superfícies**:
- Alumínio Polido (S=5): Fuselagem
- Poliuretano de Aviação (S=7): Pintura proteção
- Acrílico de Janela (S=2): Frágil
- Policarbonato de Janela (S=3): Resistente

**Defeitos Comuns**:
- Corrosão Superficial (D=7): Oxidação severa
- Riscos por Impacto (D=6): Dano mecânico

**⚠️ ALERTAS DE SEGURANÇA**:
- Limite de remoção de material em áreas críticas
- Usar equipamento calibrado para aviação
- Verificar micragem antes e depois

**Exemplo**:
```
Alumínio Polido + Corrosão Superficial
S = 5, D = 7
Agressividade = (5 × 0.4) + (7 × 0.6) = 2.0 + 4.2 = 6.2

Resultado:
- Nível: 2 (Corte pesado)
- RPM: 1200-1600 (REDUZIDO por segurança)
- Pad: Espuma Média Aero
- Composto: Corte Aero
- Segurança: 7.5/10
- ⚠️ ALERTAS: Verificar micragem, usar técnica profissional
```

### Industrial

**Superfícies**:
- Aço Inoxidável (S=8): Muito duro
- Bronze (S=6): Metal nobre
- Mármore (S=3): Poroso
- Granito (S=8): Muito duro
- Resina Epóxi (S=6): Revestimento

**Defeitos Comuns**:
- Oxidação (D=6): Oxidação superficial
- Manchas (D=4): Depósitos
- Desgaste (D=5): Deterioração

**Exemplo**:
```
Aço Inoxidável + Oxidação
S = 8, D = 6
Agressividade = (8 × 0.4) + (6 × 0.6) = 3.2 + 3.6 = 6.8

Resultado:
- Nível: 2 (Corte pesado)
- RPM: 1800-2200
- Pad: Espuma Média
- Composto: Corte Industrial
- Segurança: 6.0/10
```

## 🔧 Tabelas de RPM por Setor

### Automotivo

| Agressividade | RPM Range | Pad | Composto |
|---|---|---|---|
| 0-2 | 800-1200 | Microfibra | Lustro |
| 2-4 | 1200-1600 | Espuma Fina | Refino |
| 4-6 | 1600-2000 | Espuma Média | Corte Médio |
| 6-8 | 2000-2500 | Lã Agressiva | Corte Pesado |
| 8-10 | 2500-3000 | Lã Muito Agressiva | Corte Extremo |

### Náutico

| Agressividade | RPM Range | Pad | Composto |
|---|---|---|---|
| 0-2 | 600-1000 | Microfibra Marinha | Proteção UV |
| 2-4 | 1000-1400 | Espuma Fina | Refino Marinho |
| 4-6 | 1400-1800 | Espuma Média | Corte Gel Coat |
| 6-8 | 1800-2200 | Lã Marinha | Corte Pesado |
| 8-10 | 2200-2600 | Lã Muito Agressiva | Corte Extremo |

### Aeronáutico

| Agressividade | RPM Range | Pad | Composto |
|---|---|---|---|
| 0-2 | 500-800 | Microfibra Aero | Proteção Aero |
| 2-4 | 800-1200 | Espuma Fina Aero | Refino Aero |
| 4-6 | 1200-1600 | Espuma Média Aero | Corte Aero |
| 6-8 | 1600-2000 | Lã Aero | Corte Pesado Aero |
| 8-10 | 2000-2400 | Lã Muito Agressiva | Corte Extremo Aero |

### Industrial

| Agressividade | RPM Range | Pad | Composto |
|---|---|---|---|
| 0-2 | 1000-1400 | Microfibra Industrial | Proteção Industrial |
| 2-4 | 1400-1800 | Espuma Fina | Refino Industrial |
| 4-6 | 1800-2200 | Espuma Média | Corte Industrial |
| 6-8 | 2200-2800 | Lã Agressiva | Corte Pesado |
| 8-10 | 2800-3400 | Lã Muito Agressiva | Corte Extremo |

## 📈 Índice de Segurança

O índice de segurança (0-10) indica o risco de dano à superfície:

```
SafetyIndex = 10 - (Agressividade × 0.8)
```

| Índice | Nível | Descrição |
|---|---|---|
| 9-10 | ✅ Muito Seguro | Risco mínimo |
| 7-9 | ✅ Seguro | Risco baixo |
| 5-7 | ⚠️ Moderado | Requer cuidado |
| 3-5 | ⚠️ Arriscado | Técnica profissional recomendada |
| 0-3 | 🚨 Crítico | Apenas profissionais experientes |

## 🧮 Implementação em Dart

```dart
class CalculateAggressivenessUseCase {
  AggressivenessResult call({
    required double surfaceHardness,
    required double damageLevel,
    required String sector,
  }) {
    // Validar entrada
    final s = surfaceHardness.clamp(1.0, 10.0);
    final d = damageLevel.clamp(1.0, 10.0);

    // Algoritmo SmartShine
    final aggressivenessScore = (s * 0.4) + (d * 0.6);

    // Calcular índice de segurança
    final safetyIndex = (10 - (aggressivenessScore * 0.8)).clamp(0.0, 10.0);

    // Determinar nível de corte
    int cuttingLevel;
    if (aggressivenessScore < 3) {
      cuttingLevel = 0;
    } else if (aggressivenessScore < 5) {
      cuttingLevel = 1;
    } else if (aggressivenessScore < 7) {
      cuttingLevel = 2;
    } else {
      cuttingLevel = 3;
    }

    // Buscar recomendações por setor
    final (rpmRange, padType, compoundType, _) = 
        _getSectorSpecificRecommendations(aggressivenessScore, cuttingLevel, sector);

    return AggressivenessResult(
      aggressivenessScore: aggressivenessScore,
      cuttingLevel: cuttingLevel,
      rpmRange: rpmRange,
      padType: padType,
      compoundType: compoundType,
      safetyIndex: safetyIndex,
      description: _getDescription(cuttingLevel),
      safetyNotes: _getSafetyNotes(sector, aggressivenessScore),
    );
  }
}
```

## 🔄 Fluxo de Cálculo

```
1. Usuário captura foto da superfície
   ↓
2. IA detecta tipo de superfície (S)
   ↓
3. IA detecta defeitos e calcula dano (D)
   ↓
4. SmartShine calcula: Agressividade = (S × 0.4) + (D × 0.6)
   ↓
5. Determina nível de corte (0-3)
   ↓
6. Busca recomendações por setor
   ↓
7. Calcula índice de segurança
   ↓
8. Exibe resultado com gráfico de dureza
```

## 📱 Exemplo de Uso

```dart
// 1. Criar use case
final useCase = CalculateAggressivenessUseCase();

// 2. Chamar com dados detectados
final result = useCase(
  surfaceHardness: 6.5,      // Detectado pela IA
  damageLevel: 5.0,          // Detectado pela IA
  sector: 'automotive',      // Selecionado pelo usuário
);

// 3. Exibir resultado
print('Agressividade: ${result.aggressivenessScore}');
print('RPM: ${result.rpmRange}');
print('Pad: ${result.padType}');
print('Composto: ${result.compoundType}');
print('Segurança: ${result.safetyIndex}/10');
```

## 🎓 Casos de Estudo

### Caso 1: Carro com Swirls Leves

```
Verniz Médio (S=5) + Swirls (D=2)
Agressividade = (5 × 0.4) + (2 × 0.6) = 3.2

✅ Resultado: Refino leve
- RPM: 1200-1600
- Pad: Espuma Fina
- Composto: Refino Suave
- Segurança: 7.4/10
```

### Caso 2: Barco com Oxidação Severa

```
Gel Coat ISO (S=6) + Oxidação Severa (D=8)
Agressividade = (6 × 0.4) + (8 × 0.6) = 7.2

⚠️ Resultado: Corte pesado
- RPM: 1600-2000
- Pad: Lã Marinha
- Composto: Corte Pesado
- Segurança: 4.2/10
- ⚠️ Requer técnica profissional
```

### Caso 3: Fuselagem com Corrosão

```
Alumínio Polido (S=5) + Corrosão (D=7)
Agressividade = (5 × 0.4) + (7 × 0.6) = 6.2

🚨 Resultado: Corte pesado com restrições
- RPM: 1200-1600 (REDUZIDO)
- Pad: Espuma Média Aero
- Composto: Corte Aero
- Segurança: 5.0/10
- 🚨 ALERTAS: Verificar micragem, área crítica
```

---

**Desenvolvido com base em padrões da indústria (Rupes, Koch-Chemie, 3M)**
