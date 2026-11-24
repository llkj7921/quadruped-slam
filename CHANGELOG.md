# Changelog

## 0.2.0 - 2026-11-24

- Adds offline geometric-persistence filtering for completed map products.
- Writes `clean_map.pcd` and `clean_map_report.yaml` without modifying the original map.
- Adds `scripts/clean_map.sh` as the deployment-level entry point.
- Adds unit tests and validates the filter against an existing 68-keyframe map session.

## 0.1.1 - 2026-11-23

- Adds the complete Apache License 2.0 text to the interface repository.
- Updates the locked interface package from 0.1.0 to 0.1.1.

## 0.1.0 - 2026-11-23

First reproducible quadruped SLAM delivery release.

- Locks compatible KISS-SAM, FAST-LIO and typed-interface commits.
- Provides dependency installation, build, startup and diagnostic scripts.
- Provides indoor/outdoor and robot environment configuration entry points.
- Provides mapping, incremental mapping, relocalization and recovery controls.
- Documents migration, recovery permissions, licensing and upstream provenance.
