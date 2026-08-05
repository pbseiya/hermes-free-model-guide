# คู่มือ Post-Install Setup

หลังติดตั้ง Hermes Agent เสร็จแล้ว ต้องตั้งค่าเพิ่มเติมเพื่อให้ใช้งานได้เต็มที่

---

## สารบัญ

1. [ค่าที่ต้องใส่](#ค่าที่ต้องใส่)
2. [ตั้งค่า OKMD API Key](#ตั้งค่า-okmd-api-key)
3. [ตั้งค่า Telegram Bot](#ตั้งค่า-telegram-bot)
4. [ตั้งค่า LiteLLM Proxy (Course 0)](#ตั้งค่า-litellm-proxy-course-0)
5. [ตรวจสอบการติดตั้ง](#ตรวจสอบการติดตั้ง)
6. [เริ่มใช้งาน](#เริ่มใช้งาน)

---

## ค่าที่ต้องใส่

### 🔴 จำเป็น (ต้องใส่)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **OKMD API Key** | [playground.okmd.or.th](https://playground.okmd.or.th) | ใช้เรียก 23 free models |

### 🟡 Optional (ใส่ก็ได้ ไม่ใส่ก็ได้)

| ค่า | ได้จากไหน | ใช้ทำอะไร |
|-----|-----------|-----------|
| **LiteLLM API Key** | Instructor ให้มา (Course 0) | ใช้ LiteLLM Proxy แทน OKMD |
| **Telegram Bot Token** | [@BotFather](https://t.me/BotFather) | คุยกับ Hermes ผ่าน Telegram |
| **Telegram Chat ID** | [@userinfobot](https://t.me/userinfobot) | จำกัดให้เฉพาะคุณใช้ Bot ได้ |

---

## ตั้งค่า OKMD API Key

### ขั้นตอนที่ 1: สมัครสมาชิก

1. เข้า 👉 https://playground.okmd.or.th
2. Login ด้วย Google Account
3. ไปที่ **Settings → API Platform**
4. กด **"Generate API Key"**
5. Copy key ที่ได้ (ขึ้นต้นด้วย `sk_...`)

### ขั้นตอนที่ 2: ใส่ API Key

**วิธีที่ 1: ใช้ hermes setup (แนะนำ)**

```bash
hermes setup
```

เลือก:
1. **Provider** → Custom endpoint
2. **Base URL** → `https://gen.ai.kku.ac.th/okmd/api/v1`
3. **API Key** → วาง OKMD key
4. **Model** → `deepseek-v3.2` (หรือ model อื่น)

**วิธีที่ 2: แก้ไฟล์ .env โดยตรง**

```bash
# เปิดไฟล์ .env
nano ~/.hermes/.env

# เพิ่มบรรทัดนี้
OKMD_API_KEY=sk_YOUR_KEY_HERE
```

**วิธีที่ 3: ใช้คำสั่ง**

```bash
hermes config set providers.okmd.api_key sk_YOUR_KEY_HERE
```

### ขั้นตอนที่ 3: ตรวจสอบ

```bash
# ทดสอบว่า API Key ใช้งานได้
hermes chat

# พิมพ์อะไรก็ได้
You: สวัสดี
```

---

## ตั้งค่า Telegram Bot

### ขั้นตอนที่ 1: สร้าง Bot

1. เปิด Telegram → ค้นหา `@BotFather`
2. ส่งคำสั่ง: `/newbot`
3. ตั้งชื่อ bot: **"My AI Assistant"**
4. ตั้ง username: `my_ai_hermes_bot` (ต้องลงท้ายด้วย `bot`)
5. BotFather จะส่ง **Bot Token** กลับมา (เก็บไว้!)

### ขั้นตอนที่ 2: หา Chat ID

1. เปิด Telegram → ค้นหา `@userinfobot`
2. ส่ง `/start`
3. Copy เลข ID ที่ได้ (เช่น `123456789`)

### ขั้นตอนที่ 3: ตั้งค่าใน Hermes

**วิธีที่ 1: ใช้ hermes gateway setup**

```bash
hermes gateway setup
```

เลือก Telegram → วาง Bot Token และ Chat ID

**วิธีที่ 2: แก้ไฟล์ .env โดยตรง**

```bash
nano ~/.hermes/.env

# เพิ่มบรรทัดเหล่านี้
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHI...
TELEGRAM_ALLOWED_USERS=123456789
```

### ขั้นตอนที่ 4: เริ่ม Gateway

```bash
# เริ่ม gateway
hermes gateway start

# ตรวจสอบสถานะ
hermes gateway status
```

### ขั้นตอนที่ 5: ทดสอบ

1. เปิด Telegram → หา bot ที่สร้าง
2. ส่ง: `/start`
3. ส่ง: `สวัสดี`
4. ถ้า Hermes ตอบกลับ = **สำเร็จ!** 🎉

---

## ตั้งค่า LiteLLM Proxy (Course 0)

ถ้าได้รับ API Key จาก instructor สำหรับ LiteLLM Proxy:

### ขั้นตอนที่ 1: ใส่ API Key

```bash
nano ~/.hermes/.env

# เพิ่มบรรทัดนี้
LITELLM_API_KEY=your_litellm_key_here
```

### ขั้นตอนที่ 2: เปลี่ยน Provider

```bash
hermes config set model.provider custom:litellm
hermes config set model.default qwen3.7-plus
```

### ขั้นตอนที่ 3: ตรวจสอบ

```bash
hermes chat

# พิมพ์อะไรก็ได้
You: สวัสดี
```

### สลับระหว่าง OKMD และ LiteLLM

```bash
# สลับไปใช้ OKMD
hermes config set model.provider custom:okmd

# สลับไปใช้ LiteLLM
hermes config set model.provider custom:litellm
```

---

## ตรวจสอบการติดตั้ง

### ใช้ hermes doctor

```bash
hermes doctor
```

คำสั่งนี้จะตรวจสอบ:
- ✅ การติดตั้ง Hermes
- ✅ การตั้งค่า config.yaml
- ✅ การตั้งค่า .env
- ✅ การเชื่อมต่อกับ API
- ✅ Services ที่ทำงานอยู่

### ตรวจสอบ Services

```bash
# Linux (systemd)
systemctl --user status hermes-gateway
systemctl --user status hermes-dashboard

# macOS (launchd)
launchctl list | grep hermes

# Windows (Task Scheduler)
Get-ScheduledTask | Where-Object TaskName -like "Hermes*"
```

### ตรวจสอบ Logs

```bash
# Linux/macOS
tail -f ~/.hermes/logs/gateway.log
tail -f ~/.hermes/logs/dashboard.log

# Windows
Get-Content "$env:LOCALAPPDATA\hermes\logs\gateway.log" -Wait
```

---

## เริ่มใช้งาน

### คำสั่งพื้นฐาน

```bash
# เริ่ม chat ใน terminal
hermes

# เปิด Desktop App
hermes desktop

# เปิด Web Dashboard
hermes dashboard
# เปิด browser ที่ http://localhost:9119

# เริ่ม Telegram Gateway
hermes gateway start

# หยุด Telegram Gateway
hermes gateway stop
```

### คำสั่งที่มีประโยชน์

```bash
# ดู/เปลี่ยน model
hermes model

# ดู sessions
hermes sessions list

# ดู usage
hermes insights

# รีเซ็ต session
hermes --new
```

### เข้าถึงจากเครื่องอื่น

Dashboard และ Gateway ถูกตั้งค่าให้เข้าถึงจากเครื่องอื่นได้ในวง LAN:

```bash
# Dashboard
http://YOUR_IP:9119

# ตัวอย่าง
http://192.168.1.100:9119
```

**หมายเหตุ:** ต้องเปิด firewall port 9119

```bash
# Linux (ufw)
sudo ufw allow 9119/tcp

# macOS
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add ~/.hermes/hermes-agent/venv/bin/python
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp ~/.hermes/hermes-agent/venv/bin/python
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

## แหล่งข้อมูลเพิ่มเติม

- 📖 [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs/)
- 🎮 [OKMD AI Playground](https://playground.okmd.or.th)
- 💻 [GitHub Repository](https://github.com/pbseiya/hermes-free-model-guide)

---

**สร้างโดย:** Hermes Agent Training Team  
**อัพเดทล่าสุด:** 2026-08-06
