# คู่มือสร้างและตั้งค่า Telegram Bot

คู่มือนี้สอนวิธีสร้าง Telegram Bot และเชื่อมต่อกับ Hermes Agent เพื่อใช้งานผ่าน Telegram

---

## สร้าง Telegram Bot

### ขั้นตอนที่ 1: สร้าง Bot กับ BotFather

1. เปิด Telegram → ค้นหา `@BotFather`
2. ส่งคำสั่ง: `/newbot`
3. ตั้งชื่อ bot: **"My Hermes Bot"** (ชื่อที่แสดง)
4. ตั้ง username: `my_hermes_bot` (ต้องลงท้ายด้วย `bot`)
5. BotFather จะส่ง **Bot Token** กลับมา

<div class="highlight">

**Bot Token ตัวอย่าง:**
```
1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ
```

📋 **Copy เก็บไว้!** จะใช้ตอนตั้งค่า Gateway

**เก็บ Token ไว้ให้ดี!** ห้ามแชร์ให้ใคร

</div>

---

### ขั้นตอนที่ 2: หา Telegram Chat ID

Chat ID ใช้สำหรับอนุญาตให้เฉพาะคุณที่คุยกับ Bot ได้ (ป้องกันคนอื่นใช้ Bot ของคุณ)

1. เปิด Telegram → ค้นหา `@userinfobot`
2. ส่งคำสั่ง: `/start`
3. Bot จะตอบกลับด้วย Chat ID ของคุณ (เป็นตัวเลข เช่น `123456789`)
4. **Copy Chat ID นั้น**

<div class="info">

**Chat ID ใช้สำหรับ:**
- อนุญาตให้เฉพาะคุณที่คุยกับ Bot ได้
- ป้องกันคนอื่นใช้ Bot ของคุณ

**ถ้าไม่ใส่ Chat ID:** Bot จะเปิดให้ทุกคนใช้ได้ (ไม่แนะนำ)

</div>

---

## ตั้งค่า Telegram ใน Hermes

### วิธีที่ 1: ใช้ Installation Script (แนะนำ)

Installation script จะถาม Bot Token และ Chat ID ตอนติดตั้ง:

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -File install-windows.ps1
```

**Linux/macOS:**
```bash
./install-linux.sh
```

### วิธีที่ 2: ใช้ `hermes gateway setup`

```bash
hermes gateway setup
```

เลือก:
- Platform: **Telegram**
- Bot Token: วาง token ที่ได้จาก BotFather
- Chat ID: วาง Chat ID ที่ได้จาก @userinfobot

### วิธีที่ 3: แก้ `.env` โดยตรง

```bash
hermes env edit
```

เพิ่ม:

```bash
# ~/.hermes/.env
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ
TELEGRAM_ALLOWED_USERS=123456789
```

---

## เริ่ม Telegram Gateway

```bash
hermes gateway start
```

### ตรวจสอบสถานะ

```bash
hermes gateway status
```

### หยุด Gateway

```bash
hermes gateway stop
```

### Restart Gateway

```bash
hermes gateway restart
```

---

## ทดสอบ Telegram Bot

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

# ทดสอบ tools
What time is it?   # ทดสอบ terminal tool
Search for: AI news 2026  # ทดสอบ web search
```

---

## Auto-start หลัง Reboot

Installation script จะตั้งค่า auto-start ให้อัตโนมัติ

### Windows

ใช้ **Task Scheduler** หรือ **Startup Folder**:

```powershell
# ตรวจสอบ task
schtasks /Query /TN "HermesGateway"

# เริ่ม task
schtasks /Run /TN "HermesGateway"
```

### Linux (systemd)

```bash
# ตรวจสอบสถานะ
systemctl --user status hermes-gateway

# เริ่ม service
systemctl --user start hermes-gateway

# enable auto-start
systemctl --user enable hermes-gateway
```

### macOS (launchd)

```bash
# ตรวจสอบสถานะ
launchctl list | grep hermes

# load service
launchctl load ~/Library/LaunchAgents/com.hermes.gateway.plist
```

---

## Troubleshooting

### ปัญหา: Bot ไม่ตอบ

```bash
# เช็ค gateway status
hermes gateway status

# ถ้าไม่ทำงาน
hermes gateway restart

# เช็ค log
tail ~/.hermes/logs/gateway.log
```

### ปัญหา: "Unauthorized"

- ตรวจสอบ Bot Token ใน `.env`
- Bot Token อาจผิด → ไปขอใหม่จาก @BotFather

### ปัญหา: "User not allowed"

- ตรวจสอบ Chat ID ใน `.env`
- Chat ID ต้องเป็นตัวเลข (ไม่ใช่ username)
- ถ้าไม่ใส่ Chat ID → Bot จะเปิดให้ทุกคนใช้

### ปัญหา: Gateway crash

```bash
# เช็ค log
tail -f ~/.hermes/logs/gateway.log

# restart
hermes gateway restart

# ถ้ายัง crash → uninstall และ install ใหม่
```

---

## Security Best Practices

1. **เก็บ Bot Token ไว้เป็นความลับ**
   - ห้าม commit ขึ้น GitHub
   - ห้ามแชร์ใน chat หรือ forum

2. **ใช้ Chat ID**
   - จำกัดให้เฉพาะคุณที่ใช้ Bot
   - ป้องกันคนอื่นใช้ Bot ของคุณ

3. **ตรวจสอบ logs เป็นประจำ**
   - ดูว่ามีใครใช้ Bot บ้าง
   - ดูว่ามี error อะไรบ้าง

4. **Restart Gateway เป็นระยะ**
   - ป้องกัน memory leak
   - อัพเดท configuration

---

## Links

- Telegram BotFather: https://t.me/BotFather
- Telegram UserInfoBot: https://t.me/userinfobot
- Hermes Gateway Docs: https://hermes-agent.nousresearch.com/docs/user-guide/messaging/
