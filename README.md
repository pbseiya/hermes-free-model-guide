# 🐍 ติดตั้ง Hermes Agent + ใช้ Free Model ได้ทันที

คู่มือติดตั้ง **Hermes Agent** (open-source AI agent โดย Nous Research) บน **Windows / Linux / macOS** พร้อมตั้งค่าใช้ **Free Model** — ไม่ต้องเสียเงินค่า API!

> **Course 0** — สำหรับผู้เริ่มต้น ไม่มีพื้นฐาน编程 ก็ทำได้

---

## 🎯 สิ่งที่ได้หลังจบบทเรียน

| ✅ | เป้าหมาย |
|----|-----------|
| 1 | ติดตั้ง Hermes Agent ได้สำเร็จ (ไม่ต้อง admin/sudo) |
| 2 | สร้าง API Key ฟรีจาก OKMD AI Playground (สูงสุด 1M tokens/day) |
| 3 | ตั้งค่า Hermes ให้ใช้ Free Model (OKMD / LiteLLM / OpenRouter) |
| 4 | สร้าง Telegram Bot และเชื่อมกับ Hermes |
| 5 | ทดสอบใช้งานจริงได้ |

---

## 🚀 ติดตั้งด่วน (One-Line)

### Windows (PowerShell)

**วิธีที่ 1: สั้น (แนะนำ)**
```powershell
irm https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1 | iex
```

**วิธีที่ 2: ยาว (เสถียรกว่า สำหรับ interactive prompts)**
```powershell
$f="$env:TEMP\hermes-install.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

---

## 🔑 ค่าที่ต้องใส่หลังติดตั้ง

หลังติดตั้งเสร็จ ต้องใส่ค่าเหล่านี้เพื่อให้ Hermes ใช้งานได้:

### 🔴 จำเป็น (ต้องใส่)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **OKMD API Key** | สมัครที่ [playground.okmd.or.th](https://playground.okmd.or.th) | ใช้เรียก 23 free models |

**วิธีสมัคร OKMD:**
1. Login ด้วย Google Account
2. ไปที่ Settings → API Platform
3. Generate API Key (ขึ้นต้นด้วย `sk_...`)
4. Copy key มาวางตอน install หรือใส่ทีหลัง

### 🟡 Optional (ใส่ก็ได้ ไม่ใส่ก็ได้)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **LiteLLM API Key** | Instructor ให้มา (Course 0) | ใช้ LiteLLM Proxy แทน OKMD |
| **Telegram Bot Token** | สร้างจาก [@BotFather](https://t.me/BotFather) | คุยกับ Hermes ผ่าน Telegram |
| **Telegram Chat ID** | หาจาก [@userinfobot](https://t.me/userinfobot) | จำกัดให้เฉพาะคุณใช้ Bot ได้ |

### 🔄 ขั้นตอนหลังติดตั้ง

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

### 📊 สรุป

| สถานะ | ค่าที่ต้องใส่ | วิธีใส่ |
|-------|---------------|---------|
| **Minimal** | OKMD API Key เท่านั้น | แก้ `.env` โดยตรง หรือ `hermes env set` |
| **Full setup** | OKMD + Telegram Bot + Chat ID | แก้ `.env` + `hermes gateway setup` |
| **Course 0** | LiteLLM API Key (จาก instructor) | แก้ `.env` โดยตรง |

**หมายเหตุ:** `hermes setup` ใช้ได้เฉพาะ built-in providers (OpenAI, Anthropic, etc.) เท่านั้น
สำหรับ custom providers (OKMD, LiteLLM Proxy) ต้องตั้งค่าผ่านไฟล์ config โดยตรง

---

## 📁 โครงสร้าง Repo

```
hermes-free-model-guide/
├── README.md                    # ไฟล์นี้
├── LICENSE                      # MIT License
├── CONTRIBUTING.md              # วิธีมีส่วนร่วมในโปรเจกต์
├── CHANGELOG.md                 # บันทึกการเปลี่ยนแปลง
├── SECURITY.md                  # นโยบายความปลอดภัย (ห้าม commit credentials)
├── .gitignore                   # ป้องกัน credential รั่ว
├── slides/
│   ├── slides.md                # Marp slide ทั้งหมด (Module 1-6)
│   └── README.md                # วิธี render slides
├── scripts/
│   ├── install-windows.ps1      # Windows installer
│   ├── install-linux.sh         # Linux/macOS installer
│   ├── uninstall-windows.ps1    # Windows uninstaller
│   └── uninstall-linux.sh       # Linux/macOS uninstaller
├── guides/
│   ├── 01-installation-guide.md # คู่มือติดตั้ง 3 OS
│   ├── 02-change-provider.md    # คู่มือเปลี่ยน Provider + API Key (OKMD, LiteLLM, OpenRouter)
│   ├── 03-okmd-setup.md         # คู่มือสมัครและตั้งค่า OKMD AI Playground
│   ├── 04-telegram-setup.md     # คู่มือสร้างและตั้งค่า Telegram Bot
│   └── 05-troubleshooting.md    # คู่มือแก้ปัญหาที่พบบ่อย
├── examples/
│   ├── okmd-config.md           # ตัวอย่าง config สำหรับ OKMD
│   ├── litellm-hosted-config.md # ตัวอย่าง config สำหรับ LiteLLM Hosted (Course 0)
│   ├── litellm-selfhost-config.md # ตัวอย่าง config สำหรับ LiteLLM Self-host
│   ├── openrouter-config.md     # ตัวอย่าง config สำหรับ OpenRouter
│   ├── openai-config.md         # ตัวอย่าง config สำหรับ OpenAI
│   └── fallback-config.md       # ตัวอย่าง config สำหรับ Fallback (หลาย providers)
├── tests/
│   ├── test-install.sh          # ทดสอบ installation script
│   └── test-config.sh           # ทดสอบ configuration templates
├── .github/
│   └── workflows/
│       └── test.yml             # CI/CD pipeline (GitHub Actions)
├── screenshots/
│   └── .gitkeep                 # โฟลเดอร์สำหรับ screenshots
└── templates/
    ├── config.yaml              # ตัวอย่าง config (placeholder — ไม่มี key จริง)
    └── env.example              # ตัวอย่าง .env file
```

---

## 🗑️ Uninstallation

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

- ✅ Hermes Agent และ configuration ทั้งหมด
- ✅ Startup services (Desktop, Dashboard, Telegram Gateway)
- ✅ `~/.hermes` directory (sessions, logs, config)
- ✅ PATH entries
- ⚠️ **agy** (Antigravity CLI) — ลบด้วย `--remove-agy` หรือ `-RemoveAgy`
- ⚠️ **Node.js** — ลบด้วย `--remove-node` หรือ `-RemoveNode`

---

## 🔑 Free Models ที่แนะนำ

### OKMD AI Playground (แนะนำ)

OKMD ให้ใช้ฟรี **23 models** — **quota share กันทั้ง Provider**

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

**สมัคร:** [playground.okmd.or.th](https://playground.okmd.or.th) (ฟรีสำหรับสมาชิก TK Park)

### LiteLLM Proxy

**Course 0** ใช้ LiteLLM Proxy ที่ host บน Cloudflare Workers:
- Default model: `qwen3.7-plus`
- ไม่ต้องติดตั้ง LiteLLM เอง
- ใส่ API Key ที่ instructor ให้มาก็ใช้ได้ทันที

ดูรายละเอียดเพิ่มเติม: [guides/02-change-provider.md](guides/02-change-provider.md)

### Models ที่แนะนำ

| Model | Provider | จุดเด่น |
|-------|----------|---------|
| `deepseek-v4-flash` | OKMD (Deepseek) | **Quota เยอะสุด 1M!** |
| `gpt-5.4-mini` | OKMD (OpenAI) | สมดุลดี ฉลาด+เร็ว |
| `qwen3.7-plus` | LiteLLM | Course 0 default |
| `llama-4-maverick` | OKMD (Meta AI) | Opensource, ฉลาด |
| `claude-sonnet-5` | OKMD (Claude) | งานซับซ้อน, เขียนโค้ด |

---

## 📖 คู่มือและเอกสาร

### Guides
- [01-installation-guide.md](guides/01-installation-guide.md) - คู่มือติดตั้ง 3 OS
- [02-change-provider.md](guides/02-change-provider.md) - คู่มือเปลี่ยน Provider + API Key
- [03-okmd-setup.md](guides/03-okmd-setup.md) - คู่มือสมัครและตั้งค่า OKMD AI Playground
- [04-telegram-setup.md](guides/04-telegram-setup.md) - คู่มือสร้างและตั้งค่า Telegram Bot
- [05-troubleshooting.md](guides/05-troubleshooting.md) - คู่มือแก้ปัญหาที่พบบ่อย

### Examples (Configuration Templates)
- [okmd-config.md](examples/okmd-config.md) - ตัวอย่าง config สำหรับ OKMD
- [litellm-hosted-config.md](examples/litellm-hosted-config.md) - ตัวอย่าง config สำหรับ LiteLLM Hosted (Course 0)
- [litellm-selfhost-config.md](examples/litellm-selfhost-config.md) - ตัวอย่าง config สำหรับ LiteLLM Self-host
- [openrouter-config.md](examples/openrouter-config.md) - ตัวอย่าง config สำหรับ OpenRouter
- [openai-config.md](examples/openai-config.md) - ตัวอย่าง config สำหรับ OpenAI
- [fallback-config.md](examples/fallback-config.md) - ตัวอย่าง config สำหรับ Fallback (หลาย providers)

### Slides
```bash
# Render เป็น HTML (เปิดดูใน browser ได้เลย)
npx @marp-team/marp-cli slides/slides.md --html

# Render เป็น PDF
npx @marp-team/marp-cli slides/slides.md --pdf

# Preview แบบ live
npx @marp-team/marp-cli slides/slides.md -s
```

หรืออ่านแบบ Markdown ใน [slides/slides.md](slides/slides.md)

---

## ⚙️ Installation Scripts Features

### Install Scripts ทำอะไร?

1. ✅ ติดตั้ง Hermes Agent (user-space, ไม่ต้อง admin)
2. ✅ ติดตั้ง Antigravity CLI (agy) — Gemini free via Google Account
3. ✅ ตั้งค่า OKMD AI Playground (ถาม API Key ตอนติดตั้ง)
4. ✅ ตั้งค่า LiteLLM Proxy (ถาม API Key สำหรับ Course 0)
5. ✅ ตั้งค่า Telegram Bot (ถาม Bot Token + Chat ID)
6. ✅ ตั้งค่า PATH ให้เรียก `hermes`, `agy` จากทุกโฟลเดอร์
7. ✅ ตั้งค่า auto-start services (Desktop, Dashboard, Telegram)

### Auto-start Services หลัง Reboot

| OS | Services | Method |
|----|----------|--------|
| **Windows** | Telegram, Dashboard, Desktop | Task Scheduler / Startup Folder |
| **Linux** | Telegram, Dashboard, Desktop | systemd user services |
| **macOS** | Telegram, Dashboard, Desktop | launchd agents |

---

## ⚠️ คำเตือนเรื่อง Security

**ห้าม** commit API keys, tokens, หรือ credentials ขึ้น repo เด็ดขาด!

- ใส่ `.env` ใน `.gitignore` (done ✅)
- ใช้ placeholder ในเอกสาร: `YOUR_API_KEY_HERE`
- ตรวจสอบ `SECURITY.md` ก่อน commit
- Installation scripts ไม่เก็บ API key ใน git

---

## 📚 อ้างอิง

- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- [OKMD AI Playground](https://playground.okmd.or.th)
- [LiteLLM Proxy](https://docs.litellm.ai/)
- [OpenRouter Free Models](https://openrouter.ai/models?q=free)
- [Inspired by: Medium Article by Ausada — OpenClaw กับ OKMD AI Playground](https://medium.com/@ausada)

---

## 🤝 Contributing

ดู [CONTRIBUTING.md](CONTRIBUTING.md) สำหรับรายละเอียดวิธีมีส่วนร่วมในโปรเจกต์

---

## 🧪 Testing

Repo นี้มี automated tests เพื่อตรวจสอบความถูกต้อง:

### รัน Tests Locally

```bash
# ทดสอบ installation scripts
bash tests/test-install.sh

# ทดสอบ configuration templates
bash tests/test-config.sh
```

### CI/CD Pipeline

GitHub Actions จะรัน tests อัตโนมัติทุกครั้งที่ push หรือสร้าง pull request:
- ตรวจสอบโครงสร้างไฟล์
- Validate YAML syntax
- ตรวจสอบ hardcoded secrets
- ตรวจสอบ Markdown links

ดู workflow ที่ [`.github/workflows/test.yml`](.github/workflows/test.yml)

---

## 📸 Screenshots

โฟลเดอร์ `screenshots/` ใช้เก็บ screenshots สำหรับเอกสาร

**Screenshots ที่แนะนำ:**
- `hermes-setup-screenshot.png` - หน้าจอนี้ตอนรัน `hermes setup`
- `hermes-cli-screenshot.png` - หน้าจอนี้ตอนรัน `hermes` หรือ `hermes chat`
- `telegram-bot-test-screenshot.png` - หน้าจอนี้ตอนทดสอบ Telegram bot
- `okmd-quota-screenshot.png` - หน้าจอนี้แสดง OKMD quota
- `vscode-hermes-screenshot.png` - หน้าจอนี้ VSCode ที่ติดตั้ง Hermes extension

ดูรายละเอียดเพิ่มเติมที่ [`screenshots/README.md`](screenshots/README.md)

---

**License:** MIT  
**Author:** Hermes Agent Training Team  
**Last Updated:** 2026-01-26  
**Version:** 1.3.0
