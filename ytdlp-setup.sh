#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "== Termux yt-dlp setup starting =="

# ----------------------------------
# 1. Storage (first)
# ----------------------------------
echo "Setting up storage (allow permission if prompted)..."
termux-setup-storage

# ----------------------------------
# 2. Update & upgrade
# ----------------------------------
echo "Updating packages..."
pkg update -y && pkg upgrade -y

# ----------------------------------
# 3. Install dependencies
# ----------------------------------
echo "Installing dependencies..."
pkg install -y python wget ffmpeg termux-api

# ----------------------------------
# 4. Install yt-dlp
# ----------------------------------
echo "Installing yt-dlp..."
pip install --upgrade pip
pip install yt-dlp

# ----------------------------------
# 5. Create download directory
# ----------------------------------
echo "Creating download directories..."
BASE_DIR="/data/data/com.termux/files/home/storage/downloads/ytdlp/yt-dlp-downs"
mkdir -p "$BASE_DIR"

# ----------------------------------
# 6. Create yt-dlp config
# ----------------------------------
echo "Creating yt-dlp config..."
mkdir -p ~/.config/yt-dlp

cat > ~/.config/yt-dlp/config <<EOF
-x
--audio-format mp3
--output $BASE_DIR/"%(playlist)s"/"%(title)s.%(ext)s"
--no-mtime
--download-archive ~/.config/yt-dlp/archive.txt
EOF

# ----------------------------------
# 7. Setup URL opener
# ----------------------------------
echo "Setting up URL opener..."

mkdir -p ~/bin

cat > ~/bin/termux-url-opener <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

url="$1"

if [[ "$url" == *"youtube.com"* || "$url" == *"youtu.be"* ]]; then
    echo "Downloading: $url"
        yt-dlp "$url"
        else
            echo "Not a YouTube URL: $url"
            fi
            EOF

            chmod +x ~/bin/termux-url-opener

            # ----------------------------------
            # Done
            # ----------------------------------
            echo ""
            echo "== Setup complete! =="
            echo "👉 Tap a YouTube link → choose Termux → it downloads as MP3 into:"
            echo "$BASE_DIR"