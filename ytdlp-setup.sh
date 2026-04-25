#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "== Termux yt-dlp setup starting =="

# ----------------------------------
# 1. Storage
# ----------------------------------
echo "Setting up storage (allow permission if prompted)..."

if [ ! -d "$HOME/storage" ]; then
  echo "Storage not set up. Please grant permission."

  termux-setup-storage
  MAX_RETRIES=60
  COUNT=0

  while [ ! -d "$HOME/storage" ]; do
    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
      echo "Storage permission not granted. Exiting."
      exit 1
    fi

    echo "Waiting for storage permission... ($COUNT/$MAX_RETRIES)"
    sleep 2
    COUNT=$((COUNT + 1))
  done

  echo "Storage access granted."
fi
# ----------------------------------
# 2. Update & upgrade
# ----------------------------------
echo "Updating packages..."
pkg update -y && pkg upgrade -y

# ----------------------------------
# 3. Install dependencies
# ----------------------------------
echo "Installing dependencies..."
pkg install -y python ffmpeg termux-api

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
BASE_DIR="$HOME/downloads/ytdlp/yt-dlp-downs"
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
echo "👉 Share YouTube link playlist→ choose Termux → it downloads as MP3 into:"
echo "$BASE_DIR"
