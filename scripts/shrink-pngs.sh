#!/bin/bash

# PNG Shrinking Script
# Reduces PNG file sizes using pngquant and optipng

# Note: Removed 'set -e' to continue processing even if individual files fail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DIRECTORY="."
QUALITY="65-80"
BACKUP=false
DRY_RUN=false
RECURSIVE=false
WIDTH=""

# Function to display usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Shrink PNG files in a directory using pngquant and optipng.

OPTIONS:
    -d, --directory DIR     Directory containing PNG files (default: current directory)
    -q, --quality RANGE     Quality range for pngquant (default: 65-80)
                           Format: MIN-MAX where both are 0-100
    -w, --width PIXELS     Resize images to specified width (maintains aspect ratio)
    -b, --backup           Create backups of original files
    -r, --recursive        Process subdirectories recursively
    -n, --dry-run          Show what would be done without making changes
    -h, --help             Display this help message

EXAMPLES:
    $(basename "$0") -d assets
    $(basename "$0") -d images -q 70-85 -b
    $(basename "$0") -d assets -w 800
    $(basename "$0") -d . -r -n

REQUIREMENTS:
    - pngquant: Install with 'brew install pngquant' (macOS) or 'apt install pngquant' (Linux)
    - optipng: Install with 'brew install optipng' (macOS) or 'apt install optipng' (Linux)
    - sips or imagemagick: For resizing (sips is pre-installed on macOS)

EOF
    exit 0
}

# Function to check if required tools are installed
check_dependencies() {
    local missing_tools=()
    
    if ! command -v pngquant &> /dev/null; then
        missing_tools+=("pngquant")
    fi
    
    if ! command -v optipng &> /dev/null; then
        missing_tools+=("optipng")
    fi
    
    # Check for resize tools if width is specified
    if [ -n "$WIDTH" ]; then
        if ! command -v sips &> /dev/null && ! command -v convert &> /dev/null; then
            echo -e "${RED}Error: Image resizing requires either 'sips' (macOS) or 'imagemagick'${NC}"
            echo ""
            echo "Install ImageMagick:"
            echo "  macOS: brew install imagemagick"
            echo "  Linux: sudo apt install imagemagick"
            exit 1
        fi
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${RED}Error: Missing required tools: ${missing_tools[*]}${NC}"
        echo ""
        echo "Install on macOS:"
        echo "  brew install ${missing_tools[*]}"
        echo ""
        echo "Install on Linux:"
        echo "  sudo apt install ${missing_tools[*]}"
        exit 1
    fi
}

# Function to format bytes to human readable
format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes}B"
    elif [ $bytes -lt 1048576 ]; then
        echo "$(awk -v b=$bytes 'BEGIN {printf "%.1f", b/1024}')KB"
    else
        echo "$(awk -v b=$bytes 'BEGIN {printf "%.1f", b/1048576}')MB"
    fi
}

# Function to process a single PNG file
process_png() {
    local file="$1"
    local original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    if [ $DRY_RUN = true ]; then
        echo -e "${BLUE}[DRY RUN]${NC} Would process: $file ($(format_bytes $original_size))"
        if [ -n "$WIDTH" ]; then
            echo "  Would resize to width: ${WIDTH}px"
        fi
        echo "0"  # Return 0 savings for dry run
        return 0
    fi
    
    echo -e "${YELLOW}Processing:${NC} $file"
    echo -n "  Original size: $(format_bytes $original_size) -> "
    
    # Create backup if requested
    if [ $BACKUP = true ]; then
        cp "$file" "${file}.backup"
        echo -e "${GREEN}Backup created${NC}"
    fi
    
    # Resize if width is specified
    if [ -n "$WIDTH" ]; then
        echo ""
        echo -e "  ${BLUE}Resizing to width: ${WIDTH}px${NC}"
        if command -v sips &> /dev/null; then
            # Use sips on macOS
            sips -Z "$WIDTH" "$file" &> /dev/null || echo -e "  ${RED}Resize failed${NC}"
        elif command -v convert &> /dev/null; then
            # Use ImageMagick
            convert "$file" -resize "${WIDTH}x" "$file" 2>/dev/null || echo -e "  ${RED}Resize failed${NC}"
        fi
        local resized_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        echo -n "  After resize: $(format_bytes $resized_size) -> "
    fi
    
    # Temporary file for pngquant output
    local temp_file="${file%.png}-fs8.png"
    
    # Run pngquant
    if pngquant --quality=$QUALITY --force --output "$temp_file" "$file" 2>/dev/null; then
        mv "$temp_file" "$file"
    else
        if [ -f "$temp_file" ]; then
            rm "$temp_file"
        fi
    fi
    
    # Run optipng for further optimization
    optipng -quiet -o2 "$file" 2>/dev/null || true
    
    # Calculate new size and savings
    local new_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    local saved=$((original_size - new_size))
    local percent=0
    
    if [ $original_size -gt 0 ]; then
        percent=$(awk -v s=$saved -v o=$original_size 'BEGIN {printf "%.1f", (s/o)*100}')
    fi
    
    echo -e "Final size: $(format_bytes $new_size) ${GREEN}(saved $(format_bytes $saved), $percent%)${NC}"
    
    # Echo the saved amount so it can be captured
    echo "$saved"
    return 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--directory)
            DIRECTORY="$2"
            shift 2
            ;;
        -q|--quality)
            QUALITY="$2"
            shift 2
            ;;
        -w|--width)
            WIDTH="$2"
            shift 2
            ;;
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -r|--recursive)
            RECURSIVE=true
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option: $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Main script execution
echo -e "${BLUE}=== PNG Shrinking Script ===${NC}"
echo ""

# Check dependencies
check_dependencies

# Verify directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo -e "${RED}Error: Directory '$DIRECTORY' does not exist${NC}"
    exit 1
fi

echo "Directory: $DIRECTORY"
echo "Quality: $QUALITY"
if [ -n "$WIDTH" ]; then
    echo "Resize width: ${WIDTH}px"
fi
echo "Backup: $BACKUP"
echo "Recursive: $RECURSIVE"
echo "Dry run: $DRY_RUN"
echo ""

# Find PNG files
if [ $RECURSIVE = true ]; then
    PNG_FILES=$(find "$DIRECTORY" -type f -iname "*.png")
else
    PNG_FILES=$(find "$DIRECTORY" -maxdepth 1 -type f -iname "*.png")
fi

# Count files
FILE_COUNT=$(echo "$PNG_FILES" | grep -c . || echo "0")

if [ $FILE_COUNT -eq 0 ]; then
    echo -e "${YELLOW}No PNG files found in $DIRECTORY${NC}"
    exit 0
fi

echo -e "${GREEN}Found $FILE_COUNT PNG file(s)${NC}"
echo ""

# Process each PNG file
total_saved=0
processed=0
failed=0

while IFS= read -r file; do
    if [ -n "$file" ]; then
        saved=$(process_png "$file" 2>&1 | tail -1)  # Capture the last line (saved amount)
        if [[ "$saved" =~ ^[0-9]+$ ]]; then
            total_saved=$((total_saved + saved))
            processed=$((processed + 1))
        else
            failed=$((failed + 1))
            echo -e "${RED}Failed to process: $file${NC}"
        fi
        echo ""
    fi
done <<< "$PNG_FILES"

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo "Files processed: $processed"
if [ $failed -gt 0 ]; then
    echo -e "${RED}Files failed: $failed${NC}"
fi
if [ $DRY_RUN = false ]; then
    echo -e "Total space saved: ${GREEN}$(format_bytes $total_saved)${NC}"
fi
echo ""
echo -e "${GREEN}Done!${NC}"
