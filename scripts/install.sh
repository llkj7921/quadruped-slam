#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ros_distro="${ROS_DISTRO:-humble}"
ros_setup="/opt/ros/${ros_distro}/setup.bash"

if [[ ! -f "${ros_setup}" ]]; then
  echo "ROS 2 ${ros_distro} is not installed: ${ros_setup}" >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y python3-rosdep python3-vcstool

mkdir -p "${project_root}/src"
vcs import "${project_root}/src" < "${project_root}/slam.repos"

if [[ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]]; then
  sudo rosdep init
fi
rosdep update

source "${ros_setup}"
rosdep install \
  --from-paths "${project_root}/src" \
  --ignore-src \
  --rosdistro "${ros_distro}" \
  -r -y

echo "Sources and dependencies are ready. Run: ./scripts/build.sh"
