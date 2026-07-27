# คู่มือติดตั้ง Hermes Agent + OKMD Free Model

คู่มือฉบับเต็มสำหรับการติดตั้ง Hermes Agent และตั้งค่าใช้ OKMD AI Playground (ฟรี 200K tokens/day)

---

## สารบัญ

1. [สิ่งที่ต้องมี](#สิ่งที่ต้องมี)
2. [ติดตั้งบน Windows](#ติดตั้งบน-windows)
3. [ติดตั้งบน macOS](#ติดตั้งบน-macos)
4. [ติดตั้งบน Linux](#ติดตั้งบน-linux)
5. [สมัคร OKMD API Key](#สมัคร-okmd-api-key)
6. [ตั้งค่า Hermes + OKMD](#ตั้งค่า-hermes--okmd)
7. [สร้าง Telegram Bot](#สร้าง-telegram-bot)
8. [ทดสอบใช้งาน](#ทดสอบใช้งาน)
9. [แก้ไขปัญหา](#แก้ไขปัญหา)

---

## สิ่งที่ต้องมี

- ✅ คอมพิวเตอร์ (Windows 10+ / macOS 10.14+ / Linux)
- ✅ Internet
- ✅ Google Account (สำหรับสมัคร OKMD)
- ✅ Telegram App (ถ้าจะใช้ Telegram)

### สำหรับ Windows

- PowerShell 5.1+ (มีอยู่แล้วใน Windows 10/11)
- **ไม่ต้อง admin rights**

---

## ติดตั้งบน Windows

### วิธีที่ 1: One-Line Command (แนะนำ)

เปิด PowerShell แล้ววางคำสั่งนี้:

```powershell
$f="$env:TEMP\hermes-install.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

### วิธีที่ 2: ดาวน์โหลดสคริปต์

1. ดาวน์โหลด: [install-windows.ps1](../scripts/install-windows.ps1)
2. เปิด PowerShell
3. รันสคริปต์:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   .\install-windows.ps1
   ```

---

## ติดตั้งบน macOS

### One-Line Command

```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

### ดาวน์โหลดสคริปต์

```bash
curl -O https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh
chmod +x install-linux.sh
./install-linux.sh
```

---

## ติดตั้งบน Linux

### One-Line Command

```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

### ดาวน์โหลดสคริปต์

```bash
wget https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh
chmod +x install-linux.sh
./install-linux.sh
```

---

## สมัคร OKMD API Key

OKMD AI Playground ให้ใช้ AI ฟรี 200,000 tokens/day จากภาครัฐไทย

### ขั้นตอน

1. เข้า 👉 https://playground.okmd.or.th
2. Login ด้วย Google Account (หรือสมัครสมาชิก TK Park ฟรี)
3. ไปที่ **Settings → API Platform**
4. กด **"Generate API Key"**
5. Copy key ที่ได้ (ขึ้นต้นด้วย `sk_...`)

### เก็บ Key ไว้ที่ไหน?

- เก็บไว้ใน `.env` file เท่านั้น
- **ห้าม** แชร์ให้ใคร
- **ห้าม** upload ขึ้น GitHub
- ถ้าทำหาย → ไป generate ใหม่ได้

---

## ตั้งค่า Hermes + OKMD

### วิธีที่ 1: ใช้คำสั่ง (แนะนำ)

```bash
hermes setup
```

เลือก:
1. **Provider** → Custom endpoint
2. **Base URL** → `https://gen.ai.kku.ac.th/okmd/api/v1`
3. **API Key** → วาง OKMD key
4. **Model** → `gemini-3.5-flash`

### วิธีที่ 2: แก้ config เอง

```bash
hermes config edit
```

เพิ่ม:

```yaml
model:
  provider: custom:okmd
  default: gemini-3.5-flash

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
```

จากนั้นเพิ่ม API key ใน `.env`:

```bash
hermes config env-path
# จะได้ path เช่น ~/.hermes/.env
```

```bash
# ~/.hermes/.env
OKMD_API_KEY=sk_YOUR_KEY_HERE
NODE_TLS_REJECT_UNAUTHORIZED=0
```

### ⚠️ สำคัญ: SSL Certificate

OKMD ใช้ self-signed certificate ต้องตั้ง environment variable:

```bash
# เพิ่มใน ~/.hermes/.env
NODE_TLS_REJECT_UNAUTHORIZED=0
```

จากนั้น restart:

```bash
hermes gateway restart
```

---

## สร้าง Telegram Bot

### ขั้นตอนที่ 1: สร้าง Bot

1. เปิด Telegram → ค้นหา `@BotFather`
2. ส่งคำสั่ง: `/newbot`
3. ตั้งชื่อ bot: **"My AI Assistant"**
4. ตั้ง username: `my_ai_hermes_bot` (ต้องลงท้ายด้วย `bot`)
5. BotFather จะส่ง **Bot Token** กลับมา (เก็บไว้!)

### ขั้นตอนที่ 2: หา User ID

1. เปิด Telegram → ค้นหา `@userinfobot`
2. ส่ง `/start`
3. Copy เลข ID ที่ได้ (เช่น `123456789`)

### ขั้นตอนที่ 3: ตั้งค่าใน Hermes

```bash
hermes gateway setup
# เลือก Telegram → วาง Bot Token
```

หรือแก้ `.env` โดยตรง:

```bash
# ~/.hermes/.env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHI...
TELEGRAM_ALLOWED_USERS=123456789
```

### ขั้นตอนที่ 4: เริ่ม Gateway

```bash
hermes gateway start
```

---

## ทดสอบใช้งาน

### ทดสอบใน Terminal

```bash
hermes

# พิมพ์อะไรก็ได้
You: สวัสดี ช่วยอะไรได้บ้าง?
Hermes: สวัสดีครับ! ผมเป็น AI Agent...
```

### ทดสอบใน Telegram

1. เปิด Telegram → หา bot ที่สร้าง
2. ส่ง: `/start`
3. ส่ง: `สวัสดี`
4. ถ้า Hermes ตอบกลับ = **สำเร็จ!** 🎉

### คำสั่งทดสอบ

```
/help              # ดูคำสั่งทั้งหมด
/model             # ดู/เปลี่ยน model
/new               # เริ่ม chat ใหม่
/status            # ดูสถานะ
```

### ทดสอบ tools

```
What time is it?              # ทดสอบ terminal tool
Search for: AI news 2026      # ทดสอบ web search
```

---

## แก้ไขปัญหา

### ❌ "hermes: command not found"

**Windows:**
```powershell
# เปิด PowerShell ใหม่
# หรือ
$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
```

**macOS/Linux:**
```bash
source ~/.bashrc   # หรือ source ~/.zshrc
```

### ❌ "401 Invalid API key"

```bash
# ตรวจสอบ .env
cat ~/.hermes/.env | grep OKMD
# ต้องมี: OKMD_API_KEY=sk_...
```

ถ้า key ผิด → ไป generate ใหม่ที่ https://playground.okmd.or.th

### ❌ "SSL certificate error"

```bash
# เพิ่มใน ~/.hermes/.env
echo "NODE_TLS_REJECT_UNAUTHORIZED=0" >> ~/.hermes/.env

# Restart
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

### ❌ Quota หมด

OKMD ให้ 200K tokens/day ถ้าหมดต้องรอ reset วันถัดไป

เช็ค quota:

```bash
hermes insights
```

---

## คำสั่งที่ใช้บ่อย

```bash
# เริ่ม chat
hermes

# ดู/เปลี่ยน model
hermes model

# เช็คสุขภาพ
hermes doctor

# เปิด Dashboard
hermes dashboard

# เริ่ม Telegram Gateway
hermes gateway start

# หยุด Gateway
hermes gateway stop

# ดู sessions
hermes sessions list

# ดู usage
hermes insights
```

---

## แหล่งข้อมูลเพิ่มเติม

- 📖 [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- 🎮 [OKMD AI Playground](https://playground.okmd.or.th)
- 📊 [OKMD API Documentation](https://playground.okmd.or.th/docs/api)
- 💻 [GitHub Repository](https://github.com/pbseiya/hermes-free-model-guide)

---

**สร้างโดย:** Hermes Agent Training Team  
**อัพเดทล่าสุด:** 2026-07-27
