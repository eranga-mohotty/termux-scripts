🚀 Quick Setup (Android + Termux)

1. Install Termux

- Download Termux from F-Droid
- Open F-Droid → search for Termux → install
- Launch Termux after installation

---

2. Run Setup Command

Paste this into Termux and press Enter:

```
pkg update -y && pkg install -y curl && curl -fsSL https://raw.githubusercontent.com/eranga-mohotty/termux-scripts/main/ytdlp-setup.sh | bash
```

---

3. Grant Permissions

- When prompted, allow storage access

---

4. Done!

👉 Share a YouTube link → choose Termux → it downloads automatically as MP3

---

💡 Notes

- First run may take a few minutes (installing dependencies)
- Downloads are saved in:
  ~/storage/downloads/ytdlp/yt-dlp-downs
