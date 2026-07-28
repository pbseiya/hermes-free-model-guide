# คู่มือเปลี่ยน Model Provider และ API Key

คู่มือฉบับเต็มสำหรับการเปลี่ยน Model Provider และ API Key ใน Hermes Agent ทั้งแบบ Built-in และ Custom Provider

---

## สารบัญ

1. [ดู Provider ปัจจุบัน](#ดู-provider-ปัจจุบัน)
2. [เปลี่ยน Model แบบรวดเร็ว (Session)](#เปลี่ยน-model-แบบรวดเร็ว)
3. [เปลี่ยน Provider ถาวร](#เปลี่ยน-provider-ถาวร)
4. [Built-in Providers](#built-in-providers)
5. [Custom Provider (OKMD)](#custom-provider-okmd)
6. [Custom Provider อื่นๆ](#custom-provider-อื่นๆ)
7. [เปลี่ยน API Key](#เปลี่ยน-api-key)
8. [ตรวจสอบการตั้งค่า](#ตรวจสอบการตั้งค่า)

---

## ดู Provider ปัจจุบัน

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

### ดู API Key ที่ตั้งไว้

```bash
# ดูชื่อ environment variable ของ API key
hermes config get providers.okmd.key_env
# ผลลัพธ์: OKMD_API_KEY

# ดูค่าของ environment variable
hermes env show
```

---

## เปลี่ยน Model แบบรวดเร็ว

**ใช้สำหรับเปลี่ยน model ใน session ปัจจุบันเท่านั้น**

### ใน Interactive Session

```bash
# เปิด Hermes
hermes

# เปลี่ยน model
/model openrouter/anthropic/claude-3.5-sonnet
/model google/gemini-2.0-flash-exp
/model custom:okmd/claude-sonnet-5
```

### ใน Command Line

```bash
# ใช้ model หนึ่งครั้ง
hermes --provider openrouter --model anthropic/claude-3.5-sonnet "สวัสดี"

# ใช้ model เดิมจาก config
hermes "สวัสดี"
```

**หมายเหตุ:** การเปลี่ยนแบบนี้จะไม่บันทึกถาวร เมื่อเริ่ม session ใหม่จะกลับไปใช้ provider เดิม

---

## เปลี่ยน Provider ถาวร

### วิธีที่ 1: ใช้ hermes model (แนะนำ)

```bash
hermes model
```

**ขั้นตอน:**
1. เลือก Provider (OpenRouter, OpenAI, Anthropic, Google, Custom, ฯลฯ)
2. เลือก Model
3. ใส่ API Key (ถ้ายังไม่มี)
4. บันทึกการตั้งค่า

**ตัวอย่าง:**
```bash
$ hermes model

? Select provider: (Use arrow keys)
❯ openrouter
  openai
  anthropic
  google
  custom:okmd
  custom:other

? Select model: (Use arrow keys)
❯ anthropic/claude-3.5-sonnet
  anthropic/claude-3-opus
  anthropic/claude-3-haiku

? Enter API key: sk-or-v1-...

✓ Model changed successfully
```

### วิธีที่ 2: แก้ config.yaml โดยตรง

```bash
hermes config edit
```

**แก้ไขส่วน model:**
```yaml
model:
  provider: openrouter  # เปลี่ยน provider
  default: anthropic/claude-3.5-sonnet  # เปลี่ยน model
```

**แก้ไข providers (สำหรับ custom):**
```yaml
providers:
  openrouter:
    base_url: https://openrouter.ai/api/v1
    key_env: OPENROUTER_API_KEY
```

### วิธีที่ 3: ใช้ hermes config set

```bash
# เปลี่ยน provider
hermes config set model.provider openrouter

# เปลี่ยน model
hermes config set model.default anthropic/claude-3.5-sonnet

# เปลี่ยน API key environment variable
hermes config set providers.openrouter.key_env OPENROUTER_API_KEY
```

---

## Built-in Providers

Hermes รองรับ Provider สำเร็จรูป ไม่ต้องตั้งค่า base_url เอง

### 1. OpenRouter (แนะนำสำหรับมือใหม่)

**ข้อดี:** เข้าถึง model หลายตัวด้วย API key เดียว

```bash
hermes model
# เลือก: openrouter
# เลือก model: anthropic/claude-3.5-sonnet หรือ openai/gpt-4o
# ใส่ API key: sk-or-v1-...
```

**หรือใช้คำสั่ง:**
```bash
hermes config set model.provider openrouter
hermes config set model.default anthropic/claude-3.5-sonnet
hermes config set providers.openrouter.key_env OPENROUTER_API_KEY
```

**ตั้ง API Key:**
```bash
hermes env set OPENROUTER_API_KEY sk-or-v1-...
```

**Models ที่แนะนำ:**
| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `anthropic/claude-3.5-sonnet` | $3/$15 per 1M tokens | งานทั่วไป |
| `anthropic/claude-3-opus` | $15/$75 per 1M tokens | งานซับซ้อน |
| `openai/gpt-4o` | $5/$15 per 1M tokens | สมดุลดี |
| `google/gemini-2.0-flash-exp` | ฟรี | ทดสอบ |
| `meta-llama/llama-3.3-70b-instruct` | ฟรี | Opensource |

**สมัคร API Key:** https://openrouter.ai/keys

---

### 2. OpenAI (GPT Models)

```bash
hermes model
# เลือก: openai
# เลือก model: gpt-4o, gpt-4-turbo, gpt-3.5-turbo
# ใส่ API key: sk-...
```

**หรือใช้คำสั่ง:**
```bash
hermes config set model.provider openai
hermes config set model.default gpt-4o
hermes config set providers.openai.key_env OPENAI_API_KEY
```

**ตั้ง API Key:**
```bash
hermes env set OPENAI_API_KEY sk-...
```

**Models ที่แนะนำ:**
| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `gpt-4o` | $5/$15 per 1M tokens | สมดุลดี |
| `gpt-4-turbo` | $10/$30 per 1M tokens | งานซับซ้อน |
| `gpt-3.5-turbo` | $0.5/$1.5 per 1M tokens | ถูก, เร็ว |

**สมัคร API Key:** https://platform.openai.com/api-keys

---

### 3. Anthropic (Claude Models)

```bash
hermes model
# เลือก: anthropic
# เลือก model: claude-3.5-sonnet, claude-3-opus, claude-3-haiku
# ใส่ API key: sk-ant-...
```

**หรือใช้คำสั่ง:**
```bash
hermes config set model.provider anthropic
hermes config set model.default claude-3.5-sonnet
hermes config set providers.anthropic.key_env ANTHROPIC_API_KEY
```

**ตั้ง API Key:**
```bash
hermes env set ANTHROPIC_API_KEY sk-ant-...
```

**Models ที่แนะนำ:**
| Model | ราคา (Input/Output) | เหมาะกับ |
|-------|---------------------|----------|
| `claude-3.5-sonnet` | $3/$15 per 1M tokens | สมดุลดี |
| `claude-3-opus` | $15/$75 per 1M tokens | ฉลาดสุด |
| `claude-3-haiku` | $0.25/$1.25 per 1M tokens | เร็ว, ถูก |

**สมัคร API Key:** https://console.anthropic.com/

---

### 4. Google Gemini

```bash
hermes model
# เลือก: google
# เลือก model: gemini-2.0-flash-exp, gemini-1.5-pro, gemini-1.5-flash
# ใส่ API key: AIza...
```

**หรือใช้คำสั่ง:**
```bash
hermes config set model.provider google
hermes config set model.default gemini-2.0-flash-exp
hermes config set providers.google.key_env GOOGLE_API_KEY
```

**ตั้ง API Key:**
```bash
hermes env set GOOGLE_API_KEY AIza...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `gemini-2.0-flash-exp` | ฟรี (ช่วงทดลอง) | ทดสอบ |
| `gemini-1.5-pro` | $1.25/$5 per 1M tokens | งานทั่วไป |
| `gemini-1.5-flash` | $0.075/$0.30 per 1M tokens | ถูก, เร็ว |

**สมัคร API Key:** https://aistudio.google.com/app/apikey

---

### 5. Groq (เร็วมาก)

```bash
hermes model
# เลือก: groq
# เลือก model: llama-3.3-70b-versatile, llama-3.1-8b-instant
# ใส่ API key: gsk_...
```

**หรือใช้คำสั่ง:**
```bash
hermes config set model.provider groq
hermes config set model.default llama-3.3-70b-versatile
hermes config set providers.groq.key_env GROQ_API_KEY
```

**ตั้ง API Key:**
```bash
hermes env set GROQ_API_KEY gsk_...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `llama-3.3-70b-versatile` | ฟรี (มี rate limit) | ทดสอบ |
| `llama-3.1-8b-instant` | ฟรี (มี rate limit) | เร็วมาก |

**สมัคร API Key:** https://console.groq.com/keys

---

## Custom Provider (OKMD)

### ตั้งค่า OKMD (ฟรี 1M tokens/day)

```bash
# วิธีที่ 1: ใช้ hermes model
hermes model
# เลือก: custom:okmd
# เลือก model: gpt-5.4-mini, claude-sonnet-5, deepseek-v4-flash
# ใส่ API key: sk_...

# วิธีที่ 2: แก้ config โดยตรง
hermes config edit
```

**เพิ่มใน config.yaml:**
```yaml
model:
  provider: custom:okmd
  default: gpt-5.4-mini

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
```

**ตั้ง API Key:**
```bash
hermes env set OKMD_API_KEY sk_...
```

**สมัคร API Key:** https://playground.okmd.or.th/

**Models ที่แนะนำ:**
| Model | Quota/วัน | เหมาะกับ |
|-------|-----------|----------|
| `deepseek-v4-flash` | 1,000,000 | ใช้เยอะ |
| `deepseek-v4-pro` | 1,000,000 | Reasoning |
| `gpt-5.4` | 350,000 | ฉลาด |
| `gpt-5.4-mini` | 350,000 | สมดุล |
| `claude-sonnet-5` | 180,000 | งานซับซ้อน |
| `llama-4-maverick` | 200,000 | Opensource |

---

## Custom Provider อื่นๆ

### ตัวอย่าง: Azure OpenAI

```yaml
# ใน config.yaml
model:
  provider: custom:azure
  default: gpt-4

providers:
  azure:
    base_url: https://YOUR_RESOURCE_NAME.openai.azure.com/openai/deployments/YOUR_DEPLOYMENT_NAME
    key_env: AZURE_OPENAI_API_KEY
    transport: openai_chat
    headers:
      api-key: ${AZURE_OPENAI_API_KEY}
```

**ตั้ง API Key:**
```bash
hermes env set AZURE_OPENAI_API_KEY your-azure-key
```

---

### ตัวอย่าง: Ollama (Local Model)

```yaml
# ใน config.yaml
model:
  provider: custom:ollama
  default: llama3.2

providers:
  ollama:
    base_url: http://localhost:11434/api
    key_env: ""  # ไม่ต้องใช้ API key
    transport: ollama
```

**ติดตั้ง Ollama:**
```bash
# Linux/macOS
curl -fsSL https://ollama.com/install.sh | sh

# ดาวน์โหลด model
ollama pull llama3.2
ollama pull mistral
```

**เริ่ม Ollama:**
```bash
ollama serve
```

---

### ตัวอย่าง: vLLM (Self-hosted)

```yaml
# ใน config.yaml
model:
  provider: custom:vllm
  default: meta-llama/Llama-3.1-8B-Instruct

providers:
  vllm:
    base_url: http://localhost:8000/v1
    key_env: ""  # ไม่ต้องใช้ API key
    transport: openai_chat
```

---

## เปลี่ยน API Key

### ดู API Key ปัจจุบัน

```bash
# ดูชื่อ environment variable
hermes config get providers.okmd.key_env
# ผลลัพธ์: OKMD_API_KEY

# ดูค่าปัจจุบัน (masked)
hermes env show
```

### เปลี่ยน API Key

```bash
# วิธีที่ 1: ใช้ hermes env set
hermes env set OKMD_API_KEY sk_new_key_here

# วิธีที่ 2: แก้ไฟล์ .env โดยตรง
hermes env edit
# แก้ไขบรรทัด: OKMD_API_KEY=sk_new_key_here

# วิธีที่ 3: ใช้ environment variable ชั่วคราว (session นี้เท่านั้น)
export OKMD_API_KEY=sk_new_key_here
hermes
```

### ลบ API Key

```bash
# ลบออกจาก .env
hermes env unset OKMD_API_KEY

# หรือลบชั่วคราว (session นี้)
unset OKMD_API_KEY
```

---

## ตรวจสอบการตั้งค่า

### ดู Configuration ทั้งหมด

```bash
hermes config get
```

**ตัวอย่างผลลัพธ์:**
```yaml
model:
  provider: custom:okmd
  default: gpt-5.4-mini

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
```

### ดู Environment Variables

```bash
hermes env show
```

**ตัวอย่างผลลัพธ์:**
```
OKMD_API_KEY: sk_*** (set)
TELEGRAM_BOT_TOKEN: 123*** (set)
TELEGRAM_CHAT_ID: 123*** (set)
```

### ทดสอบการเชื่อมต่อ

```bash
# ทดสอบ provider ปัจจุบัน
hermes model test

# ทดสอบ provider เฉพาะ
hermes model test openrouter
hermes model test custom:okmd
```

---

## ตัวอย่างการใช้งานจริง

### ตัวอย่างที่ 1: เปลี่ยนจาก OKMD เป็น OpenRouter

```bash
# ดู provider ปัจจุบัน
hermes config get model

# เปลี่ยน provider
hermes model
# เลือก: openrouter
# เลือก model: anthropic/claude-3.5-sonnet
# ใส่ API key: sk-or-v1-...

# ตรวจสอบ
hermes config get model
```

### ตัวอย่างที่ 2: เปลี่ยนจาก OpenRouter เป็น Google Gemini

```bash
# เปลี่ยน provider
hermes config set model.provider google
hermes config set model.default gemini-2.0-flash-exp
hermes config set providers.google.key_env GOOGLE_API_KEY

# ตั้ง API key
hermes env set GOOGLE_API_KEY AIza...

# ตรวจสอบ
hermes model test google
```

### ตัวอย่างที่ 3: เพิ่ม Custom Provider ใหม่

```bash
# แก้ config
hermes config edit

# เพิ่ม providers section
providers:
  myapi:
    base_url: https://api.myprovider.com/v1
    key_env: MYAPI_KEY
    transport: openai_chat

# ตั้ง model
hermes config set model.provider custom:myapi
hermes config set model.default gpt-4

# ตั้ง API key
hermes env set MYAPI_KEY sk-...

# ตรวจสอบ
hermes model test custom:myapi
```

---

## สรุปคำสั่งสำคัญ

| งาน | คำสั่ง |
|-----|--------|
| ดู provider ปัจจุบัน | `hermes config get model` |
| เปลี่ยน provider | `hermes model` |
| เปลี่ยน provider (quick) | `hermes config set model.provider openrouter` |
| เปลี่ยน model | `hermes config set model.default claude-3.5-sonnet` |
| ตั้ง API key | `hermes env set OPENROUTER_API_KEY sk-...` |
| ดู API key | `hermes env show` |
| แก้ config | `hermes config edit` |
| แก้ .env | `hermes env edit` |
| ทดสอบ provider | `hermes model test` |
| เปลี่ยน model (session) | `/model openrouter/claude-3.5-sonnet` |

---

## Troubleshooting

### ปัญหา: "Provider not found"

**สาเหตุ:** ใส่ชื่อ provider ผิด

**วิธีแก้:**
```bash
# ดู providers ที่มี
hermes config get providers

# ใช้ชื่อที่ถูกต้อง
hermes config set model.provider openrouter
```

---

### ปัญหา: "Invalid API key"

**สาเหตุ:** API key ผิดหรือหมดอายุ

**วิธีแก้:**
```bash
# ตรวจสอบ API key
hermes env show

# ตั้ง API key ใหม่
hermes env set OPENROUTER_API_KEY sk-new-key

# ทดสอบ
hermes model test openrouter
```

---

### ปัญหา: "Model not available"

**สาเหตุ:** Model ไม่มีใน provider หรือต้องสมัครพิเศษ

**วิธีแก้:**
```bash
# ดู models ที่มี
hermes model list

# เปลี่ยน model
hermes config set model.default anthropic/claude-3.5-sonnet
```

---

### ปัญหา: "Connection refused"

**สาเหตุ:** base_url ผิด หรือ server ไม่ทำงาน

**วิธีแก้:**
```bash
# ตรวจสอบ base_url
hermes config get providers.okmd.base_url

# ทดสอบ connection
curl https://gen.ai.kku.ac.th/okmd/api/v1/models
```

---

**สร้างโดย:** Hermes Agent Training Team  
**อัพเดทล่าสุด:** 2026-01-26  
**เวอร์ชัน:** 1.0
