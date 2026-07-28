# คู่มือตั้งค่า Model Provider และ API Key ใน Hermes Agent

> **⚠️ สำคัญ:** `hermes setup` **ไม่ถาม API key สำหรับ custom provider**
> ต้องใช้ `hermes model` หรือแก้ `config.yaml` โดยตรง

---

## สารบัญ

1. [ดู Provider ปัจจุบัน](#1-ดู-provider-ปัจจุบัน)
2. [เปลี่ยน Model แบบรวดเร็ว (Session)](#2-เปลี่ยน-model-แบบรวดเร็ว-session)
3. [ตั้งค่า Custom Provider (วิธีที่แนะนำ)](#3-ตั้งค่า-custom-provider-วิธีที่แนะนำ)
4. [ตั้งค่า Custom Provider (แก้ config.yaml โดยตรง)](#4-ตั้งค่า-custom-provider-แก้-configyaml-โดยตรง)
5. [Built-in Providers](#5-built-in-providers)
6. [เปลี่ยน API Key](#6-เปลี่ยน-api-key)
7. [ตรวจสอบและทดสอบ](#7-ตรวจสอบและทดสอบ)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. ดู Provider ปัจจุบัน

### ดู Provider และ Model ที่ใช้อยู่

```bash
hermes config get model
```

**ตัวอย่างผลลัพธ์:**

```yaml
model:
  provider: custom:okmd
  default: gpt-5.4-mini
```

### ดู Environment Variables (API Keys)

```bash
hermes env show
```

### ดู Config ทั้งหมด

```bash
hermes config get
```

---

## 2. เปลี่ยน Model แบบรวดเร็ว (Session)

> ใช้สำหรับเปลี่ยน model ใน session ปัจจุบันเท่านั้น **ไม่บันทึกถาวร**

### ใน Interactive Session

```bash
hermes

# เปลี่ยน model (ใช้ /model)
/model openrouter/anthropic/claude-3.5-sonnet
/model custom:okmd/gpt-5.4-mini
/model google/gemini-2.0-flash-exp
```

### ใน Command Line

```bash
# ใช้ model เดิมจาก config
hermes "สวัสดี"
```

**หมายเหตุ:** เมื่อเริ่ม session ใหม่ จะกลับไปใช้ provider/model เดิมจาก config

---

## 3. ตั้งค่า Custom Provider (วิธีที่แนะนำ)

### ใช้ `hermes model` (Interactive)

```bash
hermes model
```

**ขั้นตอน:**

1. เลือก **"Custom endpoint (self-hosted / VLLM / etc.)"**
2. ใส่ **Base URL** (เช่น `https://gen.ai.kku.ac.th/okmd/api/v1`)
3. ใส่ **API Key** (เช่น `sk_...`)
4. ใส่ **Model name** (เช่น `gpt-5.4-mini`)

**ข้อดี:**
- ✅ ถาม API key สำหรับ custom provider
- ✅ บันทึก config ให้อัตโนมัติ
- ✅ ทดสอบ connection ให้ทันที

**ตัวอย่าง:**

```bash
$ hermes model

? Select provider: Custom endpoint (self-hosted / VLLM / etc.)
? Enter API base URL: https://gen.ai.kku.ac.th/okmd/api/v1
? Enter API key (leave empty for local): sk_...
? Enter model name: gpt-5.4-mini

✓ Provider configured successfully
✓ Test request successful
```

**ไฟล์ที่ถูกแก้ไข:**

- `~/.hermes/config.yaml` - เพิ่ม `custom_providers` และ `model`
- `~/.hermes/.env` - เพิ่ม API key

---

## 4. ตั้งค่า Custom Provider (แก้ config.yaml โดยตรง)

### ขั้นตอนที่ 1: แก้ `config.yaml`

```bash
hermes config edit
```

**เพิ่มส่วน `custom_providers`:**

```yaml
# ~/.hermes/config.yaml

# Custom providers
custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY

# Model configuration
model:
  default: gpt-5.4-mini
  provider: custom:okmd
```

**คำอธิบาย:**

- `name`: ชื่อ provider (ใช้กับ `custom:<name>`)
- `base_url`: URL ของ API endpoint (ไม่ต้องใส่ `/chat/completions`)
- `key_env`: ชื่อ environment variable ที่จะใช้เก็บ API key
- `provider`: ใช้รูปแบบ `custom:<name>`

### ขั้นตอนที่ 2: ตั้ง API Key ใน `.env`

```bash
hermes env edit
```

**เพิ่มบรรทัดนี้:**

```bash
# ~/.hermes/.env
OKMD_API_KEY=sk_your_actual_key_here
```

**หรือใช้คำสั่ง:**

```bash
hermes env set OKMD_API_KEY sk_your_actual_key_here
```

### ขั้นตอนที่ 3: ทดสอบ

```bash
# ทดสอบ provider
hermes model test

# หรือเริ่มใช้งาน
hermes
```

---

## 5. Built-in Providers

Hermes รองรับ Provider สำเร็จรูป ไม่ต้องตั้งค่า `custom_providers`

### OpenRouter (แนะนำ)

**ข้อดี:** เข้าถึง model หลายตัวด้วย API key เดียว

```bash
hermes model
# เลือก: openrouter
# ใส่ API key: sk-or-v1-...
# เลือก model: anthropic/claude-3.5-sonnet
```

**หรือแก้ config โดยตรง:**

```yaml
# ~/.hermes/config.yaml
model:
  provider: openrouter
  default: anthropic/claude-3.5-sonnet
```

```bash
# ~/.hermes/.env
OPENROUTER_API_KEY=sk-or-v1-...
```

**Models ที่แนะนำ:**

| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `anthropic/claude-3.5-sonnet` | $3/$15 per 1M | งานทั่วไป |
| `openai/gpt-4o` | $5/$15 per 1M | สมดุลดี |
| `google/gemini-2.0-flash-exp` | ฟรี | ทดสอบ |
| `meta-llama/llama-3.3-70b-instruct` | ฟรี | Opensource |

**สมัคร:** https://openrouter.ai/keys

---

### OpenAI

```bash
hermes model
# เลือก: openai
# ใส่ API key: sk-...
# เลือก model: gpt-4o
```

```yaml
# ~/.hermes/config.yaml
model:
  provider: openai
  default: gpt-4o
```

```bash
# ~/.hermes/.env
OPENAI_API_KEY=sk-...
```

**Models ที่แนะนำ:**

| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `gpt-4o` | $5/$15 per 1M | สมดุลดี |
| `gpt-4-turbo` | $10/$30 per 1M | งานซับซ้อน |
| `gpt-3.5-turbo` | $0.5/$1.5 per 1M | ถูก, เร็ว |

**สมัคร:** https://platform.openai.com/api-keys

---

### Anthropic (Claude)

```bash
hermes model
# เลือก: anthropic
# ใส่ API key: sk-ant-...
# เลือก model: claude-3.5-sonnet
```

```yaml
# ~/.hermes/config.yaml
model:
  provider: anthropic
  default: claude-3.5-sonnet
```

```bash
# ~/.hermes/.env
ANTHROPIC_API_KEY=sk-ant-...
```

**Models ที่แนะนำ:**

| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `claude-3.5-sonnet` | $3/$15 per 1M | สมดุลดี |
| `claude-3-opus` | $15/$75 per 1M | ฉลาดสุด |
| `claude-3-haiku` | $0.25/$1.25 per 1M | เร็ว, ถูก |

**สมัคร:** https://console.anthropic.com/

---

### Google Gemini

```bash
hermes model
# เลือก: google
# ใส่ API key: AIza...
# เลือก model: gemini-2.0-flash-exp
```

```yaml
# ~/.hermes/config.yaml
model:
  provider: google
  default: gemini-2.0-flash-exp
```

```bash
# ~/.hermes/.env
GOOGLE_API_KEY=AIza...
```

**Models ที่แนะนำ:**

| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `gemini-2.0-flash-exp` | ฟรี (ทดลอง) | ทดสอบ |
| `gemini-1.5-pro` | $1.25/$5 per 1M | งานทั่วไป |
| `gemini-1.5-flash` | $0.075/$0.30 per 1M | ถูก, เร็ว |

**สมัคร:** https://aistudio.google.com/app/apikey

---

### Groq (เร็วมาก)

**ใช้ custom provider:**

```yaml
# ~/.hermes/config.yaml
custom_providers:
  - name: groq
    base_url: https://api.groq.com/openai/v1
    key_env: GROQ_API_KEY

model:
  provider: custom:groq
  default: llama-3.3-70b-versatile
```

```bash
# ~/.hermes/.env
GROQ_API_KEY=gsk_...
```

**Models ที่แนะนำ:**

| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `llama-3.3-70b-versatile` | ฟรี (rate limit) | ทดสอบ |
| `llama-3.1-8b-instant` | ฟรี (rate limit) | เร็วมาก |

**สมัคร:** https://console.groq.com/keys

---

### Nous Portal (แนะนำ - รวมทุก model)

```bash
hermes setup --portal
# Login ด้วย OAuth
# เลือก provider: Nous Portal
```

**ข้อดี:**

- เข้าถึง 300+ models ด้วย subscription เดียว
- รวม Tool Gateway (web search, image gen, TTS)

**สมัคร:** https://portal.nousresearch.com

---

## 6. เปลี่ยน API Key

### ดู API Key ปัจจุบัน (masked)

```bash
hermes env show
```

### เปลี่ยน API Key

```bash
# วิธีที่ 1: ใช้คำสั่ง
hermes env set OKMD_API_KEY sk_new_key_here

# วิธีที่ 2: แก้ไฟล์โดยตรง
hermes env edit
```

### ลบ API Key

```bash
hermes env unset OKMD_API_KEY
```

---

## 7. ตรวจสอบและทดสอบ

### ดู Configuration ทั้งหมด

```bash
hermes config get
```

### ดู Environment Variables

```bash
hermes env show
```

### ทดสอบ Provider

```bash
# ทดสอบ provider ปัจจุบัน
hermes model test

# ทดสอบ provider เฉพาะ
hermes model test openrouter
hermes model test custom:okmd
```

### ทดสอบด้วยตัวเอง

```bash
hermes

# พิมพ์อะไรก็ได้
> สวัสดี
```

---

## 8. Troubleshooting

### ปัญหา: `hermes setup` ไม่ถาม API key สำหรับ custom provider

**สาเหตุ:** `hermes setup` เป็น wizard สำหรับ built-in providers เท่านั้น

**วิธีแก้:**

- ใช้ `hermes model` แทน (ถาม API key สำหรับ custom provider)
- หรือแก้ `config.yaml` โดยตรง (วิธีที่ 4)

---

### ปัญหา: "Provider not found"

**สาเหตุ:** ใส่ชื่อ provider ผิด

**วิธีแก้:**

```bash
# ดู providers ที่มี
hermes config get custom_providers

# ใช้ชื่อที่ถูกต้อง
hermes config set model.provider custom:okmd
```

---

### ปัญหา: "Invalid API key"

**สาเหตุ:** API key ผิด หรือไม่ได้ตั้งใน `.env`

**วิธีแก้:**

```bash
# ตรวจสอบ API key
hermes env show

# ตั้ง API key ใหม่
hermes env set OKMD_API_KEY sk_correct_key
```

---

### ปัญหา: "Model not available"

**สาเหตุ:** Model ไม่มีใน provider

**วิธีแก้:**

```bash
# ดู models ที่มี (สำหรับ custom provider)
curl -s https://gen.ai.kku.ac.th/okmd/api/v1/models \
  -H "Authorization: Bearer $OKMD_API_KEY"

# เปลี่ยน model
hermes config set model.default gpt-5.4-mini
```

---

### ปัญหา: "Connection refused"

**สาเหตุ:** base_url ผิด หรือ server ไม่ทำงาน

**วิธีแก้:**

```bash
# ตรวจสอบ base_url
hermes config get custom_providers

# ทดสอบ connection ด้วย curl
curl https://gen.ai.kku.ac.th/okmd/api/v1/models
```

---

## ตัวอย่าง: ตั้งค่า OKMD AI Playground

### วิธีที่ 1: ใช้ `hermes model` (แนะนำ)

```bash
hermes model
```

เลือก:

- Provider: **Custom endpoint**
- Base URL: `https://gen.ai.kku.ac.th/okmd/api/v1`
- API Key: `sk_...` (จาก playground.okmd.or.th)
- Model: `gpt-5.4-mini`

### วิธีที่ 2: แก้ config.yaml โดยตรง

```bash
hermes config edit
```

เพิ่ม:

```yaml
custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY

model:
  default: gpt-5.4-mini
  provider: custom:okmd
```

### ตั้ง API Key

```bash
hermes env set OKMD_API_KEY sk_your_key_here
```

### ทดสอบ

```bash
hermes model test
```

**สมัคร OKMD:** https://playground.okmd.or.th (ฟรีสำหรับสมาชิก TK Park)

---

## Custom Provider อื่นๆ

### Ollama (Local Model)

```yaml
# ~/.hermes/config.yaml
custom_providers:
  - name: ollama
    base_url: http://localhost:11434/api
    key_env: ""

model:
  provider: custom:ollama
  default: llama3.2
```

**ติดตั้ง:**

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama3.2
ollama serve
```

---

### Together AI

```yaml
# ~/.hermes/config.yaml
custom_providers:
  - name: together
    base_url: https://api.together.xyz/v1
    key_env: TOGETHER_API_KEY

model:
  provider: custom:together
  default: mistralai/Mixtral-8x7B-Instruct-v0.1
```

```bash
# ~/.hermes/.env
TOGETHER_API_KEY=your-together-key
```

---

## สรุปคำสั่งสำคัญ

| งาน | คำสั่ง |
|-----|--------|
| ดู provider ปัจจุบัน | `hermes config get model` |
| ตั้งค่า provider/model | `hermes model` |
| เปลี่ยน provider (quick) | `hermes config set model.provider openrouter` |
| เปลี่ยน model | `hermes config set model.default claude-3.5-sonnet` |
| ตั้ง API key | `hermes env set OPENROUTER_API_KEY sk-...` |
| ดู API key | `hermes env show` |
| แก้ config | `hermes config edit` |
| แก้ .env | `hermes env edit` |
| ทดสอบ provider | `hermes model test` |
| เปลี่ยน model (session) | `/model openrouter/claude-3.5-sonnet` |

---

## สรุป 3 วิธีตั้งค่า Provider

### วิธีที่ 1: `hermes model` (แนะนำ)

- ✅ ถาม API key สำหรับ custom provider
- ✅ Interactive
- ✅ บันทึกอัตโนมัติ

### วิธีที่ 2: แก้ `config.yaml` โดยตรง

- ✅ ควบคุมทุกอย่างได้
- ✅ เหมาะกับ automation
- ⚠️ ต้องตั้ง API key ใน `.env` เอง

### วิธีที่ 3: `/model` ใน session

- ✅ เร็ว
- ⚠️ ไม่บันทึกถาวร
- ⚠️ ใช้ได้เฉพาะ provider ที่มีอยู่แล้ว

---

**สร้างโดย:** Hermes Agent Training Team  
**อัพเดทล่าสุด:** 2026-01-26  
**เวอร์ชัน:** 2.0.0  
**อ้างอิง:** https://hermes-agent.nousresearch.com/docs/integrations/providers
