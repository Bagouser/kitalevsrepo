#!/usr/bin/env bash
#
# generate.sh — собирает индексные файлы Cydia-репозитория (Packages, Release, packages.json)
# на основе .deb пакетов, лежащих в папке ./debs
#
# Использование:
#   1. Положите .deb файлы в папку debs/
#   2. Запустите: bash generate.sh
#   3. Закоммитьте и запушьте всю папку в GitHub
#
# Адрес репозитория (для страницы index.html и кнопки "Добавить в Cydia")
# определяется автоматически из адреса страницы в браузере — ничего
# прописывать вручную не нужно.

set -euo pipefail

cd "$(dirname "$0")"

DEBS_DIR="debs"
OUT_PACKAGES="Packages"

if [ ! -d "$DEBS_DIR" ]; then
    echo "Папка $DEBS_DIR не найдена. Создайте её и положите туда .deb файлы."
    exit 1
fi

shopt -s nullglob
debs=("$DEBS_DIR"/*.deb)
if [ ${#debs[@]} -eq 0 ]; then
    echo "В папке $DEBS_DIR нет .deb файлов. Индекс будет пустым."
fi

> "$OUT_PACKAGES"

for deb in "${debs[@]}"; do
    echo "Обрабатываю: $deb"

    # control-поля из самого пакета (Package, Version, Architecture, Depends, Name, Description и т.д.)
    control=$(dpkg-deb -f "$deb")

    size=$(stat -c%s "$deb")
    md5=$(md5sum "$deb" | awk '{print $1}')
    sha1=$(sha1sum "$deb" | awk '{print $1}')
    sha256=$(sha256sum "$deb" | awk '{print $1}')
    filename="${DEBS_DIR}/$(basename "$deb")"

    {
        echo "$control"
        echo "Filename: $filename"
        echo "Size: $size"
        echo "MD5sum: $md5"
        echo "SHA1: $sha1"
        echo "SHA256: $sha256"
        echo
    } >> "$OUT_PACKAGES"
done

# Сжатые версии индекса (Cydia поддерживает и то, и другое)
gzip -kf "$OUT_PACKAGES"
bzip2 -kf "$OUT_PACKAGES"

# Release файл с метаданными репозитория
cat > Release <<EOF
Origin: Kitalev's Repo
Label: Kitalev's Repo
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm
Components: main
Description: Мой Cydia-репозиторий для iOS 6
EOF

# packages.json — для страницы index.html (список пакетов, ссылки на скачивание)
python3 - "$OUT_PACKAGES" > packages.json <<'PYEOF'
import sys, json

path = sys.argv[1]
with open(path, encoding="utf-8", errors="replace") as f:
    content = f.read()

stanzas = [s for s in content.split("\n\n") if s.strip()]
packages = []

for stanza in stanzas:
    fields = {}
    last_key = None
    for line in stanza.splitlines():
        if line.startswith((" ", "\t")) and last_key:
            fields[last_key] += "\n" + line.strip()
        elif ":" in line:
            key, _, value = line.partition(":")
            key = key.strip()
            fields[key] = value.strip()
            last_key = key
    if fields:
        packages.append(fields)

print(json.dumps(packages, ensure_ascii=False, indent=2))
PYEOF

echo
echo "Готово. Файлы Packages, Packages.gz, Packages.bz2, Release и packages.json созданы."
echo "Не забудьте прописать реальный REPO_URL внутри этого скрипта, если добавляете новые пакеты."
