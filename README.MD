<h1 align="center">
  <br>
  <a href="">
    <img src="https://emulation.gametechwiki.com/images/thumb/9/99/DOSBox-X.png/180px-DOSBox-X.png" alt="DOSBox-X" style="width:40%; max-width:200px; height:auto; border-radius:12px;">
  </a>
  <br>
    DOSBox-X ASM 2D Draw App
  <br>
</h1>


# Application

A modular assembly language PoC program that provides an interactive menu-driven interface for drawing geometric shapes in graphics mode. Built with **x86 assembly**, this application demonstrates efficient low-level programming with clean separation of concerns.

---

## 🧭 Features

- **Interactive Menu System:** Hierarchical menus for easy navigation  
- **Direct Video Drawing:** Efficient drawing of shapes using direct video memory access
- **Shape Drawing:** Support for lines (horizontal/vertical) and squares (filled/outline)  
- **Parameter Customization:** Configurable size, position, and color options  
- **Minimal Input Validation:** numeric input handling with some validation  
- **Screen Management:** Proper video mode switching and screen clearing

---

## 📂 Project Structure

- application/ (source, ASM modules)
  - MAIN.ASM — entry point and initialization
  - MENU.ASM — main menu interface and navigation
  - DRAWM.ASM — drawing submenu (shape selection)
  - DRAWL.ASM — line drawing primitives and menu
  - DRAWS.ASM — square drawing (filled/outline)
  - IO.ASM — I/O utilities and screen management
  - INP.ASM — numeric input handling (buffered input)
  - DATA.ASM — data definitions, messages, constants
- docs/ (GitHub Pages printable documentation)
  - index.html — description, block diagram, operation, test plan
  - styles.css — minimal styling
- images/ — raw screenshots and figures (to be curated)
- versions/ — archived evolutions of the project

---

## ⚙️ Technical Architecture

The application follows a **modular design pattern** where each component handles specific responsibilities:

- **Core Module (`MAIN.ASM`):** Initializes the environment and launches the main menu  
- **UI Layer (`MENU.ASM`, `DRAWM.ASM`):** Handles user interface and menu navigation  
- **Graphics Engine (`DRAWL.ASM`, `DRAWS.ASM`):** Implements shape drawing algorithms  
- **System Services (`IO.ASM`, `INP.ASM`):** Provides I/O operations and input validation  
- **Data Management (`DATA.ASM`):** Centralizes all data definitions and messages  

---

## 💻 Usage

0. Ensure DOSBOX-X is installed and configured correctly.
1. Compile the assembly source files using an x86 assembler (**MASM** or **TASM** compatible).
2. Run the executable to launch the application.  
3. Navigate through menus using numeric selections.  
4. Follow prompts to specify drawing parameters.  
5. View rendered shapes in graphics mode.  

---

## 📖 Documentation (GitHub Pages)

Project documentation (general description, block diagram, operation diagram, test plan) is published from the `docs/` folder.

- Online: enable GitHub Pages for this repo and point it to `docs/` (Settings → Pages)
- Local: open `docs/index.html` in a browser

---

## 🧱 Notes on repository hygiene

- Images are currently raw screenshots under `images/`. Recommended structure:
  - `assets/images/captures/` for screenshots (now populated)
  - `assets/images/diagrams/` for diagrams (moved `diagrama_bloc.png` here)
- Keep comments in code in English.

---

## 🏷️ Versioning strategy

- Prefer Git tags (e.g., `v1.0.0`) and/or a `release/` branch instead of keeping multiple copies in `versions/`.
- Keep `main` stable; cut a tag before releases.
- You can remove or archive the `versions/` folder once tags are created.

---

## 🔧 Build quickstart

MASM:

```
masm application\MAIN.ASM;
masm application\MENU.ASM;
masm application\DRAWM.ASM;
masm application\DRAWL.ASM;
masm application\DRAWS.ASM;
masm application\INP.ASM;
masm application\DATA.ASM;
masm application\IO.ASM;
link MAIN MENU DRAWM DRAWL DRAWS INP DATA IO;
```

Or TASM:

```
tasm /m2 application\MAIN.ASM
...
tlink /t MAIN MENU DRAWM DRAWL DRAWS INP DATA IO
```

---