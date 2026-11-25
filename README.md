# PentAGI روی GitHub Codespaces

این ریپو [PentAGI](https://github.com/vxcontrol/pentagi) را داخل GitHub Codespaces اجرا می‌کند، بدون اینکه روی سیستم خودتان چیزی نصب کنید.

## قدم ۱: ذخیرهٔ کلید API (فقط یک بار)

۱. به **Settings → Codespaces** حساب گیت‌هاب بروید: https://github.com/settings/codespaces
۲. در بخش **Codespaces secrets** روی **New secret** بزنید.
۳. اسم را یکی از این‌ها بگذارید و کلیدتان را در Value بچسبانید:
   - `OPEN_AI_KEY` برای OpenAI
   - `ANTHROPIC_API_KEY` برای Anthropic
   - `GEMINI_API_KEY` برای Google Gemini
   - `DEEPSEEK_API_KEY` برای DeepSeek
۴. در **Repository access** ریپوی `safe` را انتخاب کنید و ذخیره کنید.

> کلید را هیچ‌وقت داخل فایل‌های ریپو commit نکنید.

## قدم ۲: ساختن Codespace

در صفحهٔ همین ریپو روی **Code → Codespaces → Create codespace on main** بزنید، یا این لینک را باز کنید:

https://codespaces.new/KaroHosseinPour/safe

ماشین ۴ هسته‌ای (۱۶ گیگ رم) به‌طور خودکار انتخاب می‌شود. بار اول چند دقیقه طول می‌کشد تا ایمیج‌ها دانلود شوند.

## قدم ۳: باز کردن پنل

۱. پایین صفحه تب **Ports** را باز کنید.
۲. روی پورت **8443** گزینهٔ **Open in Browser** (آیکون کره) را بزنید.
۳. وارد شوید:
   - ایمیل: `admin@pentagi.com`
   - رمز: `admin`
۴. **همان اول رمز را عوض کنید.**

## دستورهای مفید (در ترمینال Codespace)

```bash
cd pentagi && docker compose ps        # وضعیت سرویس‌ها
cd pentagi && docker compose logs -f pentagi   # دیدن لاگ‌ها
cd pentagi && docker compose down      # خاموش کردن
bash scripts/start.sh                  # روشن کردن دوباره
```

اگر بعد از ساختن Codespace کلید اضافه کردید یا عوض کردید، Codespace را یک بار Stop و دوباره Start کنید و بعد بزنید:

```bash
bash scripts/setup.sh && bash scripts/start.sh
```

## نکته‌ها

- **سهمیه رایگان:** حدود ۳۰ ساعت در ماه با ماشین ۴ هسته‌ای. بعد از کار، Codespace را از https://github.com/codespaces متوقف (**Stop**) کنید.
- **فضا:** ایمیج‌های PentAGI حجیم‌اند؛ ۱۵ گیگ فضای رایگان ممکن است پر شود. Codespace‌های بلااستفاده را پاک کنید.
- **قانون:** فقط روی سیستم‌هایی تست کنید که مالکشان هستید یا مجوز کتبی تست دارید. اسکن سیستم‌های دیگران خلاف قانون و خلاف قوانین گیت‌هاب است و می‌تواند باعث بسته شدن حساب شود.
