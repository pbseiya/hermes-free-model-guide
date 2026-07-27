---
marp: true
theme: default
paginate: true
header: "Course 0: ติดตั้ง Hermes Agent + Free Model"
footer: "ใช้ OKMD AI Playground — ฟรี 23 models สูงสุด 1M tokens/day"
style: |
  section {
    font-family: 'Sarabun', 'TH Sarabun New', sans-serif;
    background: white;
  }
  h1 { color: #1e40af; font-size: 2.2em; }
  h2 { color: #2563eb; font-size: 1.6em; }
  code {
    background: #f3f4f6;
    padding: 2px 6px;
    border-radius: 4px;
    font-family: 'Fira Code', monospace;
  }
  pre code {
    display: block;
    padding: 16px;
    background: #1e293b;
    color: #e2e8f0;
    border-radius: 8px;
    font-size: 0.85em;
  }
  table { width: 100%; border-collapse: collapse; margin: 12px 0; }
  th { background: #2563eb; color: white; padding: 10px; text-align: left; }
  td { padding: 8px; border-bottom: 1px solid #e5e7eb; }
  tr:nth-child(even) { background: #f9fafb; }
  .highlight { background: #fef3c7; padding: 14px; border-left: 4px solid #f59e0b; margin: 14px 0; }
  .success { background: #d1fae5; padding: 14px; border-left: 4px solid #10b981; margin: 14px 0; }
  .warning { background: #fee2e2; padding: 14px; border-left: 4px solid #ef4444; margin: 14px 0; }
  .info { background: #dbeafe; padding: 14px; border-left: 4px solid #3b82f6; margin: 14px 0; }
---

# 🐍 Module 1: ติดตั้ง Hermes Agent + ใช้ Free Model

## เสร็จใน 10 นาที — ไม่ต้องเสียเงิน!

<div class="success">

**สิ่งที่ได้ทำวันนี้:**
1. ✅ ติดตั้ง Hermes Agent (Windows / Linux / macOS)
2. ✅ สมัคร OKMD AI Playground (ฟรีสูงสุด 1M tokens/day)
3. ✅ ตั้งค่า Hermes ให้ใช้ Free Model
4. ✅ สร้าง Telegram Bot — คุยกับ AI ผ่าน Telegram
5. ✅ ทดสอบใช้งานจริง

**ไม่ต้องมี admin/sudo** — ติดตั้งใน user folder ทั้งหมด

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

### Models ที่มีให้ใช้ฟรี (23 Models!)

| Model | Provider | Quota/วัน | เหมาะสำหรับ |
|-------|----------|-----------|-------------|
| `gpt-5.4` | OpenAI | 350K | ฉลาดสุดของ OpenAI |
| `gpt-5.4-mini` | OpenAI | 350K | สมดุลดี |
| `gpt-5.4-nano` | OpenAI | 350K | เร็ว, เบา |
| `claude-sonnet-5` | Anthropic | 180K | ฉลาด, งานซับซ้อน |
| `claude-sonnet-4.6` | Anthropic | 180K | รุ่นก่อน, เสถียร |
| `deepseek-v4-pro` | DeepSeek | **1M** | Reasoning, วิเคราะห์ |
| `deepseek-v4-flash` | DeepSeek | **1M** | เร็ว, quota เยอะ |
| `llama-4-maverick` | Meta AI | 200K | Opensource, ฉลาด |
| `llama-4-scout` | Meta AI | 200K | Opensource, เร็ว |
| `grok-4.3` | xAI | 100K | ข้อมูลล่าสุด |
| `qwen3.7-plus` | Qwen | 100K | ภาษาดี |
| `qwen3.7-max` | Qwen | 100K | ฉลาด |
| `qwen3.6-flash` | Qwen | 100K | เร็ว |
| `gemini-2.5-flash-lite` | Google | 200K | เร็ว, เบา |
| `mistral-medium-3.1` | Mistral | 100K | ยุโรป, หลายภาษา |
| `nova-pro-v1` | AWS | 200K | AWS |
| `nova-2-lite-v1` | AWS | 200K | เร็ว, เบา |

<div class="warning">

**⚠️ Quota share กันทั้ง Provider!**
- ใช้ `gpt-5.4` 100K → `gpt-5.4-mini` เหลือ 250K (ไม่ใช่ได้คนละ 350K!)
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

<div class="highlight">

**⚠️ สำหรับ Windows: ปิด Antivirus ชั่วคราว**
- Windows Security → Virus & threat protection → Manage settings
- ปิด **Real-time protection**
- หลังติดตั้งเสร็จ → เปิดกลับ

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

ถ้าเห็น版本号 (เช่น `0.18.x`) = ติดตั้งสำเร็จ! ✅

</div>

### ถ้า `hermes` ไม่เจอคำสั่ง

**Windows:**
```powershell
# เปิด PowerShell ใหม่ หรือรัน
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
```

**macOS / Linux:**
```bash
source ~/.bashrc   # หรือ source ~/.zshrc
```

### วินิจฉัยปัญหา

```bash
hermes doctor
```

คำสั่งนี้จะเช็ค dependencies + config แล้วบอกว่าอะไรขาดหาย

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

### วิธีที่ 1: ใช้คำสั่ง (แนะนำ)

```bash
# เปิด interactive setup
hermes setup
```

เลือก:
1. **Provider** → Custom endpoint
2. **Base URL** → `https://gen.ai.kku.ac.th/okmd/api/v1`
3. **API Key** → วาง OKMD key ที่ copy มา
4. **Model** → `gpt-5.4-mini` (แนะนำ — 350K quota)
   หรือ `deepseek-v4-flash` (1M quota เยอะสุด)

### วิธีที่ 2: แก้ config เอง

```bash
hermes config edit
```

---

# 🔧 ตั้งค่า config.yaml (วิธีแก้เอง)

## เปิด config แล้วแก้ตามนี้

```bash
hermes config edit
```

```yaml
# ~/.hermes/config.yaml
model:
  provider: custom:okmd
  default: gpt-5.4-mini

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
```

### ตั้ง API Key ใน .env

```bash
hermes config env-path
# จะได้ path เช่น ~/.hermes/.env
```

```bash
# ~/.hermes/.env
OKMD_API_KEY=sk_YOUR_KEY_HERE
```

<div class="warning">

**⚠️ อย่าใส่ API key จริงใน config.yaml** — ใส่ใน `.env` เท่านั้น!

</div>

---

# ⚠️ ปัญหา SSL Certificate

## OKMD ใช้ self-signed certificate

OKMD API endpoint (`gen.ai.kku.ac.th`) ใช้ SSL certificate ที่ self-signed ซึ่ง Node.js จะปฏิเสธการเชื่อมต่อ

### วิธีแก้: ตั้ง environment variable

```bash
# เพิ่มใน ~/.hermes/.env
NODE_TLS_REJECT_UNAUTHORIZED=0
```

### หรือแก้ถาวร (macOS / Linux)

```bash
# เพิ่มใน shell config (~/.bashrc หรือ ~/.zshrc)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

### Windows (PowerShell)

```powershell
# เพิ่มใน Environment Variables
[System.Environment]::SetEnvironmentVariable('NODE_TLS_REJECT_UNAUTHORIZED', '0', 'User')
```

<div class="warning">

**⚠️ การตั้ง `NODE_TLS_REJECT_UNAUTHORIZED=0`** ลดความปลอดภัยของ HTTPS ทั้งหมด
ใช้เฉพาะกับ OKMD API เท่านั้น ถ้าต้องการความปลอดภัยสูงกว่านี้ ต้อง export certificate จาก OKMD เพิ่ม

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

```
# ใน Hermes chat
/model gpt-5.4-mini
/model deepseek-v4-flash
/model claude-sonnet-5
/model llama-4-maverick
```

### Models ฟรีที่น่าใช้ (เรียงตาม Quota)

| Model | Quota/วัน | Speed | Intelligence | ใช้เมื่อ |
|-------|-----------|-------|-------------|---------|
| `deepseek-v4-flash` | **1M** | ⚡⚡⚡ | 🧠🧠🧠 | ใช้เยอะ, quota เยอะสุด |
| `deepseek-v4-pro` | **1M** | ⚡⚡ | 🧠🧠🧠🧠 | Reasoning, วิเคราะห์ |
| `gpt-5.4` | 350K | ⚡⚡ | 🧠🧠🧠🧠 | ฉลาดสุดของ OpenAI |
| `gpt-5.4-mini` | 350K | ⚡⚡⚡ | 🧠🧠🧠 | **แนะนำ** สมดุลดี |
| `gpt-5.4-nano` | 350K | ⚡⚡⚡⚡ | 🧠🧠 | เร็ว, เบา |
| `llama-4-maverick` | 200K | ⚡⚡ | 🧠🧠🧠 | Opensource, ฉลาด |
| `claude-sonnet-5` | 180K | ⚡ | 🧠🧠🧠🧠 | งานซับซ้อน, เขียนโค้ด |
| `gemini-2.5-flash-lite` | 200K | ⚡⚡⚡⚡ | 🧠🧠 | เร็ว, เบา |
| `grok-4.3` | 100K | ⚡⚡ | 🧠🧠🧠 | ข้อมูลล่าสุด |
| `qwen3.7-plus` | 100K | ⚡⚡ | 🧠🧠🧠 | ภาษาดี |

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

## วิธีลบ Hermes Agent ออกทั้งหมด

### Windows (PowerShell)
```powershell
# Basic uninstall
$f="$env:TEMP\hermes-uninstall.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f

# Full uninstall (include agy and Node.js)
$f="$env:TEMP\hermes-uninstall.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f -RemoveAgy -RemoveNode -Force; Remove-Item $f
```

### Linux / macOS
```bash
# Basic uninstall
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-linux.sh | bash

# Full uninstall (include agy and Node.js)
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-linux.sh | bash -s -- --remove-agy --remove-node --force
```

### สิ่งที่ Uninstall Script ลบออก

| รายการ | ลบอัตโนมัติ? |
|--------|-------------|
| Hermes Agent และ configuration | ✅ |
| Startup services (Desktop, Dashboard, Telegram) | ✅ |
| `~/.hermes` directory | ✅ |
| PATH entries | ✅ |
| **agy** (Antigravity CLI) | ⚠️ ใช้ `--remove-agy` |
| **Node.js** | ⚠️ ใช้ `--remove-node` |

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

## ดูว่าใช้ไปเท่าไหร่แล้ว

OKMD API จะบอก quota ในทุก response:

```json
"model_quota": {
  "daily_quota_tokens": 350000,
  "daily_usage_tokens": 1500,
  "daily_remaining_tokens": 348500
}
```

### Quota รวมตาม Provider (ข้อมูลจริง Jul 2026)

| Provider | Quota รวม/วัน | Models ใน Provider |
|----------|--------------|---------------------|
| **Deepseek** | **1,000,000** | `deepseek-v4-pro`, `deepseek-v4-flash` |
| **OpenAI** | 350,000 | `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.4-nano` |
| **Gemini** | 200,000 | `gemini-3.5-flash`, `gemini-3.1-flash-lite`, `gemini-2.5-flash-lite` + อื่นๆ |
| **Meta AI** | 200,000 | `llama-4-maverick`, `llama-4-scout` |
| **Nova (AWS)** | 200,000 | `nova-pro-v1`, `nova-2-lite-v1` |
| **Claude** | 180,000 | `claude-sonnet-5`, `claude-sonnet-4.6` |
| **xAI** | 100,000 | `grok-4.3` |
| **Perplexity** | 100,000 | `sonar-pro` |
| **Qwen** | 100,000 | `qwen3.7-plus`, `qwen3.7-max`, `qwen3.6-flash` |
| **Mistral** | 100,000 | `mistral-medium-3.1` |

<div class="warning">

**⚠️ Quota share กันทั้ง Provider!**
- ใช้ `gpt-5.4` ไป 100K → `gpt-5.4-mini` เหลือแค่ 250K (ไม่ใช่ได้คนละ 350K!)
- ใช้ chat ที่ web playground.okmd.or.th ก็หัก quota ด้วย
- เช็ค quota: ดูที่ **Usage** ใน OKMD Playground

</div>

### เช็ค quota ผ่าน Hermes

```bash
hermes insights
```

<div class="success">

**Quota share กันทั้ง Provider** — ใช้ model หนึ่งหักจาก quota รวมของ provider นั้น

**1M tokens (DeepSeek) = ประมาณ:**
- 💬 1,000+ บทสนทนา/วัน
- 📄 อ่านเอกสาร ~250 หน้า/วัน
- 🔧 รันคำสั่ง ~500 ครั้ง/วัน

**ใช้ได้สบายๆ ไม่มีหมด!**

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
