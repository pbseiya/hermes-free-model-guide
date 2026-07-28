---
marp: true
theme: default
paginate: false
style: |
  section {
    font-family: 'Sarabun', 'TH Sarabun New', sans-serif;
    background: white;
    font-size: 0.75em;
  }
  h1 { color: #1e40af; font-size: 1.8em; margin-bottom: 4px; }
  h2 { color: #2563eb; font-size: 1.2em; margin: 8px 0 4px 0; }
  h3 { color: #3b82f6; font-size: 1em; margin: 6px 0 2px 0; }
  code {
    background: #f3f4f6;
    padding: 1px 4px;
    border-radius: 3px;
    font-family: 'Fira Code', monospace;
    font-size: 0.9em;
  }
  pre code {
    display: block;
    padding: 8px;
    background: #1e293b;
    color: #e2e8f0;
    border-radius: 6px;
    font-size: 0.85em;
    margin: 4px 0;
  }
  table { width: 100%; border-collapse: collapse; margin: 4px 0; }
  th { background: #2563eb; color: white; padding: 4px 8px; text-align: left; font-size: 0.9em; }
  td { padding: 3px 8px; border-bottom: 1px solid #e5e7eb; font-size: 0.9em; }
  tr:nth-child(even) { background: #f9fafb; }
  .card { display: flex; gap: 16px; }
  .column { flex: 1; }
  .box { background: #f0f9ff; border: 1px solid #bae6fd; border-radius: 8px; padding: 10px; margin: 6px 0; }
  .warning-box { background: #fef3c7; border: 1px solid #fcd34d; border-radius: 8px; padding: 10px; margin: 6px 0; }
  .success-box { background: #d1fae5; border: 1px solid #6ee7b7; border-radius: 8px; padding: 10px; margin: 6px 0; }
---

# 📋 Quick Reference Card — Hermes Agent + Free Model

<div class="card">
<div class="column">

## 🚀 ติดตั้ง

### Windows (PowerShell)
```powershell
$f="$env:TEMP\hermes-install.ps1"; irm 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

## ✅ ตรวจสอบ
```bash
hermes --version
hermes chat
```

## 🔑 OKMD API Key
- สมัคร: https://playground.okmd.or.th
- ฟรี 23 models, สูงสุด 1M tokens/day

## 📱 Telegram Bot
1. Chat @BotFather → `/newbot`
2. ตั้งชื่อ → Copy token
3. `hermes config set telegram.token TOKEN`
4. `hermes config set telegram.chat_id CHAT_ID`
5. `hermes gateway telegram start`

</div>
<div class="column">

## 🔧 คำสั่งสำคัญ

| คำสั่ง | คำอธิบาย |
|--------|----------|
| `hermes` | เริ่ม chat |
| `hermes chat` | เริ่ม chat (เช่นเดียวกับ hermes) |
| `hermes setup` | ตั้งค่าเริ่มต้น |
| `hermes model set PROVIDER:MODEL` | เปลี่ยน model |
| `hermes config set KEY VALUE` | แก้ config |
| `hermes memory list` | ดู memory |
| `hermes memory add "ข้อความ"` | เพิ่ม memory |
| `hermes gateway telegram start` | เปิด Telegram bot |
| `hermes gateway telegram stop` | ปิด Telegram bot |
| `hermes update` | อัพเดท Hermes |
| `hermes --version` | ดู version |

## 🔄 เปลี่ยน Model

```bash
# OKMD models
hermes model set custom:okmd gpt-5.4-mini
hermes model set custom:okmd deepseek-v4-flash
hermes model set custom:okmd claude-sonnet-5

# OpenRouter (free)
hermes model set openrouter nvidia/nemotron-3-ultra:free
```

## 📁 ไฟล์สำคัญ

| ไฟล์ | ตำแหน่ง (Linux) | ตำแหน่ง (Windows) |
|------|-----------------|-------------------|
| Config | `~/.hermes/config.yaml` | `%USERPROFILE%\.hermes\config.yaml` |
| .env | `~/.hermes/.env` | `%USERPROFILE%\.hermes\.env` |
| Sessions | `~/.hermes/sessions/` | `%USERPROFILE%\.hermes\sessions\` |

## ⚠️ แก้ปัญหา SSL

เพิ่มใน `~/.hermes/.env`:
```
NODE_TLS_REJECT_UNAUTHORIZED=0
```

</div>
</div>

<div class="card">
<div class="column">

<div class="box">

### 💰 Free Models (OKMD)

| Model | Quota/วัน | จุดเด่น |
|-------|-----------|---------|
| `deepseek-v4-flash` | 1M (shared) | เร็ว, ถูก |
| `gpt-5.4-mini` | 350K (shared) | สมดุลดี |
| `claude-sonnet-5` | 180K (shared) | เขียนโค้ดเก่ง |
| `gemini-3.5-flash` | 200K (shared) | เร็ว, หลายภาษา |
| `qwen3.7-plus` | 100K (shared) | ดีกับภาษาไทย |

**Quota share กันทั้ง Provider** — ใช้ model ไหนก็ได้ใน Provider เดียวกัน

</div>

</div>
<div class="column">

<div class="warning-box">

### 🚨 Troubleshooting

| ปัญหา | วิธีแก้ |
|--------|---------|
| `hermes: command not found` | เปิด terminal ใหม่ / เช็ค PATH |
| SSL error | ตั้ง `NODE_TLS_REJECT_UNAUTHORIZED=0` |
| API key ไม่ทำงาน | ตรวจสอบว่า copy ถูกต้อง ไม่มี space |
| Telegram ไม่ตอบ | เช็ค token + chat_id, restart gateway |
| Permission denied (Linux) | ไม่ต้อง sudo! เช็ค ownership |
| PowerShell ไม่รัน | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |

</div>

<div class="success-box">

### 📚 แหล่งข้อมูลเพิ่มเติม

- **Repo:** github.com/pbseiya/hermes-free-model-guide
- **Docs:** hermes-agent.nousresearch.com/docs
- **OKMD:** playground.okmd.or.th
- **Uninstall:** `hermes uninstall` หรือรัน uninstall script

</div>

</div>
</div>

---

## 🗑️ Uninstall

### Windows
```powershell
$f="$env:TEMP\hermes-uninstall.ps1"; irm 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-windows.ps1' -OutFile $f; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/uninstall-linux.sh | bash
```
