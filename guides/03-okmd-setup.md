# คู่มือสมัครและตั้งค่า OKMD AI Playground

OKMD AI Playground เป็นบริการ AI ฟรีจากภาครัฐไทย ให้ใช้ 23 models ด้วย quota สูงสุด 1M tokens/day

---

## สมัคร OKMD AI Playground

### ขั้นตอนการสมัคร

1. เข้า 👉 https://playground.okmd.or.th
2. Login ด้วย Google Account (หรือสมัครสมาชิก TK Park ฟรี)
3. ไปที่ **Settings → API Platform**
4. กด **"Generate API Key"**
5. **Copy key** ที่ได้ (ขึ้นต้นด้วย `sk_...`)

<div class="warning">

**เก็บ API Key ไว้ให้ดี!**
- ห้ามแชร์ให้ใคร
- ห้าม upload ขึ้น GitHub
- ถ้าทำหาย → ไป generate ใหม่ได้ที่เดิม

</div>

---

## Quota และ Models

### Quota รวมตาม Provider (ข้อมูลจริง Jul 2026)

| Provider | Quota รวม/วัน | Models ใน Provider |
|----------|--------------|---------------------|
| **Deepseek** | **1,000,000** | `deepseek-v4-pro`, `deepseek-v4-flash` |
| **OpenAI** | 350,000 | `gpt-5.4`, `gpt-5.4-mini`, `gpt-5.4-nano` |
| **Gemini** | 200,000 | `gemini-3.5-flash`, `gemini-3.1-flash-lite`, `gemini-2.5-flash-lite` + อื่นๆ |
| **Meta AI** | 200,000 | `llama-4-maverick`, `llama-4-scout` |
| **Nova (AWS)** | 200,000 | `nova-pro-v1`, `nova-2-lite-v1` |
| **Claude** | 180,000 | `claude-sonnet-5`, `claude-sonnet-4.6` |
| **xAI** | 100,000 | `grok-4.3` |
| **Perplexity** | 100,000 | `sonar-pro` |
| **Qwen** | 100,000 | `qwen3.7-plus`, `qwen3.7-max`, `qwen3.6-flash` |
| **Mistral** | 100,000 | `mistral-medium-3.1` |

### ⚠️ ข้อควรระวังเรื่อง Quota

- **Quota share กันทั้ง Provider** — ใช้ `gpt-5.4` ไป 100K → `gpt-5.4-mini` เหลือแค่ 250K
- **ใช้ chat ที่ web playground.okmd.or.th ก็หัก quota ด้วย**
- เช็ค quota: ดูที่ **Usage** ใน OKMD Playground หรือ `hermes insights`

---

## ตั้งค่า OKMD ใน Hermes

### วิธีที่ 1: ใช้ Installation Script (แนะนำ)

Installation script จะถาม OKMD API Key ตอนติดตั้ง:

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -File install-windows.ps1
```

**Linux/macOS:**
```bash
./install-linux.sh
```

### วิธีที่ 2: ใช้ `hermes model`

```bash
hermes model
```

เลือก:
- Provider: **Custom endpoint**
- Base URL: `https://gen.ai.kku.ac.th/okmd/api/v1`
- API Key: `sk_...`
- Model: `gpt-5.4-mini` (แนะนำ)

### วิธีที่ 3: แก้ config.yaml โดยตรง

```bash
hermes config edit
```

เพิ่ม:

```yaml
# ~/.hermes/config.yaml
model:
  provider: custom:okmd
  default: gpt-5.4-mini

custom_providers:
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
```

ตั้ง API Key:

```bash
hermes env set OKMD_API_KEY sk_your_key_here
```

---

## ปัญหา SSL Certificate

OKMD ใช้ self-signed certificate ซึ่ง Node.js จะปฏิเสธการเชื่อมต่อ

### วิธีแก้

เพิ่มใน `~/.hermes/.env`:

```bash
NODE_TLS_REJECT_UNAUTHORIZED=0
```

Installation script จะเพิ่มให้อัตโนมัติ

---

## ทดสอบ OKMD

### ทดสอบด้วย curl

```bash
curl -sk https://gen.ai.kku.ac.th/okmd/api/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OKMD_API_KEY" \
  -d '{
    "model": "gpt-5.4-mini",
    "messages": [{"role": "user", "content": "สวัสดี"}]
  }'
```

### ทดสอบด้วย Hermes

```bash
hermes

# พิมพ์อะไรก็ได้
> สวัสดี
```

---

## Models ที่แนะนำ

| Model | Quota/วัน | จุดเด่น |
|-------|-----------|---------|
| `deepseek-v4-flash` | 1M | **Quota เยอะสุด!** |
| `gpt-5.4-mini` | 350K | สมดุลดี ฉลาด+เร็ว |
| `llama-4-maverick` | 200K | Opensource, ฉลาด |
| `claude-sonnet-5` | 180K | งานซับซ้อน, เขียนโค้ด |

---

## เปลี่ยน Model

```bash
# เปลี่ยน model ใน session
/model deepseek-v4-flash
/model gpt-5.4-mini
/model claude-sonnet-5

# เปลี่ยน model ถาวร
hermes config set model.default deepseek-v4-flash
```

---

## Troubleshooting

### ปัญหา: "401 Unauthorized"

- ตรวจสอบ API Key ใน `.env`
- API Key อาจหมดอายุ → ไป generate ใหม่ที่ OKMD Playground

### ปัญหา: "Model not found"

```bash
# ดู models ที่มี
curl -sk https://gen.ai.kku.ac.th/okmd/api/v1/models \
  -H "Authorization: Bearer $OKMD_API_KEY"
```

### ปัญหา: Quota หมด

- เช็ค quota ที่ OKMD Playground
- สลับไปใช้ provider อื่นที่มี quota เยอะกว่า (เช่น DeepSeek 1M)

---

## Links

- OKMD Playground: https://playground.okmd.or.th
- OKMD API Docs: https://playground.okmd.or.th/docs/api
- Hermes Agent Docs: https://hermes-agent.nousresearch.com/docs/
