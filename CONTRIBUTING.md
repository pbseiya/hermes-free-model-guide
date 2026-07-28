# Contributing to Hermes Free Model Guide

ขอบคุณที่สนใจมีส่วนร่วมในโปรเจกต์นี้! 🎉

## 📋 สารบัญ

- [Code of Conduct](#code-of-conduct)
- [วิธี Contribute](#วิธี-contribute)
- [การ Report Bugs](#การ-report-bugs)
- [การ Suggest Features](#การ-suggest-features)
- [Pull Request Process](#pull-request-process)
- [Development Setup](#development-setup)
- [Style Guides](#style-guides)

---

## Code of Conduct

โปรเจกต์นี้ยึดถือ [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) 
กรุณาอ่านและปฏิบัติตามเพื่อให้ชุมชนของเราเป็นมิตรและเปิดกว้างสำหรับทุกคน

---

## วิธี Contribute

### 🐛 การ Report Bugs

ถ้าพบ bug กรุณาเปิด issue โดยระบุ:

1. **คำอธิบายชัดเจน** - เกิดอะไรขึ้น
2. **ขั้นตอนการทำซ้ำ** - ทำอย่างไรจึงจะเจอ bug
3. **ผลลัพธ์ที่คาดหวัง** - ควรจะเป็นอะไร
4. **ผลลัพธ์จริง** - เป็นอะไร
5. **Environment** - OS, Hermes version, etc.

### 💡 การ Suggest Features

ถ้ามีไอเดียสำหรับ feature ใหม่:

1. เปิด issue ชื่อ `[Feature Request] ชื่อ feature`
2. อธิบายว่า feature นี้แก้ปัญหาอะไร
3. อธิบายวิธีทำงานที่คาดหวัง
4. (Optional) เสนอวิธี implement

### 📝 การ Improve Documentation

การแก้ไข documentation เป็นวิธีที่ดีในการเริ่มต้น:

- แก้ไข typo
- เพิ่มคำอธิบายให้ชัดเจน
- เพิ่มตัวอย่าง
- แปลภาษา

---

## Pull Request Process

### 1. Fork และ Clone

```bash
# Fork repo บน GitHub
# Clone มาที่เครื่อง
git clone https://github.com/YOUR_USERNAME/hermes-free-model-guide.git
cd hermes-free-model-guide

# เพิ่ม upstream remote
git remote add upstream https://github.com/pbseiya/hermes-free-model-guide.git
```

### 2. สร้าง Branch

```bash
# อัพเดท main branch
git checkout main
git pull upstream main

# สร้าง branch ใหม่
git checkout -b feature/your-feature-name
# หรือ
git checkout -b fix/your-bug-fix
```

**Branch Naming Convention:**
- `feature/...` - สำหรับ feature ใหม่
- `fix/...` - สำหรับ bug fix
- `docs/...` - สำหรับ documentation
- `refactor/...` - สำหรับ refactoring

### 3. Development

```bash
# ทดสอบ scripts
./scripts/install-linux.sh --dry-run

# Render slides
npx @marp-team/marp-cli slides/slides.md --html

# ตรวจสอบ syntax
shellcheck scripts/install-linux.sh
```

### 4. Commit

```bash
git add .
git commit -m "type: description

- รายละเอียดการเปลี่ยนแปลง
- รายละเอียดการเปลี่ยนแปลง"
```

**Commit Message Format:**
```
type: short description

Longer description if needed

- Bullet points for changes
- More details
```

**Types:**
- `feat:` - feature ใหม่
- `fix:` - bug fix
- `docs:` - documentation
- `style:` - formatting, etc.
- `refactor:` - refactoring
- `test:` - adding tests
- `chore:` - maintenance

### 5. Push และ Create PR

```bash
git push origin your-branch-name
```

จากนั้นสร้าง Pull Request บน GitHub:

1. ไปที่ repo ของคุณ
2. คลิก "Compare & pull request"
3. กรอกข้อมูล:
   - **Title:** สั้นๆ แต่ชัดเจน
   - **Description:** อธิบายการเปลี่ยนแปลง
   - **Related Issues:** อ้างอิง issue ถ้ามี
4. คลิก "Create pull request"

### 6. Review Process

- Maintainer จะ review PR ของคุณ
- อาจมีการขอแก้ไข
- เมื่อ approve แล้ว จะถูก merge เข้า main branch

---

## Development Setup

### Prerequisites

- Git
- Node.js (สำหรับ render slides)
- ShellCheck (สำหรับ lint bash scripts)
- PSScriptAnalyzer (สำหรับ lint PowerShell scripts)

### Setup

```bash
# Clone repo
git clone https://github.com/pbseiya/hermes-free-model-guide.git
cd hermes-free-model-guide

# Install dependencies (สำหรับ slides)
npm install -g @marp-team/marp-cli

# Install shellcheck (Linux)
sudo apt install shellcheck

# Install shellcheck (macOS)
brew install shellcheck
```

---

## Style Guides

### Markdown

- ใช้ 2 spaces สำหรับ indentation
- ใช้ `*` สำหรับ bullet points (ไม่ใช่ `-`)
- ใช้ ` ``` ` สำหรับ code blocks
- ใช้ `**bold**` สำหรับ emphasis
- ใช้ `[text](url)` สำหรับ links

### Bash Scripts

```bash
#!/usr/bin/env bash
# ใช้ shebang

# ใช้ตัวพิมพ์ใหญ่สำหรับ global variables
GLOBAL_VAR="value"

# ใช้ตัวพิมพ์เล็กสำหรับ local variables
local_var="value"

# ใช้ฟังก์ชัน
my_function() {
    local var="$1"
    echo "$var"
}

# Quote variables
echo "$var"

# ใช้ [[ ]] สำหรับ conditions
if [[ "$var" == "value" ]]; then
    echo "match"
fi
```

### PowerShell Scripts

```powershell
# ใช้ PascalCase สำหรับ function names
function Get-UserInfo {
    param(
        [string]$UserName
    )
    
    # ใช้ camelCase สำหรับ variables
    $userInfo = Get-User $UserName
    return $userInfo
}

# ใช้ approved verbs
# Get-, Set-, New-, Remove-, etc.
```

### YAML

```yaml
# ใช้ 2 spaces สำหรับ indentation
model:
  provider: custom:okmd
  default: gpt-5.4-mini

# ใช้ quotes สำหรับ strings ที่มี special characters
providers:
  okmd:
    base_url: "https://gen.ai.kku.ac.th/okmd/api/v1"
```

---

## Testing

### Test Installation Scripts

```bash
# Linux/macOS
./scripts/install-linux.sh --dry-run

# Windows
powershell -ExecutionPolicy Bypass -File scripts/install-windows.ps1 -SkipPrompts
```

### Test Uninstallation Scripts

```bash
# Linux/macOS
./scripts/uninstall-linux.sh --dry-run

# Windows
powershell -ExecutionPolicy Bypass -File scripts/uninstall-windows.ps1 -Force
```

---

## Questions?

ถ้ามีคำถาม:

1. เปิด issue ชื่อ `[Question] คำถามของคุณ`
2. หรือติดต่อ maintainer

---

## Recognition

Contributors จะได้รับการ mention ใน:

- README.md (Contributors section)
- Release notes
- Commit history

ขอบคุณอีกครั้งที่ช่วยทำให้โปรเจกต์นี้ดีขึ้น! 🙏
