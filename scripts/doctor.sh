#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ros_distro="${ROS_DISTRO:-humble}"
failed=0

check_file() {
  if [[ -e "$1" ]]; then
    printf '[OK] %s\n' "$1"
  else
    printf '[FAIL] missing %s\n' "$1"
    failed=1
  fi
}

check_command() {
  if command -v "$1" >/dev/null 2>&1; then
    printf '[OK] command %s\n' "$1"
  else
    printf '[FAIL] command %s not found\n' "$1"
    failed=1
  fi
}

check_file "/opt/ros/${ros_distro}/setup.bash"
check_file "${project_root}/install/setup.bash"
check_file "${project_root}/src/KISS-Matcher/ros/launch/robot_slam_bringup.launch.py"
check_file "${project_root}/src/spark-fast-lio/spark_fast_lio/config/mid360_indoor.yaml"
check_file "${project_root}/src/spark-fast-lio/spark_fast_lio/config/mid360_outdoor.yaml"
check_file "${project_root}/src/slam_system_interfaces/msg/RecoveryStatus.msg"

if [[ -f "/opt/ros/${ros_distro}/setup.bash" ]]; then
  source "/opt/ros/${ros_distro}/setup.bash"
fi
check_command ros2
check_command colcon

if [[ -f "${project_root}/install/setup.bash" ]]; then
  source "${project_root}/install/setup.bash"
  for package in slam_system_interfaces spark_fast_lio kiss_matcher_ros; do
    if ros2 pkg prefix "${package}" >/dev/null 2>&1; then
      printf '[OK] ROS package %s\n' "${package}"
    else
      printf '[FAIL] ROS package %s is unavailable\n' "${package}"
      failed=1
    fi
  done
fi

if ros2 node list >/dev/null 2>&1 && [[ -n "$(ros2 node list 2>/dev/null)" ]]; then
  echo '[INFO] ROS graph is active; checking runtime topics'
  for topic in /livox/lidar /livox/imu /recovery/state /system_mode/state; do
    if ros2 topic list 2>/dev/null | grep -Fxq "${topic}"; then
      printf '[OK] topic %s\n' "${topic}"
    else
      printf '[WARN] topic %s is not currently visible\n' "${topic}"
    fi
  done
else
  echo '[INFO] No active ROS graph; runtime topic checks skipped.'
fi

exit "${failed}"
