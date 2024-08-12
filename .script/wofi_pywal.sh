#!/bin/bash

# Paths
WOFI_CSS="$HOME/.config/wofi/style.css"
WAL_COLORS="$HOME/.cache/wal/colors.json"

# Ensure bc is installed
if ! command -v bc &> /dev/null; then
    echo "bc could not be found, please install it (e.g., sudo pacman -S bc)"
    exit 1
fi

# Function to calculate luminance and set contrasting text color
get_contrast_color() {
    color=$1
    
    # Ensure the color starts with '#'
    if [[ $color != \#* ]]; then
        echo "#FFFFFF"  # Default to white if the color is invalid
        return
    fi

    # Extract RGB components
    r=$(printf "%d" 0x${color:1:2})
    g=$(printf "%d" 0x${color:3:2})
    b=$(printf "%d" 0x${color:5:2})

    # Calculate luminance
    luminance=$(echo "scale=2; (0.299 * $r + 0.587 * $g + 0.114 * $b)/255" | bc)

    # Choose contrast color based on luminance
    if (( $(echo "$luminance > 0.5" | bc -l) )); then
        echo "#000000"  # Dark text for light backgrounds
    else
        echo "#FFFFFF"  # Light text for dark backgrounds
    fi
}

# Restore placeholders in the CSS file
cat > "$WOFI_CSS" <<EOF
window {
    margin: 0px;
    border: 5px solid {background};
    background-color: {background};
    border-radius: 15px;
}

#input {
    padding: 4px;
    margin: 4px;
    padding-left: 20px;
    border: none;
    color: {contrast};
    font-weight: bold;
    background-color: {color0};
    outline: none;
    border-radius: 15px;
    margin: 10px;
    margin-bottom: 2px;
}

#input:focus {
    border: 0px solid {color0};
    margin-bottom: 0px;
}

#inner-box {
    margin: 4px;
    border: 10px solid {color0};
    color: {contrast};
    font-weight: bold;
    background-color: {color0};
    border-radius: 15px;
}

#outer-box {
    margin: 0px;
    border: none;
    border-radius: 15px;
    background-color: {color0};
}

#scroll {
    margin-top: 5px;
    border: none;
    border-radius: 15px;
    margin-bottom: 5px;
}

#img:selected {
    background-color: {color4};
    border-radius: 15px;
}

#text {
    margin-left: 20px; /* Extend the margin between icon and text */
    color: {contrast};
}

#text:selected {
    margin-left: 20px; /* Ensure the margin is applied to selected text as well */
    color: {contrast};
    margin: 10px 0px;
    border: none;
    border-radius: 15px;
    background-color: {color4};
}

#entry {
    margin: 10px 0px;
    padding-left: 20px;  /* Add padding to maintain spacing */
    border: none;
    border-radius: 15px;
    background-color: transparent;
}

#entry:selected {
    margin: 10px 0px;
    padding-left: 20px;  /* Ensure padding is consistent for selected entry */
    border: none;
    border-radius: 15px;
    background-color: {color4};
}
EOF

# Extract colors from Pywal's JSON file
background=$(jq -r '.colors.background' < "$WAL_COLORS")
foreground=$(jq -r '.colors.foreground' < "$WAL_COLORS")
color0=$(jq -r '.colors.color0' < "$WAL_COLORS")
color4=$(jq -r '.colors.color4' < "$WAL_COLORS")

# Calculate the contrast color
contrast=$(get_contrast_color "$background")

# Replace placeholders in the CSS file with actual colors
sed -i "s/{background}/$background/g" "$WOFI_CSS"
sed -i "s/{foreground}/$foreground/g" "$WOFI_CSS"
sed -i "s/{color0}/$color0/g" "$WOFI_CSS"
sed -i "s/{color4}/$color4/g" "$WOFI_CSS"
sed -i "s/{contrast}/$contrast/g" "$WOFI_CSS"

# Restart Wofi to apply changes (if needed)
# pkill wofi
