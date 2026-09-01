import urllib.request
from PIL import Image, ImageDraw, ImageFont
import os

# Create QR Code matrix programmatically or via Google Chart API / QR Server API
qr_url = "https://api.qrserver.com/v1/create-qr-code/?size=400x400&data=https://dinsos.bojonegorokab.go.id/&margin=1"
output_path = r"d:\SEMESTER 5\superapp_bojonegoro\assets\images\qr_ppid_dinsos.png"

try:
    req = urllib.request.Request(qr_url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req) as response:
        with open("scratch/raw_qr.png", "wb") as f:
            f.write(response.read())
    print("Downloaded raw QR")
    qr_img = Image.open("scratch/raw_qr.png").convert("RGBA")
except Exception as e:
    print("Fallback local draw:", e)
    qr_img = Image.new("RGBA", (400, 400), (255, 255, 255, 255))

# Create the full composite card matching user screenshot:
# Black outer rounded frame around QR, and black "DOWNLOAD APLIKASI" button below
width, height = 500, 600
card = Image.new("RGBA", (width, height), (255, 255, 255, 255))
draw = ImageDraw.Draw(card)

# Draw QR code resized into frame
qr_resized = qr_img.resize((400, 400))
card.paste(qr_resized, (50, 40))

# Draw black rounded border around QR
draw.rounded_rectangle([40, 30, 460, 450], radius=16, outline=(0, 0, 0, 255), width=8)

# Draw black "DOWNLOAD APLIKASI" button at bottom
btn_rect = [40, 475, 460, 555]
draw.rounded_rectangle(btn_rect, radius=16, fill=(0, 0, 0, 255))

# Draw Text "DOWNLOAD APLIKASI" inside button
# Try system font or default
try:
    font = ImageFont.truetype("arial.ttf", 26)
except:
    font = ImageFont.load_default()

text = "DOWNLOAD APLIKASI"
# Use textbbox if available
try:
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
except:
    tw, th = 240, 30

tx = (width - tw) // 2
ty = btn_rect[1] + (80 - th) // 2 - 2
draw.text((tx, ty), text, fill=(255, 255, 255, 255), font=font)

os.makedirs(os.path.dirname(output_path), exist_ok=True)
card.save(output_path, "PNG")
print(f"Successfully generated QR image at {output_path}")
