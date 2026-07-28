# Changelog

บันทึกการเปลี่ยนแปลงทั้งหมดในโปรเจกต์นี้

รูปแบบตาม [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
และโปรเจกต์นี้ยึดตาม [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- กำลังพัฒนา...

---

## [1.3.0] - 2026-01-26

### Added
- เพิ่ม **Automated Tests** (`tests/test-install.sh`, `tests/test-config.sh`)
- เพิ่ม **CI/CD Pipeline** ด้วย GitHub Actions (`.github/workflows/test.yml`)
- เพิ่มโฟลเดอร์ **Screenshots** พร้อม `.gitkeep` และ `README.md`
- อัพเดท `README.md` ให้มีข้อมูลเกี่ยวกับ tests, CI/CD, screenshots
- Tests ครอบคลุม:
  - ตรวจสอบโครงสร้างไฟล์และโฟลเดอร์
  - Validate YAML syntax ใน configuration templates
  - ตรวจสอบ hardcoded secrets (ป้องกัน credential รั่ว)
  - ตรวจสอบ Markdown links
  - ตรวจสอบ `.gitignore` ว่ามี `.env`

### Changed
- อัพเดท version เป็น 1.3.0
- ปรับปรุงโครงสร้าง repo ให้พร้อมสำหรับการ contribution

---

## [1.2.0] - 2026-01-26

### Added
- เพิ่ม **LiteLLM Proxy** configuration ใน installation scripts
- รองรับ **LiteLLM Hosted** (Cloudflare Worker) สำหรับ Course 0
- รองรับ **LiteLLM Self-host** (Docker, Python) สำหรับ Advanced Users
- เพิ่ม **Fallback Configuration** ใน Hermes
- เพิ่มตารางเปรียบเทียบ LiteLLM Hosted vs Self-host
- เพิ่ม Troubleshooting สำหรับ LiteLLM ทั้ง 2 รูปแบบ
- เพิ่มการตรวจสอบ models ผ่าน API

### Changed
- ปรับปรุง **LiteLLM Guide** ให้สอดคล้องกับ `hermes-windows-test`
- อัพเดท configuration ให้รองรับทั้ง OKMD และ LiteLLM ในไฟล์เดียวกัน
- ปรับปรุง slides ให้มี LiteLLM section ครบถ้วน

### Fixed
- แก้ไข `hermes setup` ไม่ถาม API key สำหรับ custom provider (เพิ่มคำแนะนำใช้ `hermes model`)

---

## [1.1.0] - 2026-01-26

### Added
- เพิ่ม **คู่มือเปลี่ยน Model Provider และ API Key** (guides/02-change-provider.md)
- เพิ่มตัวอย่าง **Custom Provider** หลายรูปแบบ:
  - OKMD AI Playground
  - LiteLLM (Hosted + Self-host)
  - Ollama (Local Model)
  - Together AI
  - Azure OpenAI
- เพิ่มส่วน **Built-in Providers** ครบถ้วน:
  - OpenRouter
  - OpenAI
  - Anthropic (Claude)
  - Google Gemini
  - Groq
- เพิ่ม **Troubleshooting** สำหรับ provider setup
- เพิ่มตัวอย่าง **LiteLLM Config** หลายรูปแบบ:
  - หลาย Providers
  - Load Balancing
  - Fallback

### Changed
- ปรับปรุง **slides/slides.md** เพิ่มหัวข้อ "เปลี่ยน Model Provider"
- ปรับปรุงคู่มือให้ครอบคลุมทั้ง built-in และ custom providers
- อัพเดท quota information ให้เป็นปัจจุบัน (Jul 2026)

### Fixed
- แก้ไขปัญหา `hermes setup` ไม่ถาม API key สำหรับ custom provider
- แก้ไข quota information ให้ถูกต้อง (แยกตาม provider ไม่ใช่ราย model)

---

## [1.0.0] - 2026-01-26

### Added
- **Initial release** ของ Hermes Free Model Guide
- **Installation Scripts** สำหรับ 3 platforms:
  - Windows (PowerShell)
  - Linux (Bash)
  - macOS (Bash)
- **Uninstallation Scripts** สำหรับ 3 platforms
- **Features ใน Installation:**
  - ติดตั้ง Hermes Agent (user-space, ไม่ต้อง admin)
  - ติดตั้ง Antigravity CLI (agy) — Gemini free
  - ตั้งค่า OKMD AI Playground (ฟรี 23 models, สูงสุด 1M tokens/day)
  - ตั้งค่า Telegram Bot (ถาม Bot Token + Chat ID)
  - ตั้งค่า PATH ให้เรียก hermes, agy จากทุกโฟลเดอร์
  - ตั้งค่า auto-start services (Desktop, Dashboard, Telegram)
- **Auto-start Services** หลัง reboot:
  - Windows: Task Scheduler / Startup Folder
  - Linux: systemd user services
  - macOS: launchd agents
- **OKMD AI Playground Integration:**
  - รองรับ 23 models
  - Quota แยกตาม provider (100K - 1M tokens/day)
  - SSL workaround สำหรับ self-signed certificate
- **Slides (Marp)** สำหรับการสอน:
  - Module 1-6 ครบถ้วน
  - รองรับภาษาไทย
  - Render เป็น HTML, PDF, PPTX ได้
- **Documentation:**
  - README.md (คู่มือหลัก)
  - SECURITY.md (นโยบายความปลอดภัย)
  - guides/01-installation-guide.md (คู่มือติดตั้ง)
  - templates/ (config examples)
- **Security:**
  - .gitignore ป้องกัน credential leak
  - ไม่เก็บ API key ใน git
  - ใช้ placeholder ในเอกสาร

### Changed
- ไม่มี (initial release)

### Fixed
- ไม่มี (initial release)

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.2.0 | 2026-01-26 | เพิ่ม LiteLLM Proxy support |
| 1.1.0 | 2026-01-26 | เพิ่มคู่มือเปลี่ยน Provider + API Key |
| 1.0.0 | 2026-01-26 | Initial release |

---

## Contributing

ดู [CONTRIBUTING.md](CONTRIBUTING.md) สำหรับรายละเอียด

---

## Links

- **Repository:** https://github.com/pbseiya/hermes-free-model-guide
- **Issues:** https://github.com/pbseiya/hermes-free-model-guide/issues
- **Hermes Agent Docs:** https://hermes-agent.nousresearch.com/docs/
- **OKMD AI Playground:** https://playground.okmd.or.th
