# Fallback Configuration

Configuration สำหรับใช้หลาย providers พร้อม fallback อัตโนมัติ

---

## ตัวอย่างที่ 1: OKMD + LiteLLM Fallback

ใช้ OKMD เป็นหลัก, ถ้า quota หมดให้ใช้ LiteLLM

### config.yaml

```yaml
# Hermes Agent Configuration
# Using OKMD with LiteLLM fallback

model:
  provider: custom:okmd
  default: gpt-5.4-mini
  fallbacks:
    - qwen3.7-plus

custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
  
  - name: litellm
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY

# Telegram Gateway
telegram:
  reactions: true
```

### .env

```bash
# ~/.hermes/.env

# OKMD API Key
OKMD_API_KEY=sk_your_okmd_api_key_here

# LiteLLM API Key
LITELLM_API_KEY=sk_your_litellm_api_key_here

# SSL workaround for OKMD
NODE_TLS_REJECT_UNAUTHORIZED=0
```

---

## ตัวอย่างที่ 2: OpenRouter + OpenAI Fallback

ใช้ OpenRouter เป็นหลัก, ถ้าล่มให้ใช้ OpenAI โดยตรง

### config.yaml

```yaml
# Hermes Agent Configuration
# Using OpenRouter with OpenAI fallback

model:
  provider: openrouter
  default: anthropic/claude-3.5-sonnet
  fallbacks:
    - openai/gpt-4o
```

### .env

```bash
# ~/.hermes/.env

# OpenRouter API Key
OPENROUTER_API_KEY=sk-or-v1-your_openrouter_api_key_here

# OpenAI API Key
OPENAI_API_KEY=sk-your_openai_api_key_here
```

---

## ตัวอย่างที่ 3: Multiple Fallbacks

ใช้ OKMD เป็นหลัก, ถ้าล่มให้ใช้ LiteLLM, ถ้าล่มอีกให้ใช้ OpenRouter

### config.yaml

```yaml
# Hermes Agent Configuration
# Using multiple fallbacks

model:
  provider: custom:okmd
  default: gpt-5.4-mini
  fallbacks:
    - qwen3.7-plus
    - anthropic/claude-3.5-sonnet

custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
  
  - name: litellm
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY

# Telegram Gateway
telegram:
  reactions: true
```

### .env

```bash
# ~/.hermes/.env

# OKMD API Key
OKMD_API_KEY=sk_your_okmd_api_key_here

# LiteLLM API Key
LITELLM_API_KEY=sk_your_litellm_api_key_here

# OpenRouter API Key
OPENROUTER_API_KEY=sk-or-v1-your_openrouter_api_key_here

# SSL workaround for OKMD
NODE_TLS_REJECT_UNAUTHORIZED=0
```

---

## ตัวอย่างที่ 4: LiteLLM Self-host with Load Balancing

ใช้ LiteLLM Self-host ที่มี load balancing และ fallback ในตัว

### litellm_config.yaml

```yaml
# LiteLLM Configuration with load balancing and fallback

model_list:
  # Primary: OpenAI
  - model_name: default
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  
  # Fallback 1: Anthropic
  - model_name: default-fallback-1
    litellm_params:
      model: anthropic/claude-3.5-sonnet
      api_key: os.environ/ANTHROPIC_API_KEY
  
  # Fallback 2: Google
  - model_name: default-fallback-2
    litellm_params:
      model: gemini/gemini-2.0-flash-exp
      api_key: os.environ/GEMINI_API_KEY

router_settings:
  routing_strategy: simple-shuffle
  fallbacks:
    - default: ["default-fallback-1", "default-fallback-2"]
  num_retries: 3
  retry_after: 5
  timeout: 60
```

### Hermes config.yaml

```yaml
# Hermes Agent Configuration
# Using LiteLLM Self-host

model:
  provider: custom:litellm
  default: default

custom_providers:
  - name: litellm
    base_url: http://localhost:4000
    key_env: LITELLM_API_KEY

# Telegram Gateway
telegram:
  reactions: true
```

### .env

```bash
# ~/.hermes/.env

# LiteLLM API Key (ถ้ามี authentication)
LITELLM_API_KEY=
```

---

## การทำงานของ Fallback

1. Hermes พยายามใช้ model หลัก (default)
2. ถ้าล้มเหลว (error, timeout, quota หมด) → ลองใช้ fallback ตัวแรก
3. ถ้ายังล้มเหลว → ลองใช้ fallback ตัวถัดไป
4. ถ้าทุกตัวล้มเหลว → แสดง error

---

## ตรวจสอบ Fallback

```bash
# ดู configuration
hermes config get model

# ทดสอบ provider
hermes model test
```

---

## Links

- Hermes Fallback Docs: https://hermes-agent.nousresearch.com/docs/user-guide/configuration#fallback-providers
- LiteLLM Fallback Docs: https://docs.litellm.ai/docs/routing
