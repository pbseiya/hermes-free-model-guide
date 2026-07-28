# 📊 Slides — ดูใน Browser หรือ Render เป็น PDF

## 📁 ไฟล์ Slides

| ไฟล์ | คำอธิบาย | กลุ่มเป้าหมาย |
|------|----------|---------------|
| `slides.md` | Slides หลัก 6 Modules | ผู้เรียน |
| `instructor-guide.md` | คู่มือผู้สอน (timing, demo scripts, Q&A) | ผู้สอน |
| `quick-reference.md` | Quick Reference Card (คำสั่งสำคัญ, troubleshooting) | ผู้เรียน |

---

## 🎓 Slides หลัก (slides.md)

### ดูใน Browser (ง่ายที่สุด)

```bash
npx @marp-team/marp-cli slides.md --html -o slides.html
# เปิด slides.html ใน browser
```

### Render เป็น PDF

```bash
npx @marp-team/marp-cli slides.md --pdf --allow-local-files
```

### Render เป็น PPTX (PowerPoint)

```bash
npx @marp-team/marp-cli slides.md --pptx
```

### Preview แบบ Live

```bash
npx @marp-team/marp-cli slides.md -s
# เปิด browser ที่ http://localhost:8080
```

### เนื้อหา Slides

| Module | หัวข้อ | หน้าที่ |
|--------|--------|----------|
| 1 | ติดตั้ง Hermes + Free Model | 1-3 |
| 2 | ติดตั้ง Hermes Agent | 4-6 |
| 3 | สมัคร OKMD API Key | 7-8 |
| 4 | ตั้งค่า Hermes + OKMD | 9-12 |
| 5 | สร้าง Telegram Bot | 13-14 |
| 6 | ทดสอบใช้งาน + Troubleshooting | 15-20 |

---

## 🎯 Instructor Guide (instructor-guide.md)

คู่มือสำหรับผู้สอน มี timing, demo scripts, Q&A prompts, troubleshooting tips

### ดูใน Browser

```bash
npx @marp-team/marp-cli instructor-guide.md --html -o instructor-guide.html
```

### Render เป็น PDF

```bash
npx @marp-team/marp-cli instructor-guide.md --pdf --allow-local-files
```

### เนื้อหา

- Course Overview (90-120 นาที)
- Module-by-module teaching guide
- Demo scripts สำหรับแต่ละ module
- Q&A prompts และ engagement techniques
- Troubleshooting cheat sheet
- Assessment checklist
- Post-class follow-up actions

---

## 📋 Quick Reference Card (quick-reference.md)

สรุปคำสั่งสำคัญ, ไฟล์สำคัญ, troubleshooting สำหรับผู้เรียน

### ดูใน Browser

```bash
npx @marp-team/marp-cli quick-reference.md --html -o quick-reference.html
```

### Render เป็น PDF (พิมพ์แจกผู้เรียน)

```bash
npx @marp-team/marp-cli quick-reference.md --pdf --allow-local-files
```

### เนื้อหา

- Installation commands (Windows, Linux, macOS)
- Important Hermes commands
- OKMD free models list
- File locations (config, .env, sessions)
- Troubleshooting table
- Uninstall commands

---

## 📦 ติดตั้ง Marp CLI

```bash
npm install -g @marp-team/marp-cli
```

หรือใช้ผ่าน npx (ไม่ต้องติดตั้ง):

```bash
npx @marp-team/marp-cli <file> --html
```

---

## 💡 Tips

- **HTML** — เปิดใน browser ได้เลย เหมาะสำหรับ preview
- **PDF** — พิมพ์แจกผู้เรียน เหมาะสำหรับ quick reference
- **PPTX** — แก้ไขใน PowerPoint/Google Slides ได้
- **Live preview** — แก้ไขแบบ real-time เหมาะสำหรับตอนทำ slides
