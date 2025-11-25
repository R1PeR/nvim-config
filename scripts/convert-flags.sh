#!/bin/bash

# A Bash script to convert a VS Code c_cpp_properties.json file
# into a compile_flags.txt file for clangd.
#
# Requires the 'jq' command-line JSON processor.
# Note: If running on Windows (Git Bash/Msys2), ensure 'jq' is in your PATH.

CONFIG_FILE="${1:-c_cpp_properties.json}"
CONFIG_NAME="${2}"
OUTPUT_FILE="compile_flags.txt"

echo "Reading configuration from: ${CONFIG_FILE}"

# --- Check Prerequisites (jq) ---
if ! command -v jq &> /dev/null
then
    echo "Error: 'jq' is required to parse JSON." >&2
    echo "Please install it (e.g., 'sudo apt install jq' or 'brew install jq')." >&2
    exit 1
fi

# --- Check Input File ---
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: The file '${CONFIG_FILE}' was not found." >&2
    exit 1
fi

# --- Configuration Selection Logic ---

# 1. Get configuration names and 0-based index
CONFIG_NAMES_JSON=$(cat "$CONFIG_FILE" | grep -v '//' | jq -r '.configurations | to_entries[] | {key: (.key + 1), name: .value.name, index: .key}' 2>/dev/null)

if [[ -z "$CONFIG_NAMES_JSON" ]]; then
    # If jq fails to parse even after stripping comments, we print the original error
    # and confirm no configs were found.
    echo "Error: Failed to parse configurations. Check the JSON format of '${CONFIG_FILE}'. (No configurations found in the sanitized content.)" >&2
    exit 1
fi

SELECTED_INDEX=""

if [[ -n "$CONFIG_NAME" ]]; then
    # A. Check for configuration name provided via command line
    SELECTED_INDEX=$(echo "$CONFIG_NAMES_JSON" | jq -r --arg name "$CONFIG_NAME" 'select(.name == $name) | .index // empty')
    
    if [[ -z "$SELECTED_INDEX" ]]; then
        echo "Warning: Configuration named '${CONFIG_NAME}' not found. Switching to interactive mode." >&2
    fi
fi

if [[ -z "$SELECTED_INDEX" ]]; then
    # B. Interactive selection if no valid config name was provided
    echo -e "\nAvailable configurations:"
    
    DEFAULT_NAME=$(echo "$CONFIG_NAMES_JSON" | jq -r '.[0].name // "Unnamed Config 1"')
    
    echo "$CONFIG_NAMES_JSON" | jq -r '. | "  [\(.key)] \(.name)"'

    echo -e " (Press Enter to use the default: '${DEFAULT_NAME}')"

    while true; do
        read -r -p "Enter your selection number: " CHOICE
        
        if [[ -z "$CHOICE" ]]; then
            # Default to the first configuration (index 0)
            SELECTED_INDEX=0
            break
        fi

        # Find the index based on the key (1-based user input)
        SELECTED_INDEX=$(echo "$CONFIG_NAMES_JSON" | jq -r --arg choice "$CHOICE" 'select(.key | tostring == $choice) | .index // empty')
        
        if [[ -n "$SELECTED_INDEX" ]]; then
            break
        else
            echo "Invalid choice. Please enter a number from the list." >&2
        fi
    done
fi

# --- Extract Target Configuration JSON Object ---
# Apply comment stripping here as well
CONFIG_JSON=$(cat "$CONFIG_FILE" | grep -v '//' | jq ".configurations[$SELECTED_INDEX]")
CONFIG_NAME_USED=$(echo "$CONFIG_JSON" | jq -r '.name // "Unnamed Config"')

echo "--- Using Configuration: ${CONFIG_NAME_USED} ---"

# --- 3. Process the flags ---

FLAGS_RAW=""
TOTAL_FLAGS_COUNT=0

# 3.1. Include Paths (-I)
echo "Extracting include paths..."
INCLUDE_PATHS=$(echo "$CONFIG_JSON" | jq -r '.includePath[]? // empty' | tr -d '\r')
COUNT_INCLUDES=0
for PATH_CURRENT in $INCLUDE_PATHS; do
    # Simple replacement for ${workspaceFolder}
    PATH_CURRENT=${PATH_CURRENT//\$\{workspaceFolder\}/\.}
    FLAGS_RAW+="-I$PATH_CURRENT\n"
    COUNT_INCLUDES=$((COUNT_INCLUDES + 1))
    TOTAL_FLAGS_COUNT=$((TOTAL_FLAGS_COUNT + 1))
done
echo "Found ${COUNT_INCLUDES} include path(s)."

# 3.2. Defines (-D)
echo "Extracting defines..."
DEFINES=$(echo "$CONFIG_JSON" | jq -r '.defines[]? // empty' | tr -d '\r')
COUNT_DEFINES=0
for DEFINE in $DEFINES; do
    FLAGS_RAW+="-D$DEFINE\n"
    COUNT_DEFINES=$((COUNT_DEFINES + 1))
    TOTAL_FLAGS_COUNT=$((TOTAL_FLAGS_COUNT + 1))
done
echo "Found ${COUNT_DEFINES} define(s)."


# 3.3. Standard Version (-std=)
CPP_STANDARD=$(echo "$CONFIG_JSON" | jq -r '.cppStandard // empty' | tr -d '\r')
C_STANDARD=$(echo "$CONFIG_JSON" | jq -r '.cStandard // empty' | tr -d '\r')

if [[ -n "$CPP_STANDARD" ]]; then
    FLAGS_RAW+="-std=$CPP_STANDARD"$'\n'
    echo "Set C++ Standard: $CPP_STANDARD"
    TOTAL_FLAGS_COUNT=$((TOTAL_FLAGS_COUNT + 1))
elif [[ -n "$C_STANDARD" ]]; then
    FLAGS_RAW+="-std=$C_STANDARD"$'\n'
    echo "Set C Standard: $C_STANDARD"
    TOTAL_FLAGS_COUNT=$((TOTAL_FLAGS_COUNT + 1))
fi

# 4. Add common warning flags (helpful for static analysis)
FLAGS_RAW+="-Wall"$'\n'
FLAGS_RAW+="-Wextra"$'\n'
FLAGS_RAW+="-target\nx86_64-pc-windows-gnu"

TOTAL_FLAGS_COUNT=$((TOTAL_FLAGS_COUNT + 3)) # For -Wall and -Wextra

# 5. Write the output file
echo -e "${FLAGS_RAW}" > "$OUTPUT_FILE"

if [[ $? -eq 0 ]]; then
    echo "------------------------------"
    echo "✅ Successfully converted configuration to ${OUTPUT_FILE}"
    echo "Total flags written: ${TOTAL_FLAGS_COUNT}"
else
    echo "Error writing to file '${OUTPUT_FILE}'." >&2
    exit 1
fi
