#!/usr/bin/env bash
# ==============================================================================
# Script to regenerate visual assets & README showcase images for typst-script-template
# ==============================================================================
set -euo pipefail

# Ensure working directory is the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir -p assets

echo "==> [1/3] Compiling showcase PDF..."
typst compile showcase.typ showcase.pdf

echo "==> [2/3] Extracting showcase pages at 150 PPI..."
typst compile --ppi 150 --pages 1 showcase.typ assets/showcase-title.png
typst compile --ppi 150 --pages 4 showcase.typ assets/showcase-environments.png
typst compile --ppi 150 --pages 5 showcase.typ assets/showcase-theorems.png
typst compile --ppi 150 --pages 6 showcase.typ assets/showcase-diagrams.png
typst compile --ppi 150 --pages 8 showcase.typ assets/showcase-index.png

echo "==> [3/3] Compiling lecture marker demo snippet at 180 PPI..."
TMP_SNIPPET="$(mktemp -p "$SCRIPT_DIR" .tmp_lecture_XXXXXX.typ)"
trap 'rm -f "$TMP_SNIPPET"' EXIT

cat << 'EOF' > "$TMP_SNIPPET"
#import "lib.typ": *

#set page(paper: "a4", margin: (x: 2.5cm, top: 2.0cm, bottom: 2.0cm), height: auto)
#set text(font: "New Computer Modern", size: 10.5pt, lang: "de")
#set par(justify: true)

#lecture(1, date: datetime(year: 2026, month: 10, day: 14))

In der ersten Vorlesung führen wir die topologischen Grundbegriffe ein und untersuchen stetige Abbildungen zwischen topologischen Räumen.

#v(1.0em)

#lecture-break(1, 2, date: datetime(year: 2026, month: 10, day: 16))

Wir setzen die Diskussion mit der Homotopietheorie von Wegen und Schleifen fort.

#v(1.0em)

#lecture-end(2)
EOF

typst compile --root "$SCRIPT_DIR" --ppi 180 "$TMP_SNIPPET" assets/lecture-markers.png

echo "==> All assets successfully generated in assets/:"
ls -lh assets/
