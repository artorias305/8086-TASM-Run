# Setup Instructions

## 1. Install DOSBox

```bash
brew install dosbox-staging
```

## 2. Add TASM Files

This project does not include the TASM (Turbo Assembler) executables. You will need to find them online and place them in the `TASM` directory. The required files are:

*   `TASM.EXE`
*   `TLINK.EXE`
*   `TD.EXE`

After adding them, your `TASM` directory should look like this:

```
TASM/
├── TASM.EXE
├── TD.EXE
└── TLINK.EXE
```

## 3. Run a Program

To assemble, link, and run an assembly file, use the `run_asm` script:

```bash
./run_asm your_program.asm
```

Use the `-d` flag to debug the code, the -nc flag will disable the cleanup of temporary files.
