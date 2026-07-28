---
marp: true
theme: default
paginate: true
header: "🎓 Instructor Guide: Teaching Hermes + Free Model"
footer: "Course 0 — Total Duration: 90-120 minutes"
style: |
  section {
    font-family: 'Sarabun', 'TH Sarabun New', sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
  }
  h1 { color: #fbbf24; font-size: 2.5em; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
  h2 { color: #fcd34d; font-size: 1.8em; }
  .timing { 
    background: rgba(255,255,255,0.2); 
    padding: 12px; 
    border-radius: 8px; 
    margin: 10px 0;
    border-left: 4px solid #fbbf24;
  }
  .demo-script {
    background: rgba(0,0,0,0.3);
    padding: 16px;
    border-radius: 8px;
    font-family: 'Courier New', monospace;
    font-size: 0.9em;
    margin: 12px 0;
  }
  .qa-prompt {
    background: rgba(16, 185, 129, 0.3);
    padding: 12px;
    border-radius: 8px;
    border-left: 4px solid #10b981;
    margin: 10px 0;
  }
  code {
    background: rgba(0,0,0,0.4);
    padding: 2px 6px;
    border-radius: 4px;
    color: #fbbf24;
  }
---

# 🎓 Instructor Guide
## Teaching Hermes Agent + Free Model (Course 0)

<div class="timing">

**⏱️ Total Duration:** 90-120 minutes  
**👥 Target Audience:** Beginners (no programming experience)  
**🎯 Goal:** Students can install Hermes and use it via Telegram by the end

</div>

---

# 📋 Course Overview

## 6 Modules Structure

| Module | Topic | Duration | Key Activity |
|--------|-------|----------|--------------|
| **1** | Introduction | 10 min | Show demo, motivate |
| **2** | Installation | 20 min | Hands-on install |
| **3** | OKMD API Key | 10 min | Sign up together |
| **4** | Configuration | 20 min | Config + test |
| **5** | Telegram Bot | 20 min | Create bot + connect |
| **6** | Usage & Tips | 20 min | Practice + Q&A |

<div class="timing">

**💡 Tip:** Adjust timing based on class size. For 20+ students, add 10-15 min buffer.

</div>

---

# 🎯 Module 1: Introduction (10 min)

## Goals
- Motivate students
- Show what's possible
- Set expectations

<div class="demo-script">

**DEMO SCRIPT:**

1. Open Telegram on your phone
2. Send message to your Hermes bot: "สวัสดี ช่วยสรุปข่าววันนี้ให้หน่อย"
3. Show the response
4. Say: "วันนี้คุณจะสร้าง bot แบบนี้ได้เอง"

</div>

<div class="qa-prompt">

**Q&A Prompt:**
- "ใครเคยใช้ ChatGPT บ้าง?" (raise hands)
- "ใครอยากมี AI ส่วนตัวที่จำทุกอย่างได้?" (raise hands)
- "วันนี้จะทำให้ฟรี!"

</div>

---

# 🚀 Module 2: Installation (20 min)

## Goals
- Everyone has Hermes installed
- Verify installation works

<div class="demo-script">

**DEMO SCRIPT:**

**Windows:**
```powershell
# Show the one-liner on screen
$f="$env:TEMP\hermes-install.ps1"; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-windows.ps1' -OutFile $f -UseBasicParsing; powershell -ExecutionPolicy Bypass -File $f; Remove-Item $f
```

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/pbseiya/hermes-free-model-guide/main/scripts/install-linux.sh | bash
```

Walk around and help students who get stuck.

</div>

<div class="qa-prompt">

**Common Issues:**
- "PowerShell ไม่ยอมรัน" → Check Execution Policy
- "curl: command not found" → Use PowerShell instead
- "Permission denied" → Check if running as admin (shouldn't need to)

**Verification Command:**
```bash
hermes --version
```

</div>

---

# 🔑 Module 3: OKMD API Key (10 min)

## Goals
- Everyone has OKMD account
- Everyone has API key

<div class="demo-script">

**DEMO SCRIPT:**

1. Open https://playground.okmd.or.th
2. Show sign-up process (use TK Park membership)
3. Navigate to API Keys section
4. Generate new API key
5. Copy key (show where to save it temporarily)

**Say:** "เก็บ key นี้ไว้ดีๆ ห้ามให้ใครเห็น เหมือนรหัสผ่านธนาคาร"

</div>

<div class="qa-prompt">

**Q&A Prompt:**
- "ใครมีบัญชี TK Park แล้วบ้าง?" (if yes, skip sign-up)
- "ใครไม่มี TK Park?" → Show how to register (free)

**Common Issues:**
- "สมัคร TK Park ไม่ผ่าน" → Help individually
- "หา API Keys ไม่เจอ" → Show screenshot in slides
- "Copy key ไม่ได้" → Show manual copy method

</div>

---

# 🔧 Module 4: Configuration (20 min)

## Goals
- Hermes connected to OKMD
- Can chat with AI

<div class="demo-script">

**DEMO SCRIPT:**

**Interactive Setup:**
```bash
hermes setup
```

Walk through each prompt:
1. Model provider → Choose "custom"
2. API endpoint → `https://api.okmd.org/v1`
3. API key → Paste from Module 3
4. Model → `gpt-4o-mini`
5. Telegram → Skip for now

**Test:**
```bash
hermes chat
```

Type: "สวัสดี"

</div>

<div class="qa-prompt">

**Common Issues:**
- "hermes setup ไม่เจอ" → Restart terminal
- "API key ไม่ถูกต้อง" → Check if copied correctly
- "Connection failed" → Check internet, firewall
- "SSL error" → Add `NODE_TLS_REJECT_UNAUTHORIZED=0` to `.env`

**Verification:**
- Can chat with AI ✓
- AI responds in Thai ✓
- Can ask follow-up questions ✓

</div>

---

# 📱 Module 5: Telegram Bot (20 min)

## Goals
- Everyone has Telegram bot
- Bot connected to Hermes
- Can chat via Telegram

<div class="demo-script">

**DEMO SCRIPT:**

**Step 1: Create Bot**
1. Open Telegram, search @BotFather
2. Send `/newbot`
3. Choose name: "My AI Assistant"
4. Choose username: `my_ai_assistant_bot`
5. Copy the token

**Step 2: Configure Hermes**
```bash
hermes config set telegram.token YOUR_BOT_TOKEN
```

**Step 3: Get Chat ID**
1. Message your bot
2. Visit: `https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates`
3. Find `"chat":{"id":123456789}`
4. Copy the ID

**Step 4: Set Chat ID**
```bash
hermes config set telegram.chat_id YOUR_CHAT_ID
```

**Step 5: Start Gateway**
```bash
hermes gateway telegram start
```

</div>

<div class="qa-prompt">

**Common Issues:**
- "BotFather ไม่ตอบ" → Check internet
- "username ถูกใช้แล้ว" → Try different name
- "หา chat ID ไม่เจอ" → Show getUpdates method
- "hermes gateway ไม่ทำงาน" → Check token, chat_id

**Verification:**
- Send message to bot on phone
- Get response from Hermes
- Can have conversation ✓

</div>

---

# 💡 Module 6: Usage & Tips (20 min)

## Goals
- Students know how to use Hermes effectively
- Know where to get help
- Can customize further

<div class="demo-script">

**DEMO SCRIPT:**

**Show useful commands:**
```bash
# List all commands
hermes help

# Check status
hermes status

# View memory
hermes memory list

# Change model
hermes model set openai:gpt-4o

# Update Hermes
hermes update
```

**Demo use cases:**
1. "สรุปข่าววันนี้ให้หน่อย"
2. "ช่วยเขียนอีเมลหาลูกค้า"
3. "อธิบายควอนตัมคอมพิวติ้งแบบง่ายๆ"
4. "ช่วยวางแผนเที่ยวเชียงใหม่ 3 วัน"

</div>

<div class="qa-prompt">

**Q&A Session (10 min):**

Common questions:
- "ใช้แล้วเสียเงินไหม?" → ไม่ ถ้าใช้ OKMD/LiteLLM
- "ใช้ model อื่นได้ไหม?" → ได้ เปลี่ยนด้วย `hermes model set`
- "ข้อมูลส่วนตัวปลอดภัยไหม?" → เก็บในเครื่อง ไม่ส่งไปไหน
- "อัพเดทอย่างไร?" → `hermes update`
- "ลบออกอย่างไร?" → `hermes uninstall`

**Resources:**
- GitHub: https://github.com/pbseiya/hermes-free-model-guide
- Docs: https://hermes-agent.nousresearch.com/docs/
- OKMD: https://playground.okmd.or.th

</div>

---

# 🎯 Teaching Tips

## Before Class

<div class="demo-script">

**PREPARATION CHECKLIST:**

- [ ] Test installation on Windows, Linux, macOS
- [ ] Have OKMD API key ready (for demo)
- [ ] Have Telegram bot ready (for demo)
- [ ] Prepare backup USB with install scripts
- [ ] Check internet connection (venue WiFi)
- [ ] Print QR code for GitHub repo
- [ ] Prepare troubleshooting cheat sheet

</div>

## During Class

<div class="qa-prompt">

**ENGAGEMENT TECHNIQUES:**

1. **Show, don't tell** — Demo first, explain later
2. **Walk around** — Don't stay at front, help students directly
3. **Pair programming** — Pair advanced students with beginners
4. **Checkpoint quizzes** — "ใครทำสำเร็จแล้ว ยกมือ!"
5. **Celebrate wins** — "เยี่ยมมาก! ทำสำเร็จแล้ว!"

</div>

---

# 🚨 Troubleshooting Cheat Sheet

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| `hermes: command not found` | Restart terminal, check PATH |
| Permission denied (Linux) | Don't use sudo, check file permissions |
| SSL certificate error | Add `NODE_TLS_REJECT_UNAUTHORIZED=0` to `.env` |
| API key invalid | Re-copy key, check for spaces |
| Telegram bot not responding | Check token, chat_id, restart gateway |
| Installation stuck | Ctrl+C, try again, check internet |
| PowerShell execution policy | Run: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned` |

<div class="timing">

**💡 Pro Tip:** Keep a "Troubleshooting Station" at the back of the room for complex issues.

</div>

---

# 📊 Assessment Checklist

## What Students Should Achieve

<div class="qa-prompt">

**BY END OF CLASS, EVERY STUDENT SHOULD:**

- [ ] Have Hermes installed and working
- [ ] Have OKMD API key configured
- [ ] Be able to chat with AI via terminal
- [ ] Have Telegram bot connected
- [ ] Be able to chat with AI via Telegram
- [ ] Know how to change models
- [ ] Know where to get help (GitHub, docs)

**FOLLOW-UP (1 week later):**
- Send email survey
- Ask: "ยังใช้งาน Hermes อยู่ไหม?"
- Collect feedback for improvement

</div>

---

# 🎓 Advanced Topics (Optional)

## If Class Finishes Early

<div class="demo-script">

**BONUS ACTIVITIES:**

1. **Memory Management**
   ```bash
   hermes memory add "ชอบกาแฟดำ"
   hermes memory list
   ```

2. **Skills Installation**
   ```bash
   hermes skills install weather
   hermes skills install news
   ```

3. **Multiple Models**
   ```bash
   hermes model set anthropic:claude-3-opus
   hermes model set google:gemini-pro
   ```

4. **Custom Commands**
   - Show how to create aliases
   - Show how to automate tasks

</div>

---

# 📝 Post-Class Actions

## Follow-up Checklist

<div class="qa-prompt">

**WITHIN 24 HOURS:**

- [ ] Send thank you email to students
- [ ] Share GitHub repo link
- [ ] Share OKMD sign-up link (for those who didn't finish)
- [ ] Share troubleshooting guide
- [ ] Ask for feedback (Google Form)

**WITHIN 1 WEEK:**

- [ ] Send survey: "ใช้งาน Hermes บ่อยแค่ไหน?"
- [ ] Collect success stories
- [ ] Identify common issues for next class
- [ ] Update slides based on feedback

**WITHIN 1 MONTH:**

- [ ] Analyze survey results
- [ ] Plan next class (advanced topics?)
- [ ] Build community (Telegram group?)
- [ ] Celebrate successes! 🎉

</div>

---

# 🎉 You're Ready to Teach!

## Final Checklist

<div class="success">

**BEFORE YOU START:**

✅ You've tested the installation  
✅ You have a working demo bot  
✅ You know common troubleshooting steps  
✅ You have backup plans (USB, offline scripts)  
✅ You're excited to share this with others!  

**REMEMBER:**

- Be patient with beginners
- Celebrate small wins
- It's okay if not everyone finishes
- Focus on fun and empowerment
- You've got this! 💪

</div>

---

# 📞 Support

## Need Help?

<div class="info">

**RESOURCES:**

- **GitHub Issues:** https://github.com/pbseiya/hermes-free-model-guide/issues
- **Hermes Docs:** https://hermes-agent.nousresearch.com/docs/
- **OKMD Support:** support@okmd.or.th
- **Telegram Community:** [Link to be added]

**INSTRUCTOR COMMUNITY:**

Join our instructor Telegram group for:
- Share teaching experiences
- Get help with tricky issues
- Access to updated materials
- Network with other instructors

[QR Code / Link to be added]

</div>

---

# 🙏 Thank You!

## You're Making AI Accessible to Everyone!

<div class="success">

**IMPACT:**

By teaching this course, you're:
- Democratizing AI access
- Empowering people with technology
- Building a community of AI users
- Making the world a better place 🌍

**KEEP IN TOUCH:**

- Share your teaching stories
- Submit improvements to the repo
- Join the instructor community
- Let's build the future together! 🚀

</div>

**Good luck with your class! 🎓✨**
