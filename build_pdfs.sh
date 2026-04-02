#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LATEX_DIR="$ROOT_DIR/latex"
PDF_DIR="$ROOT_DIR/pdfs"

usage() {
    cat <<'EOF'
Usage:
  ./build_pdfs.sh <scenario_name> [document|pamphlet|both]
  ./build_pdfs.sh all [document|pamphlet|both]

Examples:
  ./build_pdfs.sh scenario_ai_arts_13-16
  ./build_pdfs.sh scenario_ai_arts_13-16 document
  ./build_pdfs.sh all both

Behavior:
  - Compiles LaTeX with latexmk from latex/<scenario_name>/
  - Copies outputs into pdfs/ using the public naming convention
  - Leaves generated PDFs in the scenario folder as well
EOF
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: required command not found: $1" >&2
        exit 1
    fi
}

compile_target() {
    local scenario="$1"
    local target="$2"
    local scenario_dir="$LATEX_DIR/$scenario"
    local tex_file out_pdf dest_pdf

    case "$target" in
        document)
            tex_file="main_EN.tex"
            out_pdf="main_EN.pdf"
            dest_pdf="$PDF_DIR/${scenario}_document.pdf"
            ;;
        pamphlet)
            tex_file="pamphlet_EN.tex"
            out_pdf="pamphlet_EN.pdf"
            dest_pdf="$PDF_DIR/${scenario}_pamphlet.pdf"
            ;;
        *)
            echo "Internal error: unknown target '$target'" >&2
            exit 1
            ;;
    esac

    if [[ ! -f "$scenario_dir/$tex_file" ]]; then
        echo "Skipping $scenario $target: missing $tex_file" >&2
        return 0
    fi

    echo "==> Compiling $scenario ($target)"
    (
        cd "$scenario_dir"
        latexmk -pdf -interaction=nonstopmode -halt-on-error "$tex_file"
    )

    cp "$scenario_dir/$out_pdf" "$dest_pdf"
    echo "    Copied to ${dest_pdf#$ROOT_DIR/}"
}

compile_scenario() {
    local scenario="$1"
    local mode="$2"

    if [[ ! -d "$LATEX_DIR/$scenario" ]]; then
        echo "Error: scenario folder not found: latex/$scenario" >&2
        exit 1
    fi

    case "$mode" in
        document)
            compile_target "$scenario" document
            ;;
        pamphlet)
            compile_target "$scenario" pamphlet
            ;;
        both)
            compile_target "$scenario" document
            compile_target "$scenario" pamphlet
            ;;
        *)
            echo "Error: invalid mode '$mode'. Use document, pamphlet, or both." >&2
            exit 1
            ;;
    esac
}

main() {
    require_cmd latexmk

    if [[ $# -lt 1 || $# -gt 2 ]]; then
        usage
        exit 1
    fi

    local scenario="$1"
    local mode="${2:-both}"

    mkdir -p "$PDF_DIR"

    if [[ "$scenario" == "all" ]]; then
        local dir base
        for dir in "$LATEX_DIR"/scenario_*; do
            [[ -d "$dir" ]] || continue
            base="$(basename "$dir")"
            compile_scenario "$base" "$mode"
        done
    else
        compile_scenario "$scenario" "$mode"
    fi
}

main "$@"
