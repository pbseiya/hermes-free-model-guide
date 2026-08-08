---

marp: true
theme: default
paginate: true
footer: "ใช้ OKMD AI Playground — ฟรี 23 models สูงสุด 1M tokens/day"
style: |
  section {
    font-family: 'Sarabun', 'TH Sarabun New', sans-serif;
    background: white;
    font-size: 1em;
    padding: 20px 30px 60px 30px;
    line-height: 1.5;
  }
  h1 { color: #1e3a8a; font-size: 2.0em; margin-bottom: 0.3em; font-weight: 700; }
  h2 { color: #2563eb; font-size: 1.4em; margin-bottom: 0.2em; font-weight: 600; }
  h3 { font-size: 1.2em; margin-bottom: 0.15em; font-weight: 600; }
  p { margin: 0.3em 0; }
  ul, ol { margin: 0.2em 0; padding-left: 1.5em; }
  li { margin: 0.1em 0; }
  code {
    background: #f3f4f6;
    padding: 2px 4px;
    border-radius: 3px;
    font-family: 'Fira Code', monospace;
    font-size: 0.95em;
  }
  pre code {
    display: block;
    padding: 8px 12px;
    background: #1e293b;
    color: #e2e8f0;
    border-radius: 5px;
    font-size: 0.9em;
    line-height: 1.4;
    margin: 5px 0;
  }
  pre { margin: 5px 0; }
  table { width: 100%; border-collapse: collapse; margin: 8px 0; font-size: 1em; }
  th { background: #2563eb; color: white; padding: 8px 10px; text-align: left; font-weight: 600; }
  td { padding: 6px 10px; border-bottom: 1px solid #e5e7eb; }
  tr:nth-child(even) { background: #f9fafb; }
  .highlight { background: #fef3c7; padding: 10px 14px; border-left: 4px solid #f59e0b; margin: 8px 0; font-size: 1em; }
  .success { background: #E8F5E9; padding: 10px 14px; border-left: none; margin: 8px 0 20px 0; font-size: 0.9em; line-height: 1.4; border-radius: 8px; }
  .success ol { padding-left: 2em; }
  .success .note { font-weight: 600; margin-top: 6px; }
  .warning { background: #fee2e2; padding: 10px 14px; border-left: 4px solid #ef4444; margin: 8px 0; font-size: 1em; }
  .info { background: #dbeafe; padding: 10px 14px; border-left: 4px solid #3b82f6; margin: 8px 0; font-size: 1em; }
  footer { bottom: 5px; right: 10px; font-size: 0.65em; text-align: right; }
  section { overflow: hidden; }
  .avatar-left { position: absolute; left: 0; top: 0; width: 43%; height: 100%; overflow: hidden; z-index: 0; }
  .avatar-left img { width: 100%; height: 100%; object-fit: cover; object-position: center center; }
  .content-right { position: relative; margin-left: 45%; padding: 25px 25px 30px 15px; z-index: 1; }
  .header-small { font-size: 0.75em; color: #757575; margin-bottom: 10px; }
  .tagline { font-size: 0.85em; font-weight: normal; color: #6b7280; margin-top: 10px; }
---

<div class="avatar-left">
<img src="../images/hermes-mascot-v1.jpg" alt="Hermes Avatar">
</div>

<div class="content-right">

# 🎓 Hermes Agent Workshop

## ติดตั้งและใช้งาน AI Agent ด้วย Free Model

<div class="tagline">⏱️ สร้างใน 10 นาที — ไม่ต้องเสียเงิน!</div>

<div class="success" style="margin-top: 15px; padding: 12px 15px;">

**สิ่งที่ได้วันนี้:**

1. ✅ ติดตั้ง Hermes Agent (Windows / Linux / macOS)
2. ✅ สมัคร OKMD AI Playground (ฟรีสูงสุด 1M tokens/day)
3. ✅ ตั้งค่า Hermes ให้ใช้ Free Model
4. ✅ สร้าง Telegram Bot — คุยกับ AI ผ่าน Telegram
5. ✅ ทดลองใช้งานจริง

<div class="note">ไม่ต้องมี admin/sudo — ติดตั้งใน user folder ทั้งหมด</div>

</div>

</div>

---

# 🤖 Hermes Agent คืออะไร?

## AI Agent ที่ "จำได้ + ใช้เครื่องมือได้"

<div class="info">

**Hermes Agent** = open-source AI agent โดย Nous Research

- 🧠 **จำได้** — persistent memory ข้าม sessions
- 🔧 **ใช้เครื่องมือได้** — อ่านไฟล์, รันคำสั่ง, เข้าเว็บ
- 📱 **ใช้ได้หลายช่องทาง** — Terminal, Telegram, Discord, Slack
- 🔌 **รองรับทุก model** — OKMD, OpenRouter, Gemini, Groq, OpenAI
- 📚 **เรียนรู้จากประสบการณ์** — skills ที่เก็บไว้ใช้ได้ตลอด

</div>

**ต่างจาก ChatGPT อย่างไร?**

| ChatGPT | Hermes Agent |
|---------|--------------|
| จำได้แค่ใน chat | จำข้าม sessions |
| ไม่ได้อ่านไฟล์เครื่อง | อ่าน/เขียนไฟล์ได้ |
| ใช้ผ่าน web เท่านั้น | ใช้ผ่าน Telegram, Terminal |
| ต้องเสียเงิน API | ใช้ Free Model ได้ |

---

# 💰 Free Model ที่เราจะใช้: OKMD AI Playground

## ฟรี 23 Models — สูงสุด 1M tokens/day — จากภาครัฐไทย!

<div class="success">

**OKMD AI Playground** = บริการ AI ฟรี จาก OKMD (สำนักงานบริหารและพัฒนาองค์ความรู้)

- ✅ **ฟรี** สำหรับสมาชิก TK Park (สมัครฟรี)
- ✅ **23 Models** — GPT-5.4, Claude Sonnet 5, DeepSeek V4, Gemini, Llama 4, Grok
- ✅ **Quota สูงสุด 1M tokens/day** (DeepSeek) — ใช้ได้ไม่หมดในชีวิตประจำวัน
- ✅ **Quota share กันทั้ง Provider** — ใช้ model ใดใน provider ก็หักจาก quota รวม
- ✅ **OpenAI-compatible** — ใช้กับ tools ที่มีอยู่แล้วได้เลย

</div>

### Models ยอดนิยม (OpenAI, Anthropic, DeepSeek)

| Model | Provider | Quota/วัน | เหมาะสำหรับ |
|-------|----------|-----------|-------------|
| `gpt-4o` | OpenAI | 350K | ฉลาดสุดของ OpenAI |
| `gpt-4o-mini` | OpenAI | 350K | สมดุลดี (แนะนำ) |
| `gpt-4-turbo` | OpenAI | 350K | เร็ว, ประหยัด |
| `claude-3-5-sonnet` | Anthropic | 180K | ฉลาด, งานซับซ้อน |
| `claude-3-haiku` | Anthropic | 180K | เร็ว, เบา |
| `deepseek-chat` | DeepSeek | **1M** | Reasoning, วิเคราะห์ |
| `deepseek-coder` | DeepSeek | **1M** | เขียนโค้ด, quota เยอะสุด |

---

# 💰 Free Models (ต่อ)

## Models อื่นๆ ที่น่าสนใจ

### Meta, xAI, Qwen, Google, Mistral, AWS

| Model | Provider | Quota/วัน | เหมาะสำหรับ |
|-------|----------|-----------|-------------|
| `llama-3.1-70b` | Meta AI | 200K | Opensource, ฉลาด |
| `llama-3.1-8b` | Meta AI | 200K | Opensource, เร็ว |
| `grok-beta` | xAI | 100K | ข้อมูลล่าสุด |
| `qwen-72b-chat` | Qwen | 100K | ภาษาดี |
| `qwen-14b-chat` | Qwen | 100K | เร็ว, เบา |
| `gemini-2.0-flash` | Google | 200K | เร็ว, เบา |
| `gemini-1.5-pro` | Google | 200K | ฉลาด, งานซับซ้อน |
| `mistral-large` | Mistral | 100K | ยุโรป, หลายภาษา |
| `amazon.nova-pro` | AWS | 200K | AWS |
| `amazon.nova-lite` | AWS | 200K | เร็ว, เบา |

<div class="warning">

**⚠️ Quota share กันทั้ง Provider!**
- ใช้ `gpt-4o` 100K → `gpt-4o-mini` เหลือ 250K (ไม่ใช่ได้คนละ 350K!)
- ใช้ chat ที่ web playground.okmd.or.th ก็หัก quota ด้วย
- เช็ค quota: ดูที่ Usage ใน OKMD Playground หรือ `hermes insights`

</div>

---

# 📋 สิ่งที่ต้องเตรียม

## ก่อนเริ่มติดตั้ง

| # | สิ่งที่ต้องมี | สถานะ |
|---|---------------|-------|
| 1 | คอมพิวเตอร์ (Windows 10+ / macOS / Linux) | ✅ |
| 2 | Internet | ✅ |
| 3 | Google Account (สำหรับสมัคร OKMD) | ✅ |
| 4 | Telegram App (สำหรับคุยกับ AI) | ✅ |
| 5 | PowerShell 5.1+ (Windows) — มีอยู่แล้ว | ✅ |

---

## ⚠️ สำหรับ Windows: ปิด Antivirus ชั่วคราว

<div class="warning">

**ก่อนติดตั้ง ต้องปิด Antivirus ชั่วคราว!**

1. เปิด **Windows Security**
2. ไปที่ **Virus & threat protection** → **Manage settings**
3. ปิด **Real-time protection**
4. หลังติดตั้งเสร็จ → **เปิดกลับทันที**

</div>

---

# 🚀 Module 2: ติดตั้ง Hermes Agent

## Step 1: รันสคริปต์ติดตั้ง

### Windows (PowerShell)

```powershell
# เปิด PowerShell แล้ววางคำสั่งนี้
$f="$env:TEMP\hermes-install.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

<div class="info">

**สคริปต์จะติดตั้งอัตโนมัติ:**
- Git, Node.js, Python (user-space, ไม่ต้อง admin)
- Hermes Agent
- ตั้งค่า PATH

</div>

---

# ✅ ตรวจสอบการติดตั้ง

## Step 2: ทดสอบว่า Hermes ติดตั้งสำเร็จ

```bash
hermes --version
```

<div class="success">

ถ้าเห็นเลขเวอร์ชัน (เช่น `0.18.x`) = ติดตั้งสำเร็จ! ✅

</div>

---

## 🩺 แก้ปัญหา

**ถ้า `hermes` ไม่เจอคำสั่ง:**
- **Windows:** เปิด PowerShell ใหม่
- **Linux/macOS:** รัน `source ~/.bashrc`

**วินิจฉัยปัญหา:** `hermes doctor`

---

# 🔑 Module 3: สมัคร OKMD API Key

## Step 3: รับ Free API Key (2 นาที)

<div class="success">

**สมัคร OKMD AI Playground — ฟรี!**

1. เข้า 👉 https://playground.okmd.or.th
2. Login ด้วย Google Account (หรือสมัครสมาชิก TK Park ฟรี)
3. ไปที่ **Settings → API Platform**
4. กด **"Generate API Key"**
5. **Copy key** ที่ได้ (ขึ้นต้นด้วย `sk_...`)

</div>

<div class="highlight">

**⚠️ เก็บ API Key ไว้ให้ดี!**
- ห้ามแชร์ให้ใคร
- ห้าม upload ขึ้น GitHub
- ถ้าทำหาย → ไป generate ใหม่ได้ที่เดิม

</div>

---

# 🔧 Module 4: ตั้งค่า Hermes + OKMD

## Step 4: เชื่อม Hermes กับ OKMD API

### วิธีที่ 1: ใส่ในไฟล์ .env (แนะนำ)

```bash
# แก้ไขไฟล์ .env
nano ~/.hermes/.env

# เพิ่มบรรทัดนี้
OKMD_API_KEY=sk_YOUR_KEY_HERE
```

### วิธีที่ 2: ใช้คำสั่ง hermes env set

```bash
hermes env set OKMD_API_KEY sk_YOUR_KEY_HERE
```

### วิธีที่ 3: เพิ่มบรรทัดด้วย echo

```bash
echo "OKMD_API_KEY=sk_YOUR_KEY_HERE" >> ~/.hermes/.env
```

### ตรวจสอบว่าใส่ถูกต้อง

```bash
cat ~/.hermes/.env | grep OKMD_API_KEY
# ควรเห็น: OKMD_API_KEY=sk_...
```

### วิธีที่ 2: แก้ config เอง

```bash
hermes config edit
```

---

# 🔧 ตั้งค่า config.yaml

**1. แก้ไข config:**
```bash
hermes config edit
```
```yaml
model:
  provider: custom:okmd
  default: gpt-4o-mini
providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
```

**2. เพิ่ม API Key ใน .env:**
```bash
hermes env edit
```
```bash
OKMD_API_KEY=sk_YOUR_KEY_HERE
```

---

# ⚠️ ปัญหา SSL Certificate

**OKMD ใช้ self-signed certificate** — Node.js จะปฏิเสธการเชื่อมต่อ

**วิธีแก้:** เพิ่มใน `~/.hermes/.env`:
```bash
NODE_TLS_REJECT_UNAUTHORIZED=0
```

**แก้ถาวร (macOS/Linux):**
```bash
echo 'export NODE_TLS_REJECT_UNAUTHORIZED=0' >> ~/.bashrc
```

**Windows (PowerShell):**
```powershell
[System.Environment]::SetEnvironmentVariable('NODE_TLS_REJECT_UNAUTHORIZED', '0', 'User')
```

<div class="warning">

⚠️ ลดความปลอดภัยของ HTTPS ทั้งหมด — ใช้เฉพาะกับ OKMD

</div>

---

# 🔄 สลับ Models ได้ทันที

## ใช้ model ต่างๆ ตามต้องการ

```bash
# ดู models ที่มีใน OKMD
curl -sk https://gen.ai.kku.ac.th/okmd/api/v1/models \
  -H "Authorization: Bearer $OKMD_API_KEY" | python3 -m json.tool
```

### เปลี่ยน model ใน Hermes

ใน Hermes chat:
```
/model gpt-4o-mini
/model deepseek-chat
/model claude-3-5-sonnet
/model llama-3.1-70b
```

---

# 🔄 เปลี่ยน Model Provider

<div class="warning">

**⚠️ สำคัญ:** `hermes setup` **ไม่ถาม API key สำหรับ custom provider**
ต้องใช้ `hermes model` หรือแก้ `config.yaml` โดยตรง

</div>

## วิธีที่ 1: ใช้ hermes model (แนะนำ)

```bash
hermes model
```

**เลือกจากเมนู:**
- OpenRouter (เข้าถึงหลาย models ด้วย key เดียว)
- OpenAI (GPT-4, GPT-3.5)
- Anthropic (Claude 3.5, Claude 3)
- Google (Gemini)
- Groq (เร็วมาก)
- **Custom endpoint** (สำหรับ OKMD, Ollama, vLLM, ฯลฯ)

**สำหรับ Custom endpoint:**
1. เลือก "Custom endpoint (self-hosted / VLLM / etc.)"
2. ใส่ **Base URL** (เช่น `https://gen.ai.kku.ac.th/okmd/api/v1`)
3. ใส่ **API Key** (เช่น `sk_...`)
4. ใส่ **Model name** (เช่น `gpt-4o-mini`)

---

## วิธีที่ 2: แก้ config.yaml โดยตรง

```bash
hermes config edit
```

**เพิ่มใน config.yaml:**
```yaml
custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY

model:
  default: gpt-4o-mini
  provider: custom:okmd
```

**ตั้ง API Key:**
```bash
hermes env edit
# เพิ่ม: OKMD_API_KEY=sk_your_actual_key_here
```

---

## วิธีที่ 3: ใช้คำสั่ง

```bash
# เปลี่ยนเป็น OpenRouter
hermes config set model.provider openrouter
hermes config set model.default anthropic/claude-3.5-sonnet

# ตั้ง API key
hermes env set OPENROUTER_API_KEY sk-or-v1-...

# ตรวจสอบ
hermes model test openrouter
```

---

## Built-in Providers

### OpenRouter (แนะนำ)

**ข้อดี:** เข้าถึง model หลายตัวด้วย API key เดียว

```bash
hermes model
# เลือก: openrouter
# เลือก model: anthropic/claude-3.5-sonnet
# ใส่ API key: sk-or-v1-...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `anthropic/claude-3.5-sonnet` | $3/$15 per 1M | งานทั่วไป |
| `openai/gpt-4o` | $5/$15 per 1M | สมดุลดี |
| `google/gemini-2.0-flash-exp` | ฟรี | ทดสอบ |
| `meta-llama/llama-3.3-70b` | ฟรี | Opensource |

**สมัคร:** https://openrouter.ai/keys

---

### OpenAI (GPT Models)

```bash
hermes model
# เลือก: openai
# เลือก model: gpt-4o, gpt-4-turbo, gpt-3.5-turbo
# ใส่ API key: sk-...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `gpt-4o` | $5/$15 per 1M | สมดุลดี |
| `gpt-4-turbo` | $10/$30 per 1M | งานซับซ้อน |
| `gpt-3.5-turbo` | $0.5/$1.5 per 1M | ถูก, เร็ว |

**สมัคร:** https://platform.openai.com/api-keys

---

### Anthropic (Claude Models)

```bash
hermes model
# เลือก: anthropic
# เลือก model: claude-3.5-sonnet, claude-3-opus, claude-3-haiku
# ใส่ API key: sk-ant-...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `claude-3.5-sonnet` | $3/$15 per 1M | สมดุลดี |
| `claude-3-opus` | $15/$75 per 1M | ฉลาดสุด |
| `claude-3-haiku` | $0.25/$1.25 per 1M | เร็ว, ถูก |

**สมัคร:** https://console.anthropic.com/

---

### Google Gemini

```bash
hermes model
# เลือก: google
# เลือก model: gemini-2.0-flash-exp, gemini-1.5-pro
# ใส่ API key: AIza...
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

```bash
hermes model
# เลือก: groq
# เลือก model: llama-3.3-70b-versatile
# ใส่ API key: gsk_...
```

**Models ที่แนะนำ:**
| Model | ราคา | เหมาะกับ |
|-------|------|----------|
| `llama-3.3-70b-versatile` | ฟรี (rate limit) | ทดสอบ |
| `llama-3.1-8b-instant` | ฟรี (rate limit) | เร็วมาก |

**สมัคร:** https://console.groq.com/keys

---

## เปลี่ยน API Key

### ดู API Key ปัจจุบัน

```bash
# ดูชื่อ environment variable
hermes config get providers.okmd.key_env

# ดูค่าปัจจุบัน (masked)
hermes env show
```

### เปลี่ยน API Key

```bash
# วิธีที่ 1: ใช้ hermes env set
hermes env set OKMD_API_KEY sk_new_key_here

# วิธีที่ 2: แก้ไฟล์ .env โดยตรง
hermes env edit
```

### ลบ API Key

```bash
hermes env unset OKMD_API_KEY
```

---

## ตรวจสอบการตั้งค่า

### ดู Configuration ทั้งหมด

```bash
hermes config get
```

### ดู Environment Variables

```bash
hermes env show
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

## Custom Provider อื่นๆ

**Ollama (Local Model):**
```yaml
custom_providers:
  - name: ollama
    base_url: http://localhost:11434/api
model:
  provider: custom:ollama
  default: llama3.2
```
ติดตั้ง: `curl -fsSL https://ollama.com/install.sh | sh && ollama pull llama3.2`

**Together AI:**
```yaml
custom_providers:
  - name: together
    base_url: https://api.together.xyz/v1
    key_env: TOGETHER_API_KEY
model:
  provider: custom:together
  default: mistralai/Mixtral-8x7B-Instruct-v0.1
```

---

## LiteLLM Proxy (แนะนำสำหรับหลาย Providers)

### LiteLLM คืออะไร?

**LiteLLM** = OpenAI-compatible proxy ที่รวมหลาย providers:

- รองรับ 100+ models (OpenAI, Anthropic, Gemini, Bedrock, Azure)
- Load balancing, fallback, retry อัตโนมัติ
- Rate limit management
- มี 2 รูปแบบ: **Hosted** (Cloud) และ **Self-host**

### LiteLLM มี 2 รูปแบบ

| รูปแบบ | คำอธิบาย | เหมาะกับ |
|--------|----------|----------|
| **Hosted** (Cloud) | ใช้ proxy ที่คนอื่น host ให้ | ผู้เรียน Course 0 |
| **Self-host** | ติดตั้งเอง (Docker/Python) | Advanced users |

---

### 🌐 LiteLLM Hosted (แนะนำสำหรับ Course 0)

Course 0 ใช้ LiteLLM Proxy ที่ host บน Cloudflare Workers ผู้เรียน **ไม่ต้องติดตั้ง LiteLLM เอง** แค่ใส่ API Key ที่ instructor ให้มาก็ใช้ได้ทันที

**Configuration (Course 0):**

```yaml
# ~/.hermes/config.yaml
model:
  provider: custom:litellm
  default: qwen-72b-chat

providers:
  litellm:
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY
    transport: openai_chat
```

**API Key ใน `.env`:**

```bash
# ~/.hermes/.env
LITELLM_API_KEY=sk-hd_VaSiHUSu_RqHKwHs7aw
```

> ⚠️ **หมายเหตุ:** API Key ด้านบนเป็นตัวอย่างสำหรับ Course 0 ผู้เรียนจะได้รับ key จาก instructor

---

### 🔧 LiteLLM Self-host (สำหรับ Advanced Users)

#### ติดตั้ง LiteLLM ด้วย Docker

```bash
docker run -d \
  --name litellm \
  -p 4000:4000 \
  -e OPENAI_API_KEY=sk-... \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -e GEMINI_API_KEY=AIza... \
  ghcr.io/berriai/litellm:main-latest
```

---

#### ติดตั้ง LiteLLM ด้วย Python

```bash
pip install litellm[proxy]

# สร้าง config file
cat > litellm_config.yaml << EOF
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: claude-3.5-sonnet
    litellm_params:
      model: anthropic/claude-3.5-sonnet
      api_key: os.environ/ANTHROPIC_API_KEY
EOF

# เริ่ม proxy
litellm --config litellm_config.yaml --port 4000
```

---

### ตั้งค่า LiteLLM Self-host ใน Hermes

**วิธีที่ 1: ใช้ `hermes model`**

```bash
hermes model
```

เลือก:
- Provider: **Custom endpoint**
- Base URL: `http://localhost:4000`
- API Key: `sk-...` (หรือปล่อยว่าง)
- Model: `gpt-4o`

**วิธีที่ 2: แก้ `config.yaml`**

```yaml
# ~/.hermes/config.yaml
custom_providers:
  - name: litellm
    base_url: http://localhost:4000
    key_env: LITELLM_API_KEY

model:
  default: gpt-4o
  provider: custom:litellm
```

---

### ตัวอย่าง LiteLLM Config (Self-host)

**หลาย Providers:**
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

**Load Balancing:**
```yaml
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
```

**Fallback:**
```yaml
router_settings:
  fallbacks:
    - default: ["default-fallback"]
  num_retries: 3
```

---

### เปลี่ยน Model ใน Hermes

```bash
/model custom:litellm/gpt-4o
/model custom:litellm/claude-3.5-sonnet
/model custom:litellm/gemini-2.0-flash
```

### Fallback Configuration ใน Hermes

นอกจาก LiteLLM จะรองรับ fallback ได้แล้ว Hermes ก็รองรับการตั้งค่า fallback ระดับ provider ได้เช่นกัน:

```yaml
# ~/.hermes/config.yaml
model:
  default: qwen-72b-chat
  fallbacks:
    - anthropic/claude-sonnet-4
    - openai/gpt-4o
```

เมื่อ model หลัก (qwen-72b-chat) ไม่ตอบสนอง Hermes จะลองใช้ model ถัดไปโดยอัตโนมัติ

---

### ข้อดีของ LiteLLM

| ข้อดี | คำอธิบาย |
|-------|----------|
| **รวมทุก providers** | ใช้ API endpoint เดียว |
| **Load balancing** | แจกจ่าย request หลาย API keys |
| **Fallback อัตโนมัติ** | ถ้า provider หนึ่งล่ม ไปใช้ provider อื่น |
| **Rate limit management** | จัดการ rate limit อัตโนมัติ |
| **Cost tracking** | ติดตามค่าใช้จ่าย |

### เปรียบเทียบ LiteLLM Hosted vs Self-host

| หัวข้อ | Hosted (Course 0) | Self-host |
|--------|-------------------|-----------|
| **การติดตั้ง** | ไม่ต้องติดตั้ง | ต้องติดตั้ง Docker/Python |
| **การดูแล** | Instructor ดูแลให้ | ดูแลเอง |
| **ความยืดหยุ่น** | จำกัดตาม provider ที่ instructor ให้ | ควบคุมได้เองทั้งหมด |
| **ค่าใช้จ่าย** | ฟรี (รวมใน Course) | จ่ายค่า API keys เอง |
| **เหมาะกับ** | ผู้เรียน, beginners | Advanced users, องค์กร |

---

### Troubleshooting LiteLLM

**ปัญหา: "Connection refused"**

```bash
# สำหรับ Self-host: ตรวจสอบว่า LiteLLM ทำงานอยู่
curl http://localhost:4000/health

# สำหรับ Hosted: ตรวจสอบ internet connection
curl https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/health
```

**ปัญหา: "Model not found"**

```bash
# ดู models ที่มี
curl http://localhost:4000/models

# หรือสำหรับ Hosted
curl https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/models \
  -H "Authorization: Bearer $LITELLM_API_KEY"
```

**ปัญหา: "Invalid API key"**

```bash
# ตรวจสอบ API key ใน .env
cat ~/.hermes/.env | grep LITELLM

# ตั้ง API key ใหม่
hermes env set LITELLM_API_KEY sk-correct-key
```

**ปัญหา: "401 Unauthorized" (Course 0)**

- ตรวจสอบว่าใช้ API Key ที่ instructor ให้มาถูกต้อง
- API Key อาจหมดอายุ → ติดต่อ instructor
- ตรวจสอบว่าไม่มีช่องว่างหรือ newline ใน key

---

## Troubleshooting

### ปัญหา: `hermes setup` ไม่ถาม API key สำหรับ custom provider

**สาเหตุ:** `hermes setup` เป็น wizard สำหรับ built-in providers เท่านั้น

**วิธีแก้:**
- ใช้ `hermes model` แทน (ถาม API key สำหรับ custom provider)
- หรือแก้ `config.yaml` โดยตรง (วิธีที่ 2)

### ปัญหา: "Provider not found"

**สาเหตุ:** ใส่ชื่อ provider ผิด

**วิธีแก้:**
```bash
# ดู providers ที่มี
hermes config get custom_providers

# ใช้ชื่อที่ถูกต้อง
hermes config set model.provider custom:okmd
```

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

# 🤖 Module 5: สร้าง Telegram Bot

## Step 5: สร้าง Bot ใน Telegram

1. เปิด Telegram → ค้นหา `@BotFather`
2. ส่งคำสั่ง: `/newbot`
3. ตั้งชื่อ bot: **"My AI Assistant"**
4. ตั้ง username: `my_ai_hermes_bot` (ต้องลงท้ายด้วย `bot`)
5. BotFather จะส่ง **Bot Token** กลับมา

<div class="highlight">

**Bot Token ตัวอย่าง:**
```
1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ
```
📋 **Copy เก็บไว้!** จะใช้ตอนตั้งค่า Gateway

</div>

---

# 🔗 เชื่อม Telegram กับ Hermes

## Step 6: ตั้งค่า Telegram Gateway

```bash
# ตั้ง bot token
hermes gateway setup
# เลือก Telegram → วาง Bot Token
```

### หรือแก้ .env โดยตรง

```bash
# ~/.hermes/.env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHI...
TELEGRAM_ALLOWED_USERS=your_telegram_user_id
```

<div class="info">

**หา Telegram User ID:**
1. เปิด Telegram → ค้นหา `@userinfobot`
2. ส่ง `/start`
3. Copy เลข ID ที่ได้ (เช่น `123456789`)

</div>

### เริ่ม Gateway

```bash
hermes gateway start
```

---

# 🚀 Auto-start Services หลังติดตั้ง

## ใช้งานได้ทันทีหลัง Reboot

สคริปต์ติดตั้งจะตั้งค่า **auto-start** ให้ทั้ง 3 บริการ:

| บริการ | วิธีเริ่ม | Auto-start หลัง Reboot |
|--------|----------|------------------------|
| **Telegram Gateway** | `hermes gateway start` | ✅ เปิดอัตโนมัติ |
| **Dashboard** | `hermes dashboard` | ✅ เปิดอัตโนมัติ (http://localhost:3030) |
| **Desktop App** | `hermes desktop` | ✅ เปิดอัตโนมัติ |

### วิธีการ Auto-start ตาม OS

**Windows:**
- ใช้ **Startup Folder** (`shell:startup`)
- สร้าง shortcut ทั้ง 3 services
- จะเริ่มทำงานทันทีหลัง login

**Linux (systemd):**
```bash
# ตรวจสอบสถานะ
systemctl --user status hermes-gateway
systemctl --user status hermes-dashboard
systemctl --user status hermes-desktop

# เริ่ม/หยุด services
systemctl --user start hermes-gateway
systemctl --user start hermes-dashboard
systemctl --user start hermes-desktop
```

**macOS (launchd):**
```bash
# ตรวจสอบสถานะ
launchctl list | grep hermes

# Load services (ถ้ายังไม่ load)
launchctl load ~/Library/LaunchAgents/com.hermes.gateway.plist
launchctl load ~/Library/LaunchAgents/com.hermes.dashboard.plist
launchctl load ~/Library/LaunchAgents/com.hermes.desktop.plist
```

---

# 🗑️ Uninstallation

## วิธีลบ Hermes Agent

**Windows:**
```powershell
# Basic:
irm https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-windows.ps1 | iex
# Full (include agy, Node.js):
irm https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-windows.ps1 | iex - -RemoveAgy -RemoveNode -Force
```

**Linux / macOS:**
```bash
# Basic:
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-linux.sh | bash
# Full (include agy, Node.js):
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-linux.sh | bash -s -- --remove-agy --remove-node --force
```

### สิ่งที่ลบออก
- ✅ Hermes Agent, configuration, startup services, `~/.hermes`, PATH
- ⚠️ **agy** → ใช้ `--remove-agy`
- ⚠️ **Node.js** → ใช้ `--remove-node`

---

# ✅ Module 6: ทดสอบใช้งาน

## ทดสอบใน Terminal

```bash
hermes

# พิมพ์อะไรก็ได้
You: สวัสดี ช่วยอะไรได้บ้าง?
Hermes: สวัสดีครับ! ผมเป็น AI Agent ช่วยทำงานได้หลายอย่าง...
```

## ทดสอบใน Telegram

1. เปิด Telegram → หา bot ที่สร้าง
2. ส่ง: `/start`
3. ส่ง: `สวัสดี`
4. ถ้า Hermes ตอบกลับ = **สำเร็จ!** 🎉

### คำสั่งทดสอบ

```
# ใน Terminal หรือ Telegram
/help              # ดูคำสั่งทั้งหมด
/model             # ดู/เปลี่ยน model
/new               # เริ่ม chat ใหม่
/status            # ดูสถานะ

# ทดสอบ tools
What time is it?   # ทดสอบ terminal tool
Search for: AI news 2026  # ทดสอบ web search
```

---

## 📊 ตรวจสอบ Quota Usage

OKMD API จะบอก quota ในทุก response:

```json
"model_quota": {
  "daily_quota_tokens": 350000,
  "daily_usage_tokens": 1500,
  "daily_remaining_tokens": 348500
}
```

### เช็ค quota ผ่าน Hermes

```bash
hermes insights
```

---

## Quota รวมตาม Provider (Jul 2026)

| Provider | Quota/วัน | Models สำคัญ |
|----------|-----------|--------------|
| **Deepseek** | **1M** | `deepseek-chat`, `deepseek-coder` |
| **OpenAI** | 350K | `gpt-4o`, `gpt-4o-mini`, `gpt-4-turbo` |
| **Gemini/Meta/Claude** | 200K/180K | `gemini-2.0-flash`, `llama-3.1-70b`, `claude-3-5-sonnet` |
| **xAI/Qwen** | 100K | `grok-beta`, `qwen-72b-chat` |

<div class="success">

**1M tokens ≈** 💬 1,000+ chats | 📄 250 pages | 🔧 500 commands

</div>

---

# 🛠️ Troubleshooting

## ปัญหาที่พบบ่อย

### ❌ "hermes: command not found"
```bash
# ปิด terminal แล้วเปิดใหม่
# หรือ
source ~/.bashrc
```

### ❌ "401 Invalid API key"
```bash
# ตรวจสอบ .env
cat ~/.hermes/.env | grep OKMD
# ต้องมี: OKMD_API_KEY=sk_...
```

### ❌ "SSL certificate error" (Node.js)
```bash
# เพิ่มใน ~/.hermes/.env
echo "NODE_TLS_REJECT_UNAUTHORIZED=0" >> ~/.hermes/.env
# แล้ว restart
hermes gateway restart
```

### ❌ Telegram bot ไม่ตอบ
```bash
# เช็ค gateway status
hermes gateway status
# ถ้าไม่ทำงาน
hermes gateway restart
# เช็ค log
tail ~/.hermes/logs/gateway.log
```

---

# 🔑 ค่าที่ต้องใส่หลังติดตั้ง

## สิ่งที่ต้องตั้งค่า

หลังติดตั้งเสร็จ ต้องใส่ค่าเหล่านี้เพื่อให้ Hermes ใช้งานได้:

<div class="info">

### 🔴 จำเป็น (ต้องใส่)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **OKMD API Key** | [playground.okmd.or.th](https://playground.okmd.or.th) | ใช้เรียก 23 free models |

**วิธีสมัคร OKMD:**
1. Login ด้วย Google Account
2. ไปที่ Settings → API Platform
3. Generate API Key (ขึ้นต้นด้วย `sk_...`)
4. Copy key มาวางตอน install หรือใส่ทีหลัง

</div>

### 🟡 Optional (ใส่ก็ได้ ไม่ใส่ก็ได้)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **LiteLLM API Key** | Instructor ให้มา (Course 0) | ใช้ LiteLLM Proxy แทน OKMD |
| **Telegram Bot Token** | สร้างจาก [@BotFather](https://t.me/BotFather) | คุยกับ Hermes ผ่าน Telegram |
| **Telegram Chat ID** | หาจาก [@userinfobot](https://t.me/userinfobot) | จำกัดให้เฉพาะคุณใช้ Bot ได้ |

---

## ขั้นตอนหลังติดตั้ง

### ใส่ค่าทีหลัง (ถ้าไม่ได้ใส่ตอน install)

<div class="warning">

**⚠️ สำคัญ:** `hermes setup` **ไม่ถาม API key สำหรับ custom provider** (OKMD เป็น custom provider)

ต้องใส่ API key ด้วยวิธีต่อไปนี้เท่านั้น:

</div>

```bash
# 1. ใส่ OKMD API Key (เลือกวิธีใดวิธีหนึ่ง)
# วิธีที่ 1: แก้ไฟล์ .env โดยตรง
nano ~/.hermes/.env
# เพิ่ม: OKMD_API_KEY=sk_YOUR_KEY_HERE

# วิธีที่ 2: ใช้คำสั่ง
hermes env set OKMD_API_KEY sk_YOUR_KEY_HERE

# วิธีที่ 3: เพิ่มบรรทัดด้วย echo
echo "OKMD_API_KEY=sk_YOUR_KEY_HERE" >> ~/.hermes/.env

# 2. ตรวจสอบว่า API key ถูกใส่แล้ว
cat ~/.hermes/.env | grep OKMD_API_KEY

# 3. เปลี่ยน model/provider (ถ้าต้องการ)
hermes model

# 4. ตรวจสอบว่าทำงานได้
hermes doctor

# 5. เริ่มใช้งาน
hermes                    # CLI chat
hermes desktop            # Desktop app
hermes dashboard          # Web dashboard (http://localhost:9119)
hermes gateway start      # Telegram bot
```

### สรุปสถานะการตั้งค่า

| สถานะ | ค่าที่ต้องใส่ |
|-------|---------------|
| **Minimal** | OKMD API Key เท่านั้น |
| **Full setup** | OKMD + Telegram Bot + Chat ID |
| **Course 0** | LiteLLM API Key (จาก instructor) |

<div class="success">

**💡 เคล็ดลับ:** ถ้าไม่ได้ใส่ค่าตอนติดตั้ง ไม่ต้องกังวล! ใส่ทีหลังได้เสมอด้วยคำสั่ง `hermes setup`

</div>

---

# 🎯 สรุป

## สิ่งที่ได้ทำวันนี้

| Step | สิ่งที่ทำได้ | เวลา |
|------|-------------|------|
| 1 | ติดตั้ง Hermes Agent | 3 นาที |
| 2 | สมัคร OKMD API Key | 2 นาที |
| 3 | ตั้งค่า Hermes + OKMD | 3 นาที |
| 4 | สร้าง Telegram Bot | 2 นาที |
| 5 | ทดสอบใช้งาน | 1 นาที |

<div class="success">

**🎉 เยี่ยมมาก! คุณมี AI Agent ส่วนตัวแล้ว!**

- 💬 คุยผ่าน Telegram ได้ทุกที่
- 🧠 ใช้ Free Model จาก OKMD
- 🔧 สั่งงานได้: อ่านไฟล์, รันคำสั่ง, เข้าเว็บ
- 📚 เรียนรู้และพัฒนาตัวเองได้

</div>

### แหล่งข้อมูลเพิ่มเติม

- Hermes Docs: https://hermes-agent.nousresearch.com/docs/
- OKMD Playground: https://playground.okmd.or.th
- GitHub Repo: https://github.com/pbseiya/hermes-free-model-guide

---

# 📁 โครงสร้างไฟล์ในเครื่อง

## ไฟล์ที่สำคัญ

| ไฟล์ | ตำแหน่ง (Windows) | ตำแหน่ง (Mac/Linux) |
|------|-------------------|---------------------|
| Config | `%USERPROFILE%\.hermes\config.yaml` | `~/.hermes/config.yaml` |
| API Keys | `%USERPROFILE%\.hermes\.env` | `~/.hermes/.env` |
| Logs | `%LOCALAPPDATA%\hermes\logs\` | `~/.hermes/logs/` |
| Sessions | `%USERPROFILE%\.hermes\sessions\` | `~/.hermes/sessions/` |
| Skills | `%USERPROFILE%\.hermes\skills\` | `~/.hermes/skills/` |

<div class="warning">

**⚠️ ไฟล์ที่ต้องระวัง:**
- `.env` — มี API keys **ห้ามแชร์!**
- `config.yaml` — ตั้งค่าส่วนตัว
- `gateway.log` — ใช้ debug

</div>
