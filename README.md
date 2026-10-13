# 🔫 Model 2 + DemulShooter Launcher (ESC to exit)

![AutoHotkey v2](https://img.shields.io/badge/AutoHotkey-v2.0-334455?logo=autohotkey&logoColor=white)
![Windows](https://img.shields.io/badge/platform-Windows-0078D6?logo=windows&logoColor=white)
![Attract-Mode](https://img.shields.io/badge/frontend-Attract--Mode-8A2BE2)
![Sega Model 2](https://img.shields.io/badge/Sega-Model%202-1E90FF)

An AutoHotkey v2 launcher that starts a **Sega Model 2** game together with **DemulShooter** (for lightgun support) straight from **Attract-Mode** — and shuts **everything** down cleanly with a single press of **ESC**.

Built for arcade cabinets: no lingering tray icons, no orphan processes, no being stuck on the desktop. You press ESC, you're back in your frontend.

---

## ✨ Features

- 🎯 **One-shot launch** — starts DemulShooter (hidden, no GUI) and the Model 2 emulator with the selected ROM.
- ⎋ **ESC = clean exit** — closes the emulator gracefully with `Alt+F4` so it can restore your screen resolution.
- 🧹 **No tray ghosts** — DemulShooter is closed via `taskkill` so its tray icon disappears properly.
- 🛟 **Safety net** — any process still hanging after 2 seconds is force-closed.
- 🔙 **Back to the frontend** — focus is returned to the Attract-Mode window automatically.
- 📁 **Relative paths** — no hard-coded drive letters; move your whole arcade folder anywhere.

---

## ✅ Requirements

- **Windows**
- **[AutoHotkey v2.0](https://www.autohotkey.com/)** or later (or compile the script to an `.exe`)
- **Sega Model 2 Emulator** (`emulator_multicpu.exe`)
- **[DemulShooter](https://github.com/argonlefou/DemulShooter)**
- **[Attract-Mode](https://attractmode.org/)** (any frontend that passes the ROM name as an argument works)

---

## 📁 Folder layout

The script uses paths **relative to its own location**, so it expects this structure:

```
Arcade\
├── emulators\
│   └── model2\
│       ├── emulator_multicpu.exe
│       └── model2-DS-launcher-esc-key.ahk   ← put the script here
└── frontends\
    ├── attractmode\
    └── demulshooter\
        └── DemulShooter.exe
```

Different layout? Edit the paths at the top of the script:

```autohotkey
emuPath := A_ScriptDir
emuExe  := "emulator_multicpu.exe"
dsPath  := A_ScriptDir . "\..\..\frontends\demulshooter"
dsExe   := "DemulShooter.exe"
```

---

## 🚀 Setup in Attract-Mode

Create (or edit) your Model 2 emulator entry so it runs the script and passes the ROM name.

**Running the `.ahk` with AutoHotkey:**

```
executable    C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe
args          "C:\Arcade\emulators\model2\model2-DS-launcher-esc-key.ahk" [name]
```

**Or, compiled to an `.exe` with Ahk2Exe:**

```
executable    C:\Arcade\emulators\model2\model2-DS-launcher-esc-key.exe
args          [name]
```

`[name]` is the ROM short name (e.g. `hotd`, `vcop2`), which is passed both to the emulator and to DemulShooter as `-rom=`.

You can also test it manually from a terminal:

```bat
AutoHotkey64.exe model2-DS-launcher-esc-key.ahk vcop2
```

---

## ⚙️ How it works

```
Attract-Mode ──[rom name]──▶ launcher
                               ├─▶ DemulShooter.exe -target=model2 -rom=<rom> -no_gui   (hidden)
                               └─▶ emulator_multicpu.exe <rom>

ESC pressed ──▶ Alt+F4 to emulator (waits up to 2 s)
            ──▶ taskkill DemulShooter (clean tray)
            ──▶ force-close anything left
            ──▶ focus back to Attract-Mode (SFML_Window)
            ──▶ launcher exits
```

If the script is started without a ROM argument, it exits immediately and does nothing.

---

## 📝 Notes

- While a game is running, **ESC is captured by the launcher** and does not reach the emulator — it's reserved as the "exit to frontend" key.
- `#SingleInstance Force` makes sure only one launcher is ever running, even if the frontend fires it twice.
- Focus is returned to any window of class `SFML_Window`, which is what Attract-Mode uses. For another frontend, change that line to match its window.

---

## 🔗 See also

- [crt-arcade-change-resolution](https://github.com/monster-javi/crt-arcade-change-resolution) — one-click resolution switchers for 15 kHz CRT setups, from the same cabinet.
