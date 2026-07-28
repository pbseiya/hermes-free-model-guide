# OpenRouter Configuration

Configuration สำหรับใช้ OpenRouter (เข้าถึงหลาย models ด้วย API key เดียว)

---

## สมัคร OpenRouter

1. เข้า 👉 https://openrouter.ai/keys
2. Login ด้วย Google Account
3. กด **"Create Key"**
4. Copy key ที่ได้ (ขึ้นต้นด้วย `sk-or-v1-...`)

---

## config.yaml

```yaml
# Hermes Agent Configuration
# Using OpenRouter as model provider

model:
  provider: openrouter
  default: anthropic/claude-3.5-sonnet
```

---

## .env

```bash
# ~/.hermes/.env

# OpenRouter API Key
OPENROUTER_API_KEY=sk-or-v1-your_openrouter_api_key_here
```

---

## Models ที่แนะนำ

### ฟรี

| Model | เหมาะกับ |
|-------|----------|
| `google/gemini-2.0-flash-exp` | ทดสอบ, เร็ว |
| `meta-llama/llama-3.3-70b-instruct` | Opensource, ฉลาด |
| `nvidia/llama-3.1-nemotron-70b-instruct` | เร็ว, เบา |

### เสียเงิน

| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `anthropic/claude-3.5-sonnet` | $3/$15 per 1M | สมดุลดี |
| `openai/gpt-4o` | $5/$15 per 1M | ฉลาด, งานทั่วไป |
| `openai/gpt-4-turbo` | $10/$30 per 1M | งานซับซ้อน |
| `anthropic/claude-3-opus` | $15/$75 per 1M | ฉลาดสุด |

---

## เปลี่ยน Model

```bash
# เปลี่ยน model ใน session
/model anthropic/claude-3.5-sonnet
/model openai/gpt-4o
/model google/gemini-2.0-flash-exp

# เปลี่ยน model ถาวร
hermes config set model.default anthropic/claude-3.5-sonnet
```

---

## ตรวจสอบ Models

```bash
# ดู models ที่มี
hermes model
```

---

## Links

- OpenRouter: https://openrouter.ai/
- OpenRouter Models: https://openrouter.ai/models
