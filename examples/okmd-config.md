# OKMD AI Playground Configuration

Configuration สำหรับใช้ OKMD AI Playground (ฟรี, quota สูงสุด 1M tokens/day)

---

## ใช้งาน

1. Copy ไฟล์นี้ไปเป็น `~/.hermes/config.yaml`
2. แก้ไข API Key ใน `~/.hermes/.env`
3. Restart Hermes

---

## config.yaml

```yaml
# Hermes Agent Configuration
# Using OKMD AI Playground as model provider

model:
  provider: custom:okmd
  default: gpt-5.4-mini

custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY

# Telegram Gateway
telegram:
  reactions: true
```

---

## .env

```bash
# ~/.hermes/.env

# OKMD AI Playground API Key
OKMD_API_KEY=sk_your_okmd_api_key_here

# SSL workaround for OKMD (self-signed certificate)
NODE_TLS_REJECT_UNAUTHORIZED=0
```

---

## Models ที่แนะนำ

| Model | Quota/วัน | เหมาะกับ |
|-------|-----------|----------|
| `deepseek-v4-flash` | 1,000,000 | ใช้เยอะ, quota เยอะสุด |
| `deepseek-v4-pro` | 1,000,000 | Reasoning, วิเคราะห์ |
| `gpt-5.4` | 350,000 | ฉลาดสุดของ OpenAI |
| `gpt-5.4-mini` | 350,000 | สมดุลดี (default) |
| `gpt-5.4-nano` | 350,000 | เร็ว, เบา |
| `llama-4-maverick` | 200,000 | Opensource, ฉลาด |
| `claude-sonnet-5` | 180,000 | งานซับซ้อน, เขียนโค้ด |

---

## เปลี่ยน Model

```bash
# เปลี่ยน model ใน session
/model deepseek-v4-flash
/model gpt-5.4-mini

# เปลี่ยน model ถาวร
hermes config set model.default deepseek-v4-flash
```

---

## Links

- OKMD Playground: https://playground.okmd.or.th
- OKMD API Docs: https://playground.okmd.or.th/docs/api
