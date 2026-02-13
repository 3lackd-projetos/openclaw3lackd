---
name: ollama-delegate
description: Delegate simpler or private tasks to local Ollama models (Llama 3, Mistral, etc.) to save costs or ensure privacy.
---

# Ollama Delegate

Use this skill when the user asks to "run locally", "use ollama", or for tasks that require privacy or are simple enough for smaller models (summarization, data extraction, drafting).

## Usage

You can delegate work to Ollama by using the `sessions_send` tool (if available) or by spawning a sub-agent with the specific model ID.

### Supported Models

- `ollama/llama3`
- `ollama/mistral`
- `ollama/qwen2.5`

(Note: Ensure these models are pulled in Ollama: `ollama pull llama3`)

### Examples

**User:** "Summarize this text locally using Llama 3."
**Action:**
```javascript
// Pseudo-code for internal thought process
const summary = await agent.run({
  provider: "ollama",
  model: "llama3",
  prompt: "Summarize this: " + text
});
```
