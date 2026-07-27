# 📊 Slides — ดูใน Browser หรือ Render เป็น PDF

## ดู Slides

### เปิดใน Browser (ง่ายที่สุด)

```bash
# ต้องมี Node.js
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

---

## เนื้อหา Slides

| Module | หัวข้อ | หน้าที่ |
|--------|--------|----------|
| 1 | ติดตั้ง Hermes + Free Model | 1-3 |
| 2 | ติดตั้ง Hermes Agent | 4-6 |
| 3 | สมัคร OKMD API Key | 7-8 |
| 4 | ตั้งค่า Hermes + OKMD | 9-12 |
| 5 | สร้าง Telegram Bot | 13-14 |
| 6 | ทดสอบใช้งาน + Troubleshooting | 15-20 |

---

## ต้องการติดตั้ง Marp CLI

```bash
npm install -g @marp-team/marp-cli
```
