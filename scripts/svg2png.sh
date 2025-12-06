#!/bin/bash

# SVG to PNG Converter with Resize
# Usage: ./svg2png.sh [options] <input.svg or directory>

set -e

# Default values
WIDTH=""
HEIGHT=""
SCALE=100
OUTPUT_DIR="output"
QUALITY=90

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] <input.svg or directory>

Convert SVG files to PNG with optional resizing.

OPTIONS:
    -w WIDTH        Set output width in pixels
    -h HEIGHT       Set output height in pixels
    -s SCALE        Scale percentage (default: 100)
    -o DIR          Output directory (default: output)
    -q QUALITY      PNG quality 1-100 (default: 90)
    --help          Show this help message

EXAMPLES:
    # Convert single file with 50% scale
    $0 -s 50 input.svg

    # Convert with specific width (maintains aspect ratio)
    $0 -w 800 input.svg

    # Convert all SVGs in directory
    $0 -s 75 -o converted_pngs ./svg_files/

    # Convert with specific dimensions
    $0 -w 1920 -h 1080 logo.svg

REQUIREMENTS:
    - inkscape (preferred) OR rsvg-convert
    - imagemagick (for resizing)
EOF
    exit 0
}

# Function to check dependencies
check_dependencies() {
    local has_converter=false

    if command -v inkscape &> /dev/null; then
        CONVERTER="inkscape"
        has_converter=true
    elif command -v rsvg-convert &> /dev/null; then
        CONVERTER="rsvg-convert"
        has_converter=true
    fi

    if [ "$has_converter" = false ]; then
        echo -e "${RED}Error: Neither inkscape nor rsvg-convert found!${NC}"
        echo "Please install one of them:"
        echo "  Ubuntu/Debian: sudo apt-get install inkscape"
        echo "  Ubuntu/Debian: sudo apt-get install librsvg2-bin"
        echo "  macOS: brew install inkscape"
        echo "  macOS: brew install librsvg"
        exit 1
    fi

    if [ -n "$WIDTH" ] || [ -n "$HEIGHT" ] || [ "$SCALE" -ne 100 ]; then
        if ! command -v convert &> /dev/null; then
            echo -e "${YELLOW}Warning: ImageMagick not found. Resizing will be limited.${NC}"
            echo "Install with: sudo apt-get install imagemagick (or brew install imagemagick)"
        fi
    fi
}

# Function to convert single SVG file
convert_svg() {
    local input="$1"
    local filename=$(basename "$input" .svg)
    local output="$OUTPUT_DIR/${filename}.png"

    echo -e "${GREEN}Converting:${NC} $input"

    # Create temporary file for initial conversion
    local temp_png="${output}.tmp.png"

    # Convert SVG to PNG
    if [ "$CONVERTER" = "inkscape" ]; then
        inkscape "$input" --export-type=png --export-filename="$temp_png" &> /dev/null
    else
        rsvg-convert "$input" -o "$temp_png"
    fi

    # Apply resizing if needed
    if command -v convert &> /dev/null; then
        local resize_args=""

        if [ -n "$WIDTH" ] && [ -n "$HEIGHT" ]; then
            resize_args="${WIDTH}x${HEIGHT}!"
        elif [ -n "$WIDTH" ]; then
            resize_args="${WIDTH}x"
        elif [ -n "$HEIGHT" ]; then
            resize_args="x${HEIGHT}"
        elif [ "$SCALE" -ne 100 ]; then
            resize_args="${SCALE}%"
        fi

        if [ -n "$resize_args" ]; then
            convert "$temp_png" -resize "$resize_args" -quality "$QUALITY" "$output"
            rm "$temp_png"
        else
            mv "$temp_png" "$output"
        fi
    else
        mv "$temp_png" "$output"
    fi

    echo -e "${GREEN}Created:${NC} $output"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -w)
            WIDTH="$2"
            shift 2
            ;;
        -h)
            HEIGHT="$2"
            shift 2
            ;;
        -s)
            SCALE="$2"
            shift 2
            ;;
        -o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -q)
            QUALITY="$2"
            shift 2
            ;;
        --help)
            usage
            ;;
        -*)
            echo -e "${RED}Error: Unknown option $1${NC}"
            usage
            ;;
        *)
            INPUT="$1"
            shift
            ;;
    esac
done

# Check if input is provided
if [ -z "$INPUT" ]; then
    echo -e "${RED}Error: No input file or directory specified${NC}"
    usage
fi

# Check dependencies
check_dependencies

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Process input
if [ -f "$INPUT" ]; then
    # Single file
    if [[ "$INPUT" != *.svg ]]; then
        echo -e "${RED}Error: Input file is not an SVG${NC}"
        exit 1
    fi
    convert_svg "$INPUT"
elif [ -d "$INPUT" ]; then
    # Directory
    svg_count=$(find "$INPUT" -maxdepth 1 -name "*.svg" | wc -l)

    if [ "$svg_count" -eq 0 ]; then
        echo -e "${YELLOW}No SVG files found in $INPUT${NC}"
        exit 1
    fi

    echo -e "${GREEN}Found $svg_count SVG file(s)${NC}"
    echo ""

    find "$INPUT" -maxdepth 1 -name "*.svg" | while read -r svg_file; do
        convert_svg "$svg_file"
    done
else
    echo -e "${RED}Error: $INPUT is not a valid file or directory${NC}"
    exit 1
fi

echo -e "\n${GREEN}Done! Output files in: $OUTPUT_DIR${NC}"
