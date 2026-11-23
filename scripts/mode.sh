#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
action="${1:-}"

source "/opt/ros/${ROS_DISTRO:-humble}/setup.bash"
source "${project_root}/install/setup.bash"

case "${action}" in
  mapping)
    ros2 service call /mode/enter_mapping std_srvs/srv/Trigger '{}'
    ;;
  incremental)
    ros2 service call /mode/enter_incremental_mapping std_srvs/srv/Trigger '{}'
    ;;
  relocalization)
    ros2 service call /mode/enter_relocalization std_srvs/srv/Trigger '{}'
    ;;
  exit)
    ros2 service call /mode/exit std_srvs/srv/Trigger '{}'
    ;;
  status)
    ros2 service call /mode/status std_srvs/srv/Trigger '{}'
    ;;
  recovery)
    ros2 service call /recovery/status std_srvs/srv/Trigger '{}'
    ;;
  acknowledge)
    ros2 service call /recovery/acknowledge std_srvs/srv/Trigger '{}'
    ;;
  *)
    echo "Usage: $0 {mapping|incremental|relocalization|exit|status|recovery|acknowledge}" >&2
    exit 2
    ;;
esac
