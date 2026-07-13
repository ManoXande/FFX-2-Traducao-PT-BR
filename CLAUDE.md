# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not a software project with a build pipeline** — it is the packaged, ready-to-install
distribution of an unofficial PT-BR (Brazilian Portuguese) fan translation of **FINAL FANTASY X-2
HD Remaster** (Steam version). There is no source-to-build step here: the files under
`arquivos-do-jogo/` are the final artifacts a user copies directly into their game installation.
There are no build/lint/test commands because there is nothing to compile or execute in this repo.

Read `LEIA-ME.txt` first — it is the actual user-facing README (in Portuguese) and is the
authoritative source for install/uninstall steps, what is/isn't translated, and troubleshooting.
Don't duplicate or contradict it; update it when install behavior changes.

## Why this works technically

FFX-2 HD Remaster has an integrity check on `FFX2_Data.vbf`: editing that archive directly makes
the launcher refuse to start ("Broken game data"). This translation avoids that entirely by using
a third-party file-loading mod instead of touching the protected archive:

- **External File Loader** by ffgriever (Nexus Mods #150) — a `dinput8.dll` proxy hook
  (`arquivos-do-jogo/dinput8.dll`, `hook.ini`, `simpleLog.dll`) that loads a small module,
  `modules/ff10-file-loader.dll`, configured via `modules/config/ff10-file-loader.ini`.
- That module redirects the game's file reads: any file under `data/mods/` (configured via the
  `[Paths] mods=data/mods` key in `ff10-file-loader.ini`) is served instead of the equivalent file
  inside the original VBF archive, with **no modification to any original game file**.

This means every file under `arquivos-do-jogo/` other than `data/mods/**` is third-party loader
infrastructure (do not "fix" or restructure it — treat it as vendored/binary and change only when
intentionally upgrading the loader itself), and everything under `data/mods/` is this project's
actual translated content.

## Layout of the translated content (`arquivos-do-jogo/data/mods/`)

Two mod roots correspond to the two data layers the Remaster is built from:

- **`ffx-2_data/gamedata/ps3data/`** — Remaster-specific (PS3-derived) overlay assets:
  - `lockit/ffx2_loc_kit_ps3_us.bin` — the localization kit: system/UI strings (autosave,
    save/load, settings screens, etc.). Git shows this as a text diff, but it is an
    **encoded/obfuscated binary format**, not plain editable text — don't hand-edit it expecting
    normal text diffs to be meaningful.
  - `menu_us/base_ftc/d3d11/*.dds.phyre` — Phyre-engine texture assets for the corrected font
    (adds real ã/õ glyph support in dialogue; boot/config screens still fall back to ä/ö per
    `LEIA-ME.txt`).
- **`ffx_ps2/ffx2/master/new_uspc/`** — original PS2-engine game data files (reused as-is by the
  Remaster), organized by subsystem:
  - `battle/btl/<scene-id>/<scene-id>.bin` — ~600 per-battle-scene files (battle dialogue/popups).
  - `battle/kernel/*.bin` — kernel tables: items, abilities, monsters, jobs, commands, menu/battle
    text, etc. (binary structured data, not line-based text).
  - `event/obj_ps3/<2-letter-location-code>/` — 47 folders (one per in-game location code) holding
    ~530 event/dialogue `.bin` files in total.
  - `lastmiss/kernel/lm_*.bin` — equivalent kernel tables for the "Last Mission" DLC.

All `.bin` files in `data/mods/` are binary/encoded game data produced by translation tooling that
lives **outside this repository** (not present here) — there is no script or pipeline in this repo
to regenerate them from source strings. Treat them as opaque build artifacts: replace whole files
when re-exporting updated translations rather than attempting in-place binary edits.

## Working in this repo

- Changes are almost always: (a) editing `LEIA-ME.txt`, or (b) replacing one or more `.bin`/`.phyre`
  files under `data/mods/` with newly exported versions from the external translation tooling.
- Preserve the exact relative path structure under `data/mods/` — the loader matches game file
  paths 1:1, so a translated file in the wrong subfolder silently fails to load (game shows English
  for that file, no error).
- Do not add files anywhere in `arquivos-do-jogo/` other than under `data/mods/` unless the intent
  is specifically to change loader configuration/behavior (`hook.ini`,
  `modules/config/ff10-file-loader.ini`) or upgrade the loader DLLs themselves.
- Version/date the package by updating the "Versão do pacote" line at the end of `LEIA-ME.txt`.

## Windows installer (Inno Setup 6)

Windows users install via a compiled setup executable; Steam Deck / Linux (Proton) still
follow the manual steps in `LEIA-ME.txt`.

- **`instalador/instalador.iss`** — Inno Setup 6 script (source of truth for game-folder
  detection via Steam registry/libraries, file copy from `arquivos-do-jogo/`, and registered
  Windows uninstall).
- **`scripts/build-instalador.ps1`** — build command: `.\scripts\build-instalador.ps1`
  (requires [Inno Setup 6](https://jrsoftware.org/isdl.php) installed). Output:
  `instalador/saida/FFX2-Traducao-PTBR-Setup.exe`.
- The generated `.exe` under `instalador/saida/` is **not** committed (`instalador/saida/` is in
  `.gitignore`). When installer logic or packaged files change, rebuild and distribute the setup
  separately from git.
