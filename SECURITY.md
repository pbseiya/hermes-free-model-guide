# 🔒 Security Policy

## ห้าม Commit Credentials

**ห้าม** อัปโหลดข้อมูลต่อไปนี้ขึ้น Git repository เด็ดขาด:

| ❌ ห้าม | ตัวอย่าง |
|---------|----------|
| API Keys | `sk-or-v1-...`, `AIza...`, `gsk_...` |
| Telegram Bot Tokens | `123456789:ABCdef...` |
| Passwords | ทุกรูปแบบ |
| Private Keys | `*.pem`, `*.key` |
| `.env` files | มี secrets |
| OAuth Tokens | `gho_...`, `glpat-...` |

## ✅ สิ่งที่อนุญาตให้ Commit

| ✅ อนุญาต | ตัวอย่าง |
|-----------|----------|
| Placeholder | `YOUR_API_KEY_HERE` |
| Example configs | `config.example.yaml` |
| Scripts (ไม่มี secrets) | `install.sh`, `setup.ps1` |
| Documentation | `*.md` |

## วิธีป้องกัน

### 1. ใช้ `.gitignore`
`.gitignore` ของ repo นี้บล็อก `.env` อัตโนมัติ

### 2. ใช้ Environment Variables
```bash
# ✅ ดี — อ่านจาก env
export OPENROUTER_API_KEY="sk-or-..."
hermes setup

# ❌ แย่ — hardcode ใน config
# config.yaml
# api_key: "sk-or-..."   <-- อย่าทำแบบนี้!
```

### 3. ใช้ Template Files
สร้างไฟล์ `config.example.yaml` ที่มี placeholder แล้วให้ user copy ไปแก้เอง:
```bash
cp config.example.yaml config.yaml
# แก้ config.yaml ด้วย key ของตัวเอง
```

### 4. ตรวจสอบก่อน Commit
```bash
# หา API keys ที่อาจหลุด
git diff --cached | grep -iE '(sk-|AIza|token|password|secret)'
```

## ถ้าเผลอ Commit แล้ว?

1. **ลบ key นั้นทันที** (regenerate ที่ provider)
2. **ลบไฟล์จาก Git history:**
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch .env' \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (ถ้า repo อยู่บน GitHub)
4. **สร้าง key ใหม่**

## Contact

พบปัญหา security → แจ้ง instructor หรือเปิด issue (ไม่ต้องใส่ secret!)
