#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

cpu_governor_powersave_fg_color=""
cpu_governor_performance_fg_color=""

cpu_governor_powersave_default_fg_color="#[fg=green]"
cpu_governor_performance_default_fg_color="#[fg=red]"

get_settings() {
  cpu_governor_powersave_fg_color=$(get_tmux_option "@cpu_governor_powersave_fg_color" "$cpu_governor_powersave_default_fg_color")
  cpu_governor_performance_fg_color=$(get_tmux_option "@cpu_governor_performance_fg_color" "$cpu_governor_performance_default_fg_color")
}

print_governor() {
  # TODO: some logic for multiple CPUs
  # TODO: x86_energy_perf_policy(1)
  # TODO: cpupower(1)
  local path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  if [ ! -f "$path" ]; then
    return
  fi

  local cpu_governor="$(cat "$path")"
  case "$cpu_governor" in
    powersave)   echo "${cpu_governor_powersave_fg_color}save";;
    performance) echo "${cpu_governor_performance_fg_color}perf";;
  esac
}

main() {
  get_settings
  print_governor
}
main
