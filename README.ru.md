# kitalev's Repo

![Platform](https://img.shields.io/badge/platform-iOS%206%2B-lightgrey)
![Type](https://img.shields.io/badge/type-Cydia%2FSileo%20repo-blue)
![Hosting](https://img.shields.io/badge/hosting-GitHub%20Pages-orange)

[English](README.md) · **Русский**

---

Мой личный Cydia/Sileo-репозиторий для iOS 6+. Сейчас в нём лежит [GitHub Legacy](https://github.com/kitalev/GitHub-Legacy) — лёгкий нативный клиент GitHub для старых версий iOS.

**Адрес репозитория:** `https://kitalev.github.io/repo/`

## Добавление в Cydia/Sileo

1. Откройте Cydia/Sileo → **Управление → Источники → Изменить → Добавить**.
2. Вставьте: `https://kitalev.github.io/repo/`
3. Готово — установленные пакеты появятся в **Изменения/Обновления** автоматически.

Либо прямо с устройства: откройте [страницу репозитория](https://kitalev.github.io/repo/) в Safari и нажмите **«Добавить в Cydia»**.

## Структура

```
repo/
├── debs/            ← .deb пакеты
├── generate.sh      ← пересобирает Packages/Release/packages.json из debs/
├── index.html       ← страница репозитория
├── Release, Packages, Packages.gz, Packages.bz2, packages.json
└── .github/workflows/sync-deb.yml  ← автосинхронизация .deb из релизов GitHub-Legacy
```

## Как поддерживается актуальность

GitHub Actions workflow (`.github/workflows/sync-deb.yml`) раз в сутки и по ручному запуску проверяет [релизы GitHub-Legacy](https://github.com/kitalev/GitHub-Legacy/releases), забирает последний `.deb` и пересобирает индекс пакетов автоматически — для этого пакета ничего руками делать не нужно.

Чтобы добавить любой другой `.deb` вручную:

```bash
cp ваш-пакет.deb debs/
bash generate.sh
git add .
git commit -m "Add ваш-пакет"
git push
```

## Требования

- Устройство должно быть джейлбрейкнуто, чтобы вообще пользоваться Cydia/Sileo.
- Пакеты должны быть собраны под `iphoneos-arm` (32-бит) для работы на iOS 6.
