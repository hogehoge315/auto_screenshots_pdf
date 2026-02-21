browser_app_name="Chrome"
key="key code 124" # 右矢印キー
page=587
ptslp=0.1
npslp=0.2

# 指定範囲を取得

getX() {
    /usr/libexec/PlistBuddy -c "print :last-selection:X" ~/Library/Preferences/com.apple.screencapture.plist
}
getY() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Y" ~/Library/Preferences/com.apple.screencapture.plist
}
getW() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Width" ~/Library/Preferences/com.apple.screencapture.plist
}
getH() {
    /usr/libexec/PlistBuddy -c "print :last-selection:Height" ~/Library/Preferences/com.apple.screencapture.plist
}

x=`getX`
y=`getY`
w=`getW`
h=`getH`

# スクリーンショットを撮影

mkdir -p .photos
cd .photos

pad_width=${#page}

for ((i=1; i<=page; i++)); do
    file_name=$(printf "%0*d.png" "$pad_width" "$i")
    screencapture -R $x,$y,$w,$h -x "$file_name" -t png
    sleep $ptslp
    osascript -e 'tell application "'$browser_app_name'" to activate' -e 'tell application "System Events" to key code 124'
    sleep $npslp
done

# PNGをPDFに変換

for png in *.png; do
    sips -s format pdf "$png" --out "${png%.png}.pdf" 1>/dev/null 2>/dev/null
done

# PDFを結合

pdfunite *.pdf ../output.pdf

# PNGファイルを削除

cd ../

rm -rf .photos