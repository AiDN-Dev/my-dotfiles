#!/usr/bin/env bash
for dev in $(upower -e 2>/dev/null | grep "battery_"); do
    MODEL=$(upower -i "$dev" 2>/dev/null | grep -i "model\|gaming-input" | head -1)
    if echo "$MODEL" | grep -qi "wireless controller\|gamepad\|ds4\|dualshock"; then
        CAPACITY=$(upower -i "$dev" 2>/dev/null | grep "percentage" | awk '{print $2}' | tr -d '%')
        NATIVE_PATH=$(upower -i "$dev" 2>/dev/null | grep "native-path" | awk '{print $2}')
        ICON_NAME=$(upower -i "$dev" 2>/dev/null | grep "icon-name" | awk -F"'" '{print $2}')
        
        if echo "$ICON_NAME" | grep -qi "charging"; then
            ICON="󰂄"
        elif echo "$NATIVE_PATH" | grep -qE "^[0-9]+-[0-9]+$"; then
            ICON="󰨢"
        else
            ICON="󰊴"
        fi
        
        if [ -n "$CAPACITY" ]; then
            echo "{\"text\": \"$ICON $CAPACITY%\", \"class\": \"ds4-connected\"}"
            exit 0
        fi
    fi
done
echo ""
