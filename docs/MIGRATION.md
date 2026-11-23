# 迁移到另一台机器人

## 必须确认的硬件契约

1. Ubuntu 22.04 与 ROS 2 Humble 已安装。
2. Livox Mid-360 驱动能够稳定发布 `/livox/lidar` 和 `/livox/imu`。
3. LiDAR 到 IMU 的外参、时间戳单位和点云格式与配置一致。
4. `map -> odom -> base` 坐标链中，`base` 名称与机器人 TF 一致。
5. 导航/任务控制节点订阅 `/recovery/state` 并执行 `autonomy_allowed`。

## 推荐迁移顺序

1. 克隆总仓库并运行 `scripts/install.sh`、`scripts/build.sh`。
2. 复制 `config/robot.env.example` 为 `config/robot.env`。
3. 修改 `ROS_DOMAIN_ID`、`SLAM_BASE_FRAME`、驱动启动方式及输出目录。
4. 单独启动雷达驱动，确认两个 Livox topic 的频率和时间戳连续。
5. 运行 `scripts/doctor.sh`。
6. 首次启动保持 `SLAM_START_DRIVER=false`、`SLAM_START_RVIZ=false`。
7. 进入建图模式并进行低速短距离测试。
8. 验证断流时 `/recovery/state` 的权限变化，再接入自主导航。

## 不应直接复制的内容

- 不要复制旧机器的 `build/`、`install/`、`log/`。
- 不要未经标定直接复用 LiDAR/IMU 外参。
- 不要只克隆三个组件的 `main`；应使用本仓库锁定的 commit。
- 不要在导航层忽略 `autonomy_allowed=false`。

## 已有地图迁移

将完整地图产品复制到目标机，至少确认存在：

```text
metadata.yaml
timestamps.txt
odometry_tum.txt
keyframes/
```

在 `config/robot.env` 设置：

```bash
SLAM_MAP_DIRECTORY=/absolute/path/to/map_product
SLAM_START_RELOCALIZER=true
```
