#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

default_fg_color_palette="88 124 160 196 202 208 214 220 226 190 154 118 112 82 46"
default_bg_color_palette="default"

fg_color_palette=""
bg_color_palette=""

get_charge_color_settings() {
    fg_color_palette=($(get_tmux_option "@batt_fg_color_palette" "$default_fg_color_palette" | sed -E 's/([0-9]+)/colour\1/g'))
    bg_color_palette=($(get_tmux_option "@batt_bg_color_palette" "$default_bg_color_palette" | sed -E 's/([0-9]+)/colour\1/g'))
}

get_color_idx() {
    percentage="$1"
    palette=("${!2}")
    palette_size="${#palette[@]}"

    color_idx=$(awk "BEGIN { printf \"%.0f\", $palette_size / (100/$palette_size) * ($percentage/$palette_size) }")
    color_idx=$(( (color_idx == 0 ? 1 : color_idx)-1 ))

    echo "$color_idx"
}

print_battery_status_bg() {
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')

    fg_color_idx=$(get_color_idx $percentage fg_color_palette[@])
    bg_color_idx=$(get_color_idx $percentage bg_color_palette[@])

    printf "#[fg=${fg_color_palette[$fg_color_idx]},bg=${bg_color_palette[$bg_color_idx]}]"
}

main() {
    get_charge_color_settings
    print_battery_status_bg
}
main
