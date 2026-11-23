#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_file="${SLAM_CONFIG_FILE:-${project_root}/config/robot.env}"

if [[ -f "${config_file}" ]]; then
  set -a
  source "${config_file}"
  set +a
fi

ros_distro="${ROS_DISTRO:-humble}"
ros_setup="/opt/ros/${ros_distro}/setup.bash"
workspace_setup="${project_root}/install/setup.bash"

if [[ ! -f "${ros_setup}" || ! -f "${workspace_setup}" ]]; then
  echo "ROS or workspace setup is missing. Run ./scripts/install.sh and ./scripts/build.sh." >&2
  exit 1
fi

source "${ros_setup}"
source "${workspace_setup}"

exec ros2 launch kiss_matcher_ros robot_slam_bringup.launch.py \
  environment:="${SLAM_ENVIRONMENT:-outdoor}" \
  display_mode:="${SLAM_DISPLAY_MODE:-original}" \
  map_directory:="${SLAM_MAP_DIRECTORY:-}" \
  map_frame:="${SLAM_MAP_FRAME:-map}" \
  odom_frame:="${SLAM_ODOM_FRAME:-odom}" \
  base_frame:="${SLAM_BASE_FRAME:-livox_frame}" \
  output_directory:="${SLAM_OUTPUT_DIRECTORY:-maps}" \
  output_sequence:="${SLAM_OUTPUT_SEQUENCE:-robot_mapping}" \
  start_driver:="${SLAM_START_DRIVER:-false}" \
  driver_package:="${SLAM_DRIVER_PACKAGE:-livox_ros_driver2}" \
  driver_launch_file:="${SLAM_DRIVER_LAUNCH_FILE:-msg_MID360_launch.py}" \
  start_rviz:="${SLAM_START_RVIZ:-false}" \
  start_relocalizer:="${SLAM_START_RELOCALIZER:-false}" \
  record_diagnostics:="${SLAM_RECORD_DIAGNOSTICS:-true}" \
  "$@"
