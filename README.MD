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

- MAIN.ASM - Application entry point and initialization
- MENU.ASM - Main menu interface and navigation
- DRAWM.ASM - Drawing submenu for shape selection
- DRAWL.ASM - Line drawing functionality and parameters
- DRAWS.ASM - Square drawing with size and position controls
- IO.ASM - Input/output utilities and screen management
- INP.ASM - Numeric input handling and validation
- DATA.ASM - Data definitions, messages, and constants

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