#!/usr/bin/env bash
# ------------------------------------------
# TASM Build & Run Helper for DOSBox
# ------------------------------------------

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TASM_DIR="$SCRIPT_DIR/TASM"
DOSBOX_CONF="$SCRIPT_DIR/dosbox-tasm.conf"
TASM_CMD="TASM"
TLINK_CMD="TLINK"
DEBUGGER_CMD="TD"

usage() {
    echo "Usage: $0 <file.asm> [-d] [-nc]"
    echo "  -d   Enable debug mode (use TD)"
    echo "  -nc  No cleanup (keep .OBJ/.MAP files)"
    exit 1
}

cleanup() {
    echo "Cleaning up..."
    rm -f "$TASM_DIR/$asm_file_name" \
          "$TASM_DIR/$base_name_upper.MAP" \
          "$TASM_DIR/$base_name_upper.OBJ" \
	  "$base_name.exe"
}

if command -v dosbox-staging &> /dev/null; then
    DOSBOX_BIN="dosbox-staging"
elif command -v dosbox &> /dev/null; then
    DOSBOX_BIN="dosbox"
else
    echo "Error: 'dosbox' or 'dosbox-staging' not found in PATH."
    exit 1
fi

if [ $# -lt 1 ]; then
    usage
fi

input_file="$1"
asm_file_name=$(basename "$input_file")
base_name="${asm_file_name%.*}"
base_name_upper=$(echo "$base_name" | tr '[:lower:]' '[:upper:]')
shift

debug=false
noclean=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d) debug=true ;; 
        -nc) noclean=true ;; 
        *) echo "Unknown option: $1"; usage ;; 
    esac
    shift
done

if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

if [ ! -d "$TASM_DIR" ]; then
    echo "Creating TASM directory at $TASM_DIR"
    mkdir -p "$TASM_DIR"
fi

cat > "$DOSBOX_CONF" <<EOF
[sdl]
fullscreen=false
[autoexec]
mount c: "$TASM_DIR"
c:
$TASM_CMD /zi $asm_file_name
$TLINK_CMD /v $base_name.OBJ
EOF

if [[ "$debug" == true ]]; then
    echo "$DEBUGGER_CMD $base_name" >> "$DOSBOX_CONF"
else
    echo "$base_name" >> "$DOSBOX_CONF"
fi

cp "$input_file" "$TASM_DIR/$asm_file_name"

"$DOSBOX_BIN" --noprimaryconf -conf "$DOSBOX_CONF"

if [ -f "$TASM_DIR/$base_name_upper.EXE" ]; then
    mv "$TASM_DIR/$base_name_upper.EXE" "$(dirname "$input_file")/$base_name.exe"
    echo "Output: $(dirname "$input_file")/$base_name.exe"
fi

if [[ "$noclean" == false ]]; then
    cleanup
else
    echo "Skipping cleanup."
fi

rm -f "$DOSBOX_CONF"
