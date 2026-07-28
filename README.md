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
```powershell
$f="$env:TEMP\hermes-install.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

---

## 📁 โครงสร้าง Repo

```
hermes-free-model-guide/
├── README.md                    # ไฟล์นี้
├── LICENSE                      # MIT License
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
│   └── 02-change-provider.md    # คู่มือเปลี่ยน Provider + API Key
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
- [02-change-provider.md](guides/02-change-provider.md) - คู่มือเปลี่ยน Provider + API Key (OKMD, LiteLLM, OpenRouter)

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
4. ✅ ตั้งค่า Telegram Bot (ถาม Bot Token + Chat ID)
5. ✅ ตั้งค่า PATH ให้เรียก `hermes`, `agy` จากทุกโฟลเดอร์
6. ✅ ตั้งค่า auto-start services (Desktop, Dashboard, Telegram)

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

ดู [SECURITY.md](SECURITY.md) สำหรับนโยบายความปลอดภัย

---

**License:** MIT  
**Author:** Hermes Agent Training Team  
**Last Updated:** 2026-01-26  
**Version:** 1.0.0
