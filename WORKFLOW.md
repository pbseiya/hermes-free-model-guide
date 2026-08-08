# OKMD Course Materials - Workflow & Status

**อัปเดตล่าสุด:** 2026-08-08  
**สถานะปัจจุบัน:** ✅ เสร็จสมบูรณ์ - พร้อมใช้งาน

---

## 📊 สถานะปัจจุบัน

### ✅ สิ่งที่เสร็จแล้ว

1. **Slides (Markdown → HTML + PDF)**
   - Source: `slides/slides.md`
   - HTML: `slides/slides.html` ✅ (445 KB)
   - PDF: `slides/slides.pdf` ✅ (1,200 KB)
   - รูปภาพ: `images/hermes-evangelion.jpg` ✅ (692 KB)
   - ทั้ง HTML และ PDF ใช้รูปเดียวกันแล้ว ✅

2. **Google Drive**
   - Folder: "OKMD 23 AI Models - Course Materials"
   - Folder ID: `1mzdk2OAZv1zVCbEdcvJt4KAXClpJo1lL`
   - PDF ID: `1X8aDiBmyKhcMlnN-Hm5lIxhWyWiufKXN`
   - อัปโหลดเวอร์ชันล่าสุดแล้ว ✅

3. **GitHub**
   - Repository: `pbseiya/hermes-free-model-guide`
   - Branch: `main` (ไม่ใช่ master!)
   - GitHub Pages: https://pbseiya.github.io/hermes-free-model-guide/slides/slides.html
   - Push เวอร์ชันล่าสุดแล้ว ✅

4. **Email Template**
   - Template: `pre_training_reminder_1day.html`
   - Template ID: `1o9Qr8SXLP7_9WzSFTQJQWrWxZLgmkFT4`
   - ลิงก์ดาวน์โหลด PDF: ✅ ใช้ Google Drive
   - ลิงก์ดูออนไลน์: ✅ ใช้ GitHub Pages
   - อัปเดตบน Google Drive แล้ว ✅
   - ทดสอบส่งอีเมลแล้ว ✅

---

## 📁 โครงสร้างไฟล์

```
/home/seiya/projects/hermes-free-model-guide/
├── WORKFLOW.md                    ← ไฟล์นี้ (สถานะและขั้นตอน)
├── slides/
│   ├── slides.md                  ← Source หลัก (Marp Markdown)
│   ├── slides.html                ← Export สำหรับดูออนไลน์
│   └── slides.pdf                 ← Export สำหรับดาวน์โหลด
└── images/
    └── hermes-evangelion.jpg      ← รูป avatar (692 KB)

/home/seiya/projects/training_course/private-course/
├── templates/
│   ├── registration_confirmation.html
│   ├── pre_training_reminder_1day.html  ← มีลิงก์สไลด์
│   ├── pre_training_reminder_1hr.html
│   └── post_training_video_survey.html
└── database/
    └── contacts.db                ← ข้อมูลผู้เรียน
```

---

## 🔗 ลิงก์สำคัญ

### สำหรับผู้เรียน

- **ดูสไลด์ออนไลน์:** https://pbseiya.github.io/hermes-free-model-guide/slides/slides.html
- ดาวน์โหลด: `https://drive.google.com/uc?id=12sisF4K18mlohYuf87ZFX12AkmJxzn2a&export=download`
- ดูออนไลน์: `https://drive.google.com/file/d/12sisF4K18mlohYuf87ZFX12AkmJxzn2a/view`

### สำหรับแก้ไข

- **GitHub Repo:** https://github.com/pbseiya/hermes-free-model-guide
- **Google Drive Folder:** https://drive.google.com/drive/folders/1mzdk2OAZv1zVCbEdcvJt4KAXClpJo1lL

---

## 🎯 File IDs (Google Drive)

| ไฟล์ | ID | คำอธิบาย |
|------|-----|---------|
| OKMD Course Materials (folder) | `1M2415PjoQdZhz87AvX_BuVKT6rrBgmEB` | โฟลเดอร์หลัก |
| slides.pdf | `12sisF4K18mlohYuf87ZFX12AkmJxzn2a` | สไลด์ PDF |
| pre_training_reminder_1day.html | `1o9Qr8SXLP7_9WzSFTQJQWrWxZLgmkFT4` | อีเมลแจ้งเตือนล่วงหน้า 1 วัน |
| registration_confirmation.html | `1tfXi4k3sA3-xVgdxFqnK6h_PaKkGlEEF` | อีเมลยืนยันการลงทะเบียน |
| poster_okmd_23_ai_models.png | `1dUTRx7T64Jvew7dASQCj4jlSmR3DLiUq` | โปสเตอร์ |

---

## 🔄 ขั้นตอนการทำงาน (Workflow)

### เมื่อต้องแก้ไขเนื้อหาสไลด์

#### 1. แก้ไข slides.md

```bash
cd /home/seiya/projects/hermes-free-model-guide
# แก้ไข slides/slides.md ด้วย text editor
```

#### 2. Export HTML และ PDF ใหม่

```bash
cd slides

# Export HTML
npx @marp-team/marp-cli slides.md --html --allow-local-files -o slides.html

# Export PDF
npx @marp-team/marp-cli slides.md --pdf --allow-local-files -o slides.pdf
```

#### 3. ตรวจสอบ PDF

```bash
# แปลง PDF หน้าแรกเป็น PNG เพื่อตรวจสอบ
pdftoppm -png -r 150 -f 1 -l 1 slides.pdf /tmp/pdf_page1

# ใช้ vision_analyze ตรวจสอบภาพ /tmp/pdf_page1-1.png
```

#### 4. Push ขึ้น GitHub

```bash
cd /home/seiya/projects/hermes-free-model-guide

# เพิ่มไฟล์ (ใช้ -f เพราะ .gitignore ignore slides.html และ slides.pdf)
git add -f slides/slides.md slides/slides.html slides/slides.pdf

# Commit
git commit -m "Update slides content"

# Push (ใช้ branch main!)
git push origin main
```

#### 5. อัปโหลด PDF ไป Google Drive

ใช้โค้ด Python ด้านล่าง (ดูส่วน "โค้ดที่ใช้บ่อย")

#### 6. ทดสอบส่งอีเมล

ใช้โค้ด Python ด้านล่าง (ดูส่วน "โค้ดที่ใช้บ่อย")

---

### เมื่อต้องแก้ไข Email Template

#### 1. แก้ไข template ในเครื่อง

```bash
cd /home/seiya/projects/training_course/private-course
# แก้ไข templates/pre_training_reminder_1day.html
```

#### 2. อัปเดต template บน Google Drive

ใช้โค้ด Python ด้านล่าง (ดูส่วน "โค้ดที่ใช้บ่อย")

#### 3. ทดสอบส่งอีเมล

ใช้โค้ด Python ด้านล่าง (ดูส่วน "โค้ดที่ใช้บ่อย")

---

## 💻 โค้ดที่ใช้บ่อย

### อัปโหลด PDF ไป Google Drive

```python
import json
from pathlib import Path
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# โหลด credentials
token_path = Path('/home/seiya/projects/gog/tokens/pbseiyacpro7/token.json')
with open(token_path) as f:
    token_data = json.load(f)

creds = Credentials(
    token=token_data['token'],
    refresh_token=token_data['refresh_token'],
    token_uri=token_data['token_uri'],
    client_id=token_data['client_id'],
    client_secret=token_data['client_secret']
)

drive_service = build('drive', 'v3', credentials=creds)

# อัปโหลด/อัปเดต PDF
file_id = '1X8aDiBmyKhcMlnN-Hm5lIxhWyWiufKXN'
pdf_path = Path('/home/seiya/projects/hermes-free-model-guide/slides/slides.pdf')

media = MediaFileUpload(str(pdf_path), mimetype='application/pdf', resumable=True)
updated_file = drive_service.files().update(
    fileId=file_id,
    media_body=media,
    fields='id, name, size, modifiedTime'
).execute()

print(f"✅ อัปโหลดสำเร็จ: {updated_file['name']} ({int(updated_file['size']) / 1024:.1f} KB)")
print(f"   แก้ไขล่าสุด: {updated_file['modifiedTime']}")
```

### อัปโหลด Template ไป Google Drive

```python
import json
from pathlib import Path
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# โหลด credentials
token_path = Path('/home/seiya/projects/gog/tokens/pbseiyacpro7/token.json')
with open(token_path) as f:
    token_data = json.load(f)

creds = Credentials(
    token=token_data['token'],
    refresh_token=token_data['refresh_token'],
    token_uri=token_data['token_uri'],
    client_id=token_data['client_id'],
    client_secret=token_data['client_secret']
)

drive_service = build('drive', 'v3', credentials=creds)

# อัปโหลด/อัปเดต template
file_id = '1o9Qr8SXLP7_9WzSFTQJQWrWxZLgmkFT4'  # pre_training_reminder_1day.html
template_path = Path('/home/seiya/projects/training_course/private-course/templates/pre_training_reminder_1day.html')

media = MediaFileUpload(str(template_path), mimetype='text/html')
updated_file = drive_service.files().update(
    fileId=file_id,
    media_body=media,
    fields='id, name, modifiedTime'
).execute()

print(f"✅ อัปโหลด template สำเร็จ")
print(f"   แก้ไขล่าสุด: {updated_file['modifiedTime']}")
```

### ทดสอบส่งอีเมล

```python
import json
import base64
from pathlib import Path
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

# โหลด credentials
token_path = Path('/home/seiya/projects/gog/tokens/pbseiyacpro7/token.json')
with open(token_path) as f:
    token_data = json.load(f)

creds = Credentials(
    token=token_data['token'],
    refresh_token=token_data['refresh_token'],
    token_uri=token_data['token_uri'],
    client_id=token_data['client_id'],
    client_secret=token_data['client_secret']
)

gmail_service = build('gmail', 'v1', credentials=creds)

# อ่าน template
template_path = Path('/home/seiya/projects/training_course/private-course/templates/pre_training_reminder_1day.html')
html_content = template_path.read_text(encoding='utf-8')

# แทนที่ตัวแปร
replacements = {
    '{name}': 'ทดสอบ',
    '{course_name}': 'ปลดล็อกพลัง OKMD 23 AI Models บน Hermes Agent',
    '{date}': 'วันพุธที่ 12 สิงหาคม 2569',
    '{time}': '20:00 - 21:00 น.',
    '{location}': 'LIVE Online (ออนไลน์)',
    '{course_benefits}': '<li>✅ เข้าถึง 23 AI Models ระดับโลกฟรี</li>',
    '{facebook_url}': 'https://www.facebook.com/groups/1073944701804346',
    '{facebook_group_name}': 'Ai Agents for Manufacturing & Industry',
    '{line_id}': 'seiyahotty',
    '{line_url}': 'https://line.me/ti/p/4SrqJlFU3Y'
}

for key, value in replacements.items():
    html_content = html_content.replace(key, value)

# สร้างอีเมล
message = MIMEMultipart('related')
message['to'] = 'pbseiyacpro7@gmail.com'
message['from'] = 'ทีมงานอบรม Ai Agents for Manufacturing & Industry <pbseiyacpro7@gmail.com>'
message['subject'] = '📋 เอกสารประกอบการอบรม (ทดสอบ)'

# แนบ HTML
html_part = MIMEText(html_content, 'html', 'utf-8')
message.attach(html_part)

# แนบ LINE QR Code
line_qr_path = Path('/home/seiya/projects/antigravity-training/line-qr-code.jpg')
if line_qr_path.exists():
    with open(line_qr_path, 'rb') as f:
        img_data = f.read()
    img = MIMEImage(img_data, _subtype='jpeg')
    img.add_header('Content-ID', '<lineqr>')
    img.add_header('Content-Disposition', 'inline', filename='line-qr-code.jpg')
    message.attach(img)

# ส่งอีเมล
raw = base64.urlsafe_b64encode(message.as_bytes()).decode('utf-8')
result = gmail_service.users().messages().send(userId='me', body={'raw': raw}).execute()

print(f"✅ ส่งอีเมลสำเร็จ: {result['id']}")
```

---

## ⚠️ ปัญหาที่พบบ่อยและการแก้ไข

### 1. รูปไม่แสดงใน PDF

**สาเหตุ:** ไฟล์รูปไม่มีอยู่ใน `images/` (local หรือ GitHub)

**วิธีแก้:**
```bash
# ตรวจสอบว่าไฟล์มีอยู่ใน git ไหม
git ls-files | grep hermes-evangelion

# ถ้าไม่มี ให้ดาวน์โหลดจาก GitHub Pages
curl -L -o images/hermes-evangelion.jpg https://pbseiya.github.io/hermes-free-model-guide/images/hermes-evangelion.jpg

# เพิ่มและ push
git add images/hermes-evangelion.jpg
git commit -m "Add missing image"
git push origin main
```

### 2. HTML กับ PDF ใช้รูปไม่เหมือนกัน

**สาเหตุ:** GitHub Pages cache เวอร์ชันเก่า หรือ local กับ remote ไม่ตรงกัน

**วิธีแก้:**
1. Export ทั้ง HTML และ PDF จาก source เดียวกัน
2. Push ขึ้น GitHub
3. รอ 1-2 นาทีให้ GitHub Pages rebuild
4. ตรวจสอบด้วย `curl -I` ว่าไฟล์อัปเดตแล้ว

### 3. Branch ผิด

**สาเหตุ:** ใช้ `master` แทนที่จะเป็น `main`

**วิธีแก้:**
```bash
# ตรวจสอบ branch ปัจจุบัน
git branch --show-current

# ถ้าเป็น master ให้เปลี่ยนเป็น main
git checkout main
git push origin main
```

### 4. Header ทับเนื้อหาใน PDF

**สาเหตุ:** มี `header:` ใน Marp config

**วิธีแก้:**
```bash
# ลบ header ออกจาก slides.md
sed -i '/^header:/d' slides/slides.md

# Export ใหม่
npx @marp-team/marp-cli slides.md --pdf --allow-local-files -o slides.pdf
```

### 5. Google Drive ยังเป็น PDF เก่า

**สาเหตุ:** ไม่ได้ อัปโหลด PDF ใหม่ หรืออัปโหลดผิด file_id

**วิธีแก้:**
1. ใช้โค้ด Python อัปโหลด PDF ใหม่ (ดูด้านบน)
2. ตรวจสอบ `modifiedTime` ว่าอัปเดตแล้ว
3. ตรวจสอบขนาดไฟล์ว่าตรงกับ local

### 6. Vision API มีปัญหา (502/500)

**สาเหตุ:** API overload หรือ network issue

**วิธีแก้:**
```python
# แปลงภาพเป็น base64 ก่อนใช้ vision_analyze
import base64
from pathlib import Path

img_path = Path('image.png')
with open(img_path, 'rb') as f:
    img_data = f.read()
    b64_data = base64.b64encode(img_data).decode()

data_uri = f"data:image/png;base64,{b64_data}"
# ใช้ data_uri กับ vision_analyze
```

---

## 📝 Checklist สำหรับงานใหม่

### เมื่อเริ่มคอร์สใหม่

- [ ] สร้างโฟลเดอร์ใหม่ใน Google Drive
- [ ] อัปเดต File IDs ในไฟล์นี้
- [ ] แก้ไข `slides.md` (เนื้อหา/วันที่/หัวข้อ)
- [ ] Export HTML และ PDF ใหม่
- [ ] ตรวจสอบ PDF ด้วย vision_analyze
- [ ] Push ขึ้น GitHub branch `main`
- [ ] อัปโหลด PDF ไป Google Drive
- [ ] อัปเดตลิงก์ใน email template
- [ ] อัปเดต template บน Google Drive
- [ ] ทดสอบส่งอีเมล
- [ ] ตรวจสอบลิงก์ทั้งสอง (ดาวน์โหลด + ดูออนไลน์)

### ก่อนส่งอีเมลจริง

- [ ] ตรวจสอบว่า template บน Google Drive เป็นเวอร์ชันล่าสุด
- [ ] ทดสอบส่งอีเมลไปที่ `pbseiyacpro7@gmail.com`
- [ ] ตรวจสอบลิงก์ทั้งหมดว่าใช้งานได้
- [ ] ตรวจสอบ LINE QR Code ว่าแนบมาในอีเมล
- [ ] ตรวจสอบ bounce emails หลังส่ง

---

## 📚 ข้อมูลเพิ่มเติม

### ผู้ส่งอีเมล
- **ชื่อ:** ทีมงานอบรม Ai Agents for Manufacturing & Industry
- **อีเมล:** pbseiyacpro7@gmail.com

### ข้อมูลติดต่อวิทยากร
- **LINE ID:** seiyahotty
- **LINE URL:** https://line.me/ti/p/4SrqJlFU3Y
- **LINE QR:** `/home/seiya/projects/antigravity-training/line-qr-code.jpg`

### Facebook Group
- **ชื่อ:** Ai Agents for Manufacturing & Industry
- **URL:** https://www.facebook.com/groups/1073944701804346

### OAuth Credentials
- **Token:** `/home/seiya/projects/gog/tokens/pbseiyacpro7/token.json`
- **Client Secret:** `/home/seiya/projects/gog/pbseiyacpro7/client_secret_pbseiyacpro7.json`

---

## 🎯 สรุปสถานะปัจจุบัน

✅ **ทุกอย่างพร้อมใช้งานแล้ว:**
- Slides (HTML + PDF) ใช้รูปเดียวกัน
- Google Drive อัปเดตเวอร์ชันล่าสุด
- GitHub Pages deploy แล้ว
- Email template อัปเดตลิงก์แล้ว
- ทดสอบส่งอีเมลแล้ว

**สามารถใช้งานระบบอัตโนมัติได้ทันที!**

---

**สร้างโดย:** Hermes Agent  
**วันที่:** 2026-08-08  
**เวอร์ชัน:** 1.0  
**สถานะ:** ✅ พร้อมใช้งาน
