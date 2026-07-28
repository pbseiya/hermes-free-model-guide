# OpenAI Configuration

Configuration สำหรับใช้ OpenAI API (GPT-4, GPT-3.5)

---

## สมัคร OpenAI API

1. เข้า 👉 https://platform.openai.com/api-keys
2. Login ด้วย OpenAI Account
3. กด **"Create new secret key"**
4. Copy key ที่ได้ (ขึ้นต้นด้วย `sk-...`)

<div class="warning">

**ต้องมี billing setup** - OpenAI API ต้องเติมเงินก่อนใช้
ไม่สามารถใช้ ChatGPT Plus subscription แทน API key ได้

</div>

---

## config.yaml

```yaml
# Hermes Agent Configuration
# Using OpenAI as model provider

model:
  provider: openai
  default: gpt-4o
```

---

## .env

```bash
# ~/.hermes/.env

# OpenAI API Key
OPENAI_API_KEY=sk-your_openai_api_key_here
```

---

## Models ที่แนะนำ

| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `gpt-4o` | $5/$15 per 1M | สมดุลดี (แนะนำ) |
| `gpt-4-turbo` | $10/$30 per 1M | งานซับซ้อน |
| `gpt-4o-mini` | $0.15/$0.60 per 1M | ถูก, เร็ว |
| `gpt-3.5-turbo` | $0.5/$1.5 per 1M | ถูกที่สุด |

---

## เปลี่ยน Model

```bash
# เปลี่ยน model ใน session
/model gpt-4o
/model gpt-4-turbo
/model gpt-4o-mini

# เปลี่ยน model ถาวร
hermes config set model.default gpt-4o
```

---

## ตรวจสอบ Balance

1. เข้า 👉 https://platform.openai.com/usage
2. ดู usage และ balance

---

## Links

- OpenAI Platform: https://platform.openai.com/
- OpenAI Pricing: https://openai.com/pricing
- OpenAI Models: https://platform.openai.com/docs/models
