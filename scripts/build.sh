#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ros_distro="${ROS_DISTRO:-humble}"
ros_setup="/opt/ros/${ros_distro}/setup.bash"

if [[ ! -f "${ros_setup}" ]]; then
  echo "ROS setup not found: ${ros_setup}" >&2
  exit 1
fi
if [[ ! -d "${project_root}/src/KISS-Matcher" ]]; then
  echo "Sources are missing. Run ./scripts/install.sh first." >&2
  exit 1
fi

source "${ros_setup}"
cd "${project_root}"
colcon build --symlink-install --event-handlers console_cohesion+

echo "Build complete. Run: ./scripts/doctor.sh"
