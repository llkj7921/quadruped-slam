#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_file="${SLAM_CONFIG_FILE:-${project_root}/config/robot.env}"

if [[ -f "${config_file}" ]]; then
  set -a
  source "${config_file}"
  set +a
fi

session_directory="${1:-}"
if [[ -z "${session_directory}" ]]; then
  echo "Usage: $0 <map_product_directory> [offline_dynamic_map_filter options]" >&2
  exit 2
fi
shift

ros_distro="${ROS_DISTRO:-humble}"
ros_setup="/opt/ros/${ros_distro}/setup.bash"
workspace_setup="${project_root}/install/setup.bash"
if [[ ! -f "${ros_setup}" || ! -f "${workspace_setup}" ]]; then
  echo "ROS or workspace setup is missing. Run ./scripts/install.sh and ./scripts/build.sh." >&2
  exit 1
fi

source "${ros_setup}"
source "${workspace_setup}"

exec ros2 run kiss_matcher_ros offline_dynamic_map_filter \
  "${session_directory}" \
  "$@"
