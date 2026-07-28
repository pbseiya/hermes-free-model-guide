# Troubleshooting Guide

คู่มือแก้ปัญหาที่พบบ่อยในการติดตั้งและใช้งาน Hermes Agent

---

## ปัญหาการติดตั้ง

### ❌ "hermes: command not found"

**สาเหตุ:** PATH ยังไม่ถูกอัพเดท หรือต้อง restart terminal

**วิธีแก้:**

**Linux/macOS:**
```bash
# Restart terminal หรือ
source ~/.bashrc   # สำหรับ bash
source ~/.zshrc    # สำหรับ zsh

# หรือเพิ่ม PATH manually
export PATH="$HOME/.local/bin:$PATH"
```

**Windows:**
```powershell
# เปิด PowerShell ใหม่
# หรือ
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
```

---

### ❌ Installation script fails

**สาเหตุ:** Internet connection, permissions, หรือ dependencies

**วิธีแก้:**

1. **ตรวจสอบ Internet connection:**
```bash
curl -I https://hermes-agent.nousresearch.com
```

2. **ตรวจสอบ permissions:**
```bash
# Linux/macOS
chmod +x install-linux.sh
./install-linux.sh
```

3. **ดู error logs:**
```bash
# Linux/macOS
./install-linux.sh 2>&1 | tee install.log

# Windows
powershell -ExecutionPolicy Bypass -File install-windows.ps1 *> install.log
```

---

### ❌ Node.js installation fails

**สาเหตุ:** Download failed หรือ version ไม่ตรง

**วิธีแก้:**

**Linux/macOS:**
```bash
# ติดตั้ง Node.js ด้วย nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 22
nvm use 22
```

**Windows:**
```powershell
# ดาวน์โหลด Node.js installer
# https://nodejs.org/dist/v22.12.0/node-v22.12.0-x64.msi
```

---

## ปัญหา OKMD API

### ❌ "401 Unauthorized"

**สาเหตุ:** API Key ผิด หรือไม่ได้ตั้งใน `.env`

**วิธีแก้:**

```bash
# ตรวจสอบ API key ใน .env
cat ~/.hermes/.env | grep OKMD

# ตั้ง API key ใหม่
hermes env set OKMD_API_KEY sk_correct_key_here
```

---

### ❌ "SSL certificate error"

**สาเหตุ:** OKMD ใช้ self-signed certificate

**วิธีแก้:**

เพิ่มใน `~/.hermes/.env`:

```bash
NODE_TLS_REJECT_UNAUTHORIZED=0
```

Installation script จะเพิ่มให้อัตโนมัติ

---

### ❌ "Model not found"

**สาเหตุ:** Model ไม่มีใน OKMD หรือพิมพ์ผิด

**วิธีแก้:**

```bash
# ดู models ที่มี
curl -sk https://gen.ai.kku.ac.th/okmd/api/v1/models \
  -H "Authorization: Bearer $OKMD_API_KEY" | python3 -m json.tool

# ตรวจสอบ model name
hermes config get model.default
```

---

### ❌ Quota หมด

**สาเหตุ:** ใช้ quota เกิน limit ของ provider

**วิธีแก้:**

1. **เช็ค quota:**
```bash
hermes insights
```

2. **สลับไปใช้ provider อื่น:**
```bash
# ใช้ DeepSeek (1M quota)
hermes config set model.default deepseek-v4-flash

# หรือ LiteLLM
hermes config set model.provider custom:litellm
hermes config set model.default qwen3.7-plus
```

3. **รอจนกว่า quota จะ reset (ทุกวัน 00:00 UTC)**

---

## ปัญหา Telegram Bot

### ❌ Bot ไม่ตอบ

**สาเหตุ:** Gateway ไม่ทำงาน หรือ Bot Token ผิด

**วิธีแก้:**

```bash
# เช็ค gateway status
hermes gateway status

# ถ้าไม่ทำงาน
hermes gateway restart

# เช็ค log
tail ~/.hermes/logs/gateway.log

# ตรวจสอบ Bot Token
cat ~/.hermes/.env | grep TELEGRAM_BOT_TOKEN
```

---

### ❌ "Unauthorized" (Telegram)

**สาเหตุ:** Bot Token ผิด

**วิธีแก้:**

1. ไปที่ @BotFather
2. ส่ง `/mybots`
3. เลือก bot
4. คลิก "API Token"
5. Copy token ใหม่
6. อัพเดทใน `.env`:

```bash
hermes env set TELEGRAM_BOT_TOKEN new_token_here
hermes gateway restart
```

---

### ❌ "User not allowed"

**สาเหตุ:** Chat ID ผิด หรือไม่ได้ตั้ง

**วิธีแก้:**

1. ไปที่ @userinfobot
2. ส่ง `/start`
3. Copy Chat ID
4. อัพเดทใน `.env`:

```bash
hermes env set TELEGRAM_ALLOWED_USERS your_chat_id_here
hermes gateway restart
```

---

### ❌ Gateway crash loop

**สาเหตุ:** Configuration error หรือ memory leak

**วิธีแก้:**

```bash
# เช็ค log
tail -f ~/.hermes/logs/gateway.log

# restart
hermes gateway restart

# ถ้ายัง crash → reinstall
hermes uninstall
# รัน installation script ใหม่
```

---

## ปัญหา Provider

### ❌ "Provider not found"

**สาเหตุ:** ใส่ชื่อ provider ผิด

**วิธีแก้:**

```bash
# ดู providers ที่มี
hermes config get custom_providers

# ใช้ชื่อที่ถูกต้อง
hermes config set model.provider custom:okmd
```

---

### ❌ `hermes setup` ไม่ถาม API key

**สาเหตุ:** `hermes setup` เป็น wizard สำหรับ built-in providers เท่านั้น

**วิธีแก้:**

ใช้ `hermes model` แทน:

```bash
hermes model
```

เลือก:
- Provider: **Custom endpoint**
- Base URL: ใส่ URL
- API Key: ใส่ API key
- Model: ใส่ model name

---

### ❌ API Key ไม่ทำงาน

**สาเหตุ:** API Key หมดอายุ หรือผิด

**วิธีแก้:**

1. **ตรวจสอบ API Key:**
```bash
hermes env show
```

2. **ขอ API Key ใหม่:**
- OKMD: https://playground.okmd.or.th
- OpenRouter: https://openrouter.ai/keys
- LiteLLM: ติดต่อ instructor

3. **อัพเดท API Key:**
```bash
hermes env set OKMD_API_KEY new_key_here
```

---

## ปัญหา Auto-start

### ❌ Services ไม่เริ่มหลัง reboot

**สาเหตุ:** Service ไม่ได้ enable หรือ configuration ผิด

**วิธีแก้:**

**Linux (systemd):**
```bash
# enable services
systemctl --user enable hermes-gateway
systemctl --user enable hermes-dashboard
systemctl --user enable hermes-desktop

# start services
systemctl --user start hermes-gateway
systemctl --user start hermes-dashboard
systemctl --user start hermes-desktop

# check status
systemctl --user status hermes-gateway
```

**macOS (launchd):**
```bash
# load services
launchctl load ~/Library/LaunchAgents/com.hermes.gateway.plist
launchctl load ~/Library/LaunchAgents/com.hermes.dashboard.plist
launchctl load ~/Library/LaunchAgents/com.hermes.desktop.plist

# check status
launchctl list | grep hermes
```

**Windows:**
```powershell
# check task
schtasks /Query /TN "HermesGateway"

# run task
schtasks /Run /TN "HermesGateway"
```

---

## ปัญหา Performance

### ❌ Hermes ช้า

**สาเหตุ:** Model ช้า, Internet ช้า, หรือ machine มี resource น้อย

**วิธีแก้:**

1. **สลับไปใช้ model ที่เร็วกว่า:**
```bash
hermes config set model.default gpt-5.4-nano
```

2. **ตรวจสอบ Internet speed:**
```bash
curl -o /dev/null -s -w '%{speed_download}\n' https://gen.ai.kku.ac.th/okmd/api/v1/models
```

3. **ปิด applications อื่นๆ ที่ใช้ resource มาก**

---

### ❌ ใช้ memory มาก

**สาเหตุ:** Session ยาวเกินไป หรือมี tools มากเกินไป

**วิธีแก้:**

1. **เริ่ม session ใหม่:**
```bash
/new
```

2. **ปิด tools ที่ไม่ได้ใช้:**
```bash
hermes config edit
# ปิด toolsets ที่ไม่ได้ใช้
```

3. **Restart Hermes:**
```bash
exit
hermes
```

---

## ปัญหา Uninstallation

### ❌ Uninstall ไม่สำเร็จ

**สาเหตุ:** Files ถูก lock หรือ permissions ผิด

**วิธีแก้:**

**Linux/macOS:**
```bash
# ใช้ --force
./uninstall-linux.sh --force

# หรือลบ manually
rm -rf ~/.hermes
rm -rf ~/.local/bin/hermes
```

**Windows:**
```powershell
# ใช้ -Force
powershell -ExecutionPolicy Bypass -File uninstall-windows.ps1 -Force

# หรือลบ manually
Remove-Item -Recurse -Force "$env:USERPROFILE\.hermes"
Remove-Item -Force "$env:USERPROFILE\.local\bin\hermes.cmd"
```

---

## Diagnostic Commands

ใช้คำสั่งเหล่านี้เพื่อวินิจฉัยปัญหา:

```bash
# ตรวจสอบ Hermes version
hermes --version

# ตรวจสอบ configuration
hermes config get

# ตรวจสอบ environment variables
hermes env show

# ตรวจสอบ provider
hermes model test

# ตรวจสอบ gateway status
hermes gateway status

# ดู logs
tail ~/.hermes/logs/gateway.log

# ตรวจสอบ system health
hermes doctor
```

---

## Getting Help

ถ้ายังแก้ปัญหาไม่ได้:

1. **ตรวจสอบ logs:**
```bash
tail ~/.hermes/logs/gateway.log
```

2. **เปิด issue บน GitHub:**
https://github.com/pbseiya/hermes-free-model-guide/issues

3. **ระบุข้อมูล:**
- OS และ version
- Hermes version
- Error message
- Steps to reproduce

---

## Links

- Hermes Agent Docs: https://hermes-agent.nousresearch.com/docs/
- GitHub Issues: https://github.com/pbseiya/hermes-free-model-guide/issues
- OKMD Playground: https://playground.okmd.or.th
