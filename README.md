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

| Provider | Model | Rate Limit | จุดเด่น | สมัคร |
|----------|-------|------------|---------|-------|
| **OpenRouter** | `nvidia/nemotron-3-ultra:free` | 5 RPM | ดีที่สุดสำหรับ Hermes | [openrouter.ai](https://openrouter.ai) |
| **OpenRouter** | `google/gemma-3-31b-it:free` | 20 RPM | เร็ว context 262K | [openrouter.ai](https://openrouter.ai) |
| **Google AI Studio** | `gemini-2.5-flash` | 60 RPM | เร็วมาก 1M context | [aistudio.google.com](https://aistudio.google.com) |
| **Groq** | `llama-3.3-70b-versatile` | 30 RPM | เร็วที่สุด | [console.groq.com](https://console.groq.com) |
| **Nous Portal** | `hermes-4-70b` | Free | Nous Research's own | [portal.nousresearch.com](https://portal.nousresearch.com) |

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
