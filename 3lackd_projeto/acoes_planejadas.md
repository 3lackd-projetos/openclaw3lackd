# Planejamento - 3lackd (OpenClaw)

Documento central para registro de entendimento do projeto e ações planejadas.

## Entendimento do Projeto

OpenClaw é um assistente de IA pessoal "local-first" projetado para ser o seu próprio copiloto em diversas plataformas.
Ele atua como um "Gateway" central websocket que se conecta a diversos canais de mensagens (WhatsApp, Telegram, Discord, Slack, etc.) e utiliza LLMs (como Anthropic Claude, OpenAI, etc.) para processar interações e executar ferramentas.

**Principais Componentes Identificados:**

- **Gateway (`src/`)**: O núcleo do sistema (Node.js/TypeScript), responsável por gerenciar sessões, conexões com canais, execução de ferramentas e roteamento de mensagens.
- **UI (`ui/`)**: Interface web para controle do gateway, dashboard e um WebChat integrado.
- **Packages (`packages/`)**: Estrutura monorepo gerenciada pelo `pnpm`, contendo bibliotecas compartilhadas e utilitários.
- **Apps & Nodes**: Suporte para aplicativos nativos (macOS, iOS, Android) que atuam como "nós" periféricos, permitindo ações locais (câmera, controle de sistema).

**Tecnologias Base:**

- **Runtime**: Node.js (versão 22+)
- **Linguagem**: TypeScript
- **Gerenciador de Pacotes**: pnpm
- **Infraestrutura**: Docker (opcional/recomendado para sandboxing)

## Ações Planejadas

> TUDO que for pedido e definirmos mudar deve ser escrito aqui (SEMPRE).

- [x] **Configuração do Repositório**: Clonar fork `3lackd-projetos/openclaw3lackd` e configurar upstream oficial. <!-- id: 1 -->
- [x] **Autenticação**: Resolver problemas de permissão no `git push`. <!-- id: 2 -->
- [x] **Documentação Inicial**: Criar pasta `3lackd_projeto` e arquivo `acoes_planejadas.md` com entendimento do projeto. <!-- id: 3 -->
- [x] **Análise de Arquitetura**: Verificar viabilidade de delegação IA de Mercado -> Ollama local. <!-- id: 4 -->

## Arquitetura de Delegação (Market AI -> Ollama)

**Status:** ✅ Totalmente Viável

A arquitetura do OpenClaw suporta nativamente o padrão de "Orquestrador" (seu "atendente" principal) delegando tarefas para outros agentes (seus "trabalhadores" locais via Ollama).

**Como funcionará:**

1. **Agente Principal ("Atendente")**:
   - Modelo: IA de Mercado (Claude 3.5 Sonnet, GPT-4o).
   - Função: Recebe o pedido do usuário, entende a intenção e decide se precisa delegar.
   - Ferramenta: Utiliza `sessions_send` para enviar mensagens para outras sessões.

2. **Agentes Trabalhadores (Local/VPS)**:
   - Modelo: Ollama (Llama 3, Mistral, etc.) rodando na sua VPS.
   - Configuração: O OpenClaw detecta automaticamente o Ollama local (`127.0.0.1:11434`).
   - Sessões: Podemos criar sessões específicas (ex: `worker-code`, `worker-analysis`) e fixar o modelo delas usando `sessions.patch`.

**Fluxo de Implementação:**

1. Garantir que o Ollama está rodando na VPS e acessível pelo OpenClaw.
2. Configurar o Agente Principal com um System Prompt que o instrua a usar `sessions_send` para delegar tarefas pesadas ou específicas.
3. Utilizar `sessions.patch` para definir que as sessões dos trabalhadores usem especificamente os modelos do Ollama.

**SEMPRE PESQUISE:**

1. Documentação oficial do projeto (OpenClaw)
2. Código fonte do projeto
3. Arquivos de configuração do projeto
4. Arquivos de teste do projeto
5. Arquivos de exemplo do projeto
6. Arquivos de documentação do projeto
7. Arquivos de documentação do projeto
8. Arquivos de documentação do projeto
9. Arquivos de documentação do projeto
10. Arquivos de documentação do projeto
11. https://docs.openclaw.ai/
