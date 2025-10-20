# 8086 TASM Run

This is a small Bash script to assemble, link, and run 16-bit x86 `.asm` programs using TASM inside DOSBox.

## How to Use

To run a `.asm` file, execute the script from anywhere and provide the path to your file:

```bash
/path/to/8086-TASM-Run/run_asm.sh /path/to/your/file.asm
```

For example, from within the project directory:

```bash
./run_asm.sh test.asm
```

**Options:**

* `-d`: Enable debug mode (runs Turbo Debugger `TD.EXE` after assembly and linking).
* `-nc`: No cleanup (preserves intermediate `.OBJ` and `.MAP` files in the `TASM` directory for inspection).

## How it Works

The script uses a `TASM` subdirectory within the project folder (`8086-TASM-Run/TASM`) as the virtual `C:` drive for DOSBox. All assembly and linking operations occur there.

## Why

This script automates the repetitive process of mounting, assembling, linking, and running, making it easy to work on 16-bit assembly projects from any location on your filesystem.

## Requirements

*   **DOSBox Staging**: The modern continuation of DOSBox, might work on default DOSBox but i havent tested it, might require some changes on the script.
*   **TASM**: `TASM.EXE`, `TLINK.EXE`, and optionally `TD.EXE` must be placed in the `TASM` directory. This project does not include them due to licensing restrictions, but they can be found online.
