# Heartbeat Checklist

Execute esta checklist silenciosamente a cada heartbeat. Só envie mensagem se houver itens que precisam de atenção.

## 1. Saúde do Sistema
- [ ] Verificar tamanho do MEMORY.md (`wc -c MEMORY.md`)
  - Se > 8000 chars: mover conteúdo antigo para `memory/archive/`
  - Se > 12000 chars: ALERTAR o usuário
- [ ] Verificar espaço em disco (`df -h /`)
  - Se < 10% livre: ALERTAR o usuário

## 2. Pendências
- [ ] Ler `memory/` do dia anterior para pendências não resolvidas
- [ ] Se houver pendências críticas, lembrar o usuário

## 3. Manutenção
- [ ] Se é domingo: consolidar registros da semana em `memory/archive/semana-YYYY-WW.md`
- [ ] Limpar arquivos temporários antigos se existirem

## Regras
- Se tudo estiver OK: responda apenas `HEARTBEAT_OK`
- Se algo precisar de atenção: envie um resumo curto
- NÃO repita tarefas de heartbeats anteriores
- NÃO invente tarefas — só reporte o que encontrou
