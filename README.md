# 🐍 ติดตั้ง Hermes Agent + ใช้ Free Model ได้ทันที

คู่มือติดตั้ง **Hermes Agent** (open-source AI agent โดย Nous Research) บน **Windows / Linux / macOS** พร้อมตั้งค่าใช้ **Free Model** — ไม่ต้องเสียเงินค่า API!

> **Course 0** — สำหรับผู้เริ่มต้น ไม่มีพื้นฐาน编程 ก็ทำได้

---

## 🎯 สิ่งที่ได้หลังจบบทเรียน

| ✅ | เป้าหมาย |
|----|-----------|
| 1 | ติดตั้ง Hermes Agent ได้สำเร็จ (ไม่ต้อง admin/sudo) |
| 2 | สร้าง API Key ฟรี (OpenRouter / Google Gemini / Groq) |
| 3 | ตั้งค่า Hermes ให้ใช้ Free Model |
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
├── SECURITY.md                  # นโยบายความปลอดภัย (ห้าม commit credentials)
├── .gitignore                   # ป้องกัน credential รั่ว
├── slides/
│   ├── slides.md                # Marp slide ทั้งหมด (Module 1-6)
│   └── README.md                # วิธี render slides
├── scripts/
│   ├── install-windows.ps1      # Windows installer
│   └── install-linux.sh         # Linux/macOS installer
├── guides/
│   ├── 01-what-is-hermes.md     # Hermes คืออะไร?
│   ├── 02-installation.md       # คู่มือติดตั้ง 3 OS
│   ├── 03-free-models.md        # เปรียบเทียบ Free Models
│   ├── 04-config.md             # ตั้งค่า Hermes + Free Model
│   ├── 05-telegram.md           # สร้าง Telegram Bot
│   └── 06-troubleshooting.md    # แก้ปัญหาที่พบบ่อย
└── templates/
    └── config.yaml              # ตัวอย่าง config (placeholder — ไม่มี key จริง)
```

---

## 🔑 Free Models ที่แนะนำ (อัปเดต Jul 2026)

OKMD AI Playground ให้ใช้ฟรี **23 models** — **quota share กันทั้ง Provider**

### Quota รวมตาม Provider

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

### ⚠️ ข้อควรระวังเรื่อง Quota

- **Quota share กันทั้ง Provider** — ใช้ `gpt-5.4` ไป 100K → `gpt-5.4-mini` เหลือแค่ 250K
- **ใช้ chat ที่ web playground.okmd.or.th ก็หัก quota ด้วย**
- เช็ค quota: ดูที่ **Usage** ใน OKMD Playground

### Models ที่แนะนำ

| Model | Provider | จุดเด่น |
|-------|----------|---------|
| `deepseek-v4-flash` | Deepseek | **Quota เยอะสุด 1M!** |
| `gpt-5.4-mini` | OpenAI | สมดุลดี ฉลาด+เร็ว |
| `llama-4-maverick` | Meta AI | Opensource, ฉลาด |
| `claude-sonnet-5` | Claude | งานซับซ้อน, เขียนโค้ด |

สมัคร: [playground.okmd.or.th](https://playground.okmd.or.th) (ฟรีสำหรับสมาชิก TK Park)

---

## 📖 ดู Slides

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

## ⚠️ คำเตือนเรื่อง Security

**ห้าม** commit API keys, tokens, หรือ credentials ขึ้น repo เด็ดขาด!

- ใส่ `.env` ใน `.gitignore` (done ✅)
- ใช้ placeholder ในเอกสาร: `YOUR_API_KEY_HERE`
- ตรวจสอบ `SECURITY.md` ก่อน commit

---

## 📚 อ้างอิง

- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- [OpenRouter Free Models](https://openrouter.ai/models?q=free)
- [Google AI Studio](https://aistudio.google.com)
- [Groq Console](https://console.groq.com)
- [Inspired by: Medium Article by Ausada — OpenClaw กับ OKMD AI Playground](https://medium.com/@ausada)

---

**License:** MIT
**Author:** Hermes Agent Training Team
**Last Updated:** 2026-07-27
