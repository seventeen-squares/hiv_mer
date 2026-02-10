#!/bin/bash

# Script to import data elements from CSV file
# Usage: ./scripts/import_csv.sh <csv_file_path>

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if CSV file path is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Please provide the CSV file path${NC}"
    echo -e "${BLUE}Usage: ./scripts/import_csv.sh <csv_file_path>${NC}"
    echo -e "${BLUE}Example: ./scripts/import_csv.sh ~/Downloads/dataelements.csv${NC}"
    exit 1
fi

CSV_FILE="$1"

# Check if CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo -e "${RED}❌ Error: CSV file not found at $CSV_FILE${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Starting CSV import process...${NC}"
echo -e "${YELLOW}📂 CSV File: $CSV_FILE${NC}"

# Backup existing files
echo -e "${YELLOW}💾 Creating backup of existing files...${NC}"
if [ -f "assets/data/data_elements.json" ]; then
    cp "assets/data/data_elements.json" "assets/data/data_elements.json.backup.$(date +%Y%m%d_%H%M%S)"
    echo "   ✅ Backed up data_elements.json"
fi

if [ -f "assets/data/data_element_categories.json" ]; then
    cp "assets/data/data_element_categories.json" "assets/data/data_element_categories.json.backup.$(date +%Y%m%d_%H%M%S)"
    echo "   ✅ Backed up data_element_categories.json"
fi

# Run the Dart import script
echo -e "${YELLOW}⚙️  Running import script...${NC}"
dart scripts/import_data_elements.dart "$CSV_FILE"

# Check if import was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Import completed successfully!${NC}"
    echo -e "${BLUE}📊 Files updated:${NC}"
    echo "   - assets/data/data_elements.json"
    echo "   - assets/data/data_element_categories.json"
    
    # Show file sizes
    if [ -f "assets/data/data_elements.json" ]; then
        SIZE=$(wc -c < "assets/data/data_elements.json")
        echo -e "${BLUE}   📏 data_elements.json: $SIZE bytes${NC}"
    fi
    
    if [ -f "assets/data/data_element_categories.json" ]; then
        SIZE=$(wc -c < "assets/data/data_element_categories.json")
        echo -e "${BLUE}   📏 data_element_categories.json: $SIZE bytes${NC}"
    fi
    
    echo -e "${YELLOW}🧪 Testing app compilation...${NC}"
    if flutter analyze --no-fatal-infos > /dev/null 2>&1; then
        echo -e "${GREEN}✅ App compiles successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️  Warning: Some analysis issues found. Run 'flutter analyze' for details.${NC}"
    fi
    
    echo -e "${GREEN}🎉 Import process completed! Your app is ready to use the new data.${NC}"
else
    echo -e "${RED}❌ Import failed! Check the error messages above.${NC}"
    exit 1
fi