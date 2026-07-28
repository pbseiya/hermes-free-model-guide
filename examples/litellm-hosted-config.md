# LiteLLM Hosted Configuration (Course 0)

Configuration สำหรับใช้ LiteLLM Proxy ที่ host บน Cloudflare Workers (Course 0)

---

## ใช้งาน

1. Copy ไฟล์นี้ไปเป็น `~/.hermes/config.yaml`
2. แก้ไข API Key ใน `~/.hermes/.env` (รับจาก instructor)
3. Restart Hermes

---

## config.yaml

```yaml
# Hermes Agent Configuration
# Using LiteLLM Proxy as model provider (Course 0)

model:
  provider: custom:litellm
  default: qwen3.7-plus

custom_providers:
  - name: litellm
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY

# Telegram Gateway
telegram:
  reactions: true
```

---

## .env

```bash
# ~/.hermes/.env

# LiteLLM Proxy API Key (Course 0)
LITELLM_API_KEY=sk_your_litellm_api_key_here
```

---

## Models ที่แนะนำ

| Model | เหมาะกับ |
|-------|----------|
| `qwen3.7-plus` | Default, สมดุลดี |
| `gpt-4o` | ฉลาด, งานทั่วไป |
| `claude-3.5-sonnet` | งานซับซ้อน, เขียนโค้ด |
| `gemini-2.0-flash` | เร็ว, เบา |

---

## เปลี่ยน Model

```bash
# เปลี่ยน model ใน session
/model qwen3.7-plus
/model gpt-4o

# เปลี่ยน model ถาวร
hermes config set model.default qwen3.7-plus
```

---

## สลับไปใช้ OKMD

ถ้า LiteLLM หมด quota หรือต้องการใช้ OKMD:

```bash
hermes config set model.provider custom:okmd
hermes config set model.default gpt-5.4-mini
```

---

## Links

- LiteLLM Docs: https://docs.litellm.ai/
