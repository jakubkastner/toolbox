# 🧰 My Toolbox

A personal collection of automation scripts, fixes, and utilities for my daily workflow.
This repository serves as a central backup for small tools I write to solve specific problems.

## 📂 Structure

Scripts are organized by category/topic:

    toolbox/
    ├── gpx/           # GPS, Maps, GPX manipulation (Locus, Slopes, Strava)
    ├── video/         # Video encoding, DaVinci Resolve helpers, FFmpeg
    ├── system/        # Windows/Linux maintenance, backups, batch scripts
    ├── web/           # Snippets for web, regex patterns, bookmarklets
    └── README.md

## 📜 Script List

### 🗺️ GPX & Mapping
| Script | Language | Description |
| :--- | :--- | :--- |
| [`gpx/fix_gpx_hdop.py`](gpx/fix_gpx_hdop.py) | Python | **Import GPX to Slopes app fix:** Removes decimal precision from `<hdop>` tags. |

### 🎬 Video & Media
| Script | Language | Description |
| :--- | :--- | :--- |
|  |  |  |

### 🖥️ System & Utils
| Script | Language | Description |
| :--- | :--- | :--- |
|  |  |  |

### 🌐 Web
| Script | Language | Description |
| :--- | :--- | :--- |
|  |  |  |

---

## 🚀 Usage

### Requirements
Dependencies depend on the specific script language:

*   **Python Scripts (`.py`):** Require Python 3.x.
    *   Install libs: `pip install -r requirements.txt` (if present in the folder).
*   **PowerShell (`.ps1`):** Native on Windows.
    *   You might need to enable execution: `Set-ExecutionPolicy RemoteSigned`.
*   **Batch (`.bat`/`.cmd`):** Native on Windows.
*   **Bash (`.sh`):** Native on Linux/macOS (or via WSL/Git Bash on Windows).

### Running a script
Navigate to the specific folder and run according to the file type:

    # Python
    python gpx/fix_gpx_hdop.py

    # PowerShell
    .\system\backup.ps1

---

## 📝 Notes
- **Private Use:** These scripts are tailored for my specific environment. Use at your own risk.
- **Maintenance:** I update this repo whenever I create a new reusable tool.
