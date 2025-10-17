#!/usr/bin/env bash
# ------------------------------------------
# TASM Build & Run Helper for DOSBox
# ------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOSBOX_CONF="$SCRIPT_DIR/dosbox-tasm.conf"
TASM_DIR="$SCRIPT_DIR/TASM"
TASM_CMD="TASM"
TLINK_CMD="TLINK"
DEBUGGER_CMD="TD"
DOSBOX_BIN="dosbox"

usage() {
    echo "Usage: $0 <file.asm> [-d] [-nc]"
    echo "  -d   Enable debug mode (use TD)"
    echo "  -nc  No cleanup (keep .OBJ/.MAP files)"
    exit 1
}

cleanup() {
    echo "Cleaning up..."
    local FILE_UPPER=$(echo "$basename" | tr '[:lower:]' '[:upper:]')
    rm -f "$TASM_DIR/$filename" \
          "$TASM_DIR/$FILE_UPPER.MAP" \
	  "$TASM_DIR/$FILE_UPPER.OBJ" \
	  "$TASM_DIR/$FILE_UPPER.EXE" 
}

if [ $# -lt 1 ]; then
    usage
fi

filename="$1"
basename="${filename%.*}"
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

# Safety checks

if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found."
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
mount c: $TASM_DIR
c:
$TASM_CMD $filename
$TLINK_CMD $basename.OBJ
EOF

if [[ "$debug" == true ]]; then
    echo "$DEBUGGER_CMD $basename" >> "$DOSBOX_CONF"
else
    echo "$basename" >> "$DOSBOX_CONF"
fi

cp "$filename" "$TASM_DIR/"
"$DOSBOX_BIN" -conf "$DOSBOX_CONF"

if [[ "$noclean" == false ]]; then
    cleanup
else
    echo "Skipping cleanup (use -nc flag)"
fi

rm -f "$DOSBOX_CONF"
