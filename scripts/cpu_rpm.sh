#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

cpu_rpm_low_fg_color=""
cpu_rpm_medium_fg_color=""
cpu_rpm_high_fg_color=""

cpu_rpm_low_default_fg_color="#[fg=green]"
cpu_rpm_medium_default_fg_color="#[fg=yellow]"
cpu_rpm_high_default_fg_color="#[fg=red]"

get_fg_color_settings() {
  cpu_rpm_low_fg_color=$(get_tmux_option "@cpu_rpm_low_fg_color" "$cpu_rpm_low_default_fg_color")
  cpu_rpm_medium_fg_color=$(get_tmux_option "@cpu_rpm_medium_fg_color" "$cpu_rpm_medium_default_fg_color")
  cpu_rpm_high_fg_color=$(get_tmux_option "@cpu_rpm_high_fg_color" "$cpu_rpm_high_default_fg_color")
}

cpu_rpm_status() {
  local rpm="$1" && shift
  if [[ $rpm == 0 ]]; then
    echo low
  elif [[ $rpm -lt 500 ]]; then
    echo medium
  else
    echo high
  fi
}

print_rpm() {
  # TODO: detection which fan should be used
  # TODO: check for sensors(1)
  local rpm=$(sensors | grep -m1 RPM | awk '{print $(NF-1)}')
  local cpu_rpm_load_status=$(cpu_rpm_status $rpm)
  if [ $cpu_rpm_load_status == "low" ]; then
    echo -n "$cpu_rpm_low_fg_color"
  elif [ $cpu_rpm_load_status == "medium" ]; then
    echo -n "$cpu_rpm_medium_fg_color"
  elif [ $cpu_rpm_load_status == "high" ]; then
    echo -n "$cpu_rpm_high_fg_color"
  fi
  echo "${rpm}RPM"
}

main() {
  get_fg_color_settings
  print_rpm
}
main
