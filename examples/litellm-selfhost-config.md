# LiteLLM Self-host Configuration

Configuration สำหรับใช้ LiteLLM Proxy ที่ self-host เอง (Advanced Users)

---

## ติดตั้ง LiteLLM

### วิธีที่ 1: Docker (แนะนำ)

```bash
docker run -d \
  --name litellm \
  -p 4000:4000 \
  -e OPENAI_API_KEY=sk-... \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -e GEMINI_API_KEY=AIza... \
  ghcr.io/berriai/litellm:main-latest
```

### วิธีที่ 2: Python

```bash
pip install litellm[proxy]

# สร้าง config file
cat > litellm_config.yaml << 'EOF'
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: claude-3.5-sonnet
    litellm_params:
      model: anthropic/claude-3.5-sonnet
      api_key: os.environ/ANTHROPIC_API_KEY
  
  - model_name: gemini-2.0-flash
    litellm_params:
      model: gemini/gemini-2.0-flash-exp
      api_key: os.environ/GEMINI_API_KEY

router_settings:
  routing_strategy: simple-shuffle
  num_retries: 3
  retry_after: 5
EOF

# เริ่ม proxy
litellm --config litellm_config.yaml --port 4000
```

---

## Hermes Configuration

### config.yaml

```yaml
# Hermes Agent Configuration
# Using LiteLLM Self-host as model provider

model:
  provider: custom:litellm
  default: gpt-4o

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
LITELLM_API_KEY=sk-your-litellm-key

# หรือปล่อยว่างถ้าไม่มี authentication
# LITELLM_API_KEY=
```

---

## LiteLLM Config Examples

### หลาย Providers

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: claude-3.5-sonnet
    litellm_params:
      model: anthropic/claude-3.5-sonnet
      api_key: os.environ/ANTHROPIC_API_KEY
  
  - model_name: gemini-2.0-flash
    litellm_params:
      model: gemini/gemini-2.0-flash-exp
      api_key: os.environ/GEMINI_API_KEY
```

### Load Balancing

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY_1
  
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY_2

router_settings:
  routing_strategy: simple-shuffle
  num_retries: 3
  retry_after: 5
```

### Fallback

```yaml
# litellm_config.yaml
model_list:
  - model_name: default
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: default-fallback
    litellm_params:
      model: anthropic/claude-3.5-sonnet
      api_key: os.environ/ANTHROPIC_API_KEY

router_settings:
  fallbacks:
    - default: ["default-fallback"]
  num_retries: 3
```

---

## ตรวจสอบ LiteLLM

```bash
# ตรวจสอบว่า LiteLLM ทำงานอยู่
curl http://localhost:4000/health

# ดู models ที่มี
curl http://localhost:4000/models
```

---

## Troubleshooting

### Connection refused

```bash
# ตรวจสอบว่า LiteLLM ทำงานอยู่
curl http://localhost:4000/health

# เริ่ม LiteLLM ใหม่
litellm --config litellm_config.yaml --port 4000
```

### Model not found

```bash
# ดู models ที่มี
curl http://localhost:4000/models

# ตรวจสอบ litellm_config.yaml
```

---

## Links

- LiteLLM Docs: https://docs.litellm.ai/
- LiteLLM GitHub: https://github.com/BerriAI/litellm
