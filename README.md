# kitalev's Repo

![Platform](https://img.shields.io/badge/platform-iOS%206%2B-lightgrey)
![Type](https://img.shields.io/badge/type-Cydia%2FSileo%20repo-blue)
![Hosting](https://img.shields.io/badge/hosting-GitHub%20Pages-orange)

**English** · [Русский](README.ru.md)

---

My personal Cydia/Sileo package repository for iOS 6+. Currently hosts [GitHub Legacy](https://github.com/kitalev/GitHub-Legacy), a lightweight native GitHub client for old iOS versions.

**Repo URL:** `https://kitalev.github.io/repo/`

## Add to Cydia/Sileo

1. Open Cydia/Sileo → **Manage → Sources → Edit → Add**.
2. Paste: `https://kitalev.github.io/repo/`
3. Done — installed packages will show up in **Changes/Upgrade** automatically.

Or, from Safari on the device itself, just open the [repo page](https://kitalev.github.io/repo/) and tap **"Добавить в Cydia"**.

## Structure

```
repo/
├── debs/            ← .deb packages
├── generate.sh      ← rebuilds Packages/Release/packages.json from debs/
├── index.html       ← the repo's landing page
├── Release, Packages, Packages.gz, Packages.bz2, packages.json
└── .github/workflows/sync-deb.yml  ← auto-syncs the latest .deb from GitHub-Legacy releases
```

## Keeping it updated

A GitHub Actions workflow (`.github/workflows/sync-deb.yml`) checks [GitHub-Legacy's releases](https://github.com/kitalev/GitHub-Legacy/releases) once a day and on manual trigger, pulls the latest `.deb`, and rebuilds the package index automatically — no manual steps needed for that package.

To add any other `.deb` by hand:

```bash
cp your-package.deb debs/
bash generate.sh
git add .
git commit -m "Add your-package"
git push
```

## Requirements

- Device must be jailbroken to use Cydia/Sileo at all.
- Packages must be built for `iphoneos-arm` (32-bit) to run on iOS 6.
