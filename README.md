# Quadruped SLAM Deployment

机器狗 ROS 2 SLAM 的统一交付入口。该仓库不复制算法源码，而是锁定并组装三个相互兼容的仓库：

- `quadruped-kiss-matcher-sam`：KISS-SAM 后端、重定位、模式与恢复管理、统一启动。
- `quadruped-spark-fast-lio`：FAST-LIO 前端、Mid-360 配置、断流检测和地图冻结。
- `slam-system-interfaces`：跨节点强类型 ROS 2 消息。

`slam.repos` 固定经过验证的精确 commit，避免不同机器拉到不兼容版本。

## 支持环境

- Ubuntu 22.04
- ROS 2 Humble
- Livox Mid-360
- 默认 topic：`/livox/lidar`、`/livox/imu`

## 首次安装

```bash
git clone https://github.com/llkj7921/quadruped-slam.git
cd quadruped-slam
./scripts/install.sh
./scripts/build.sh
cp config/robot.env.example config/robot.env
./scripts/doctor.sh
```

`install.sh` 会安装 `vcstool/rosdep`、按 `slam.repos` 拉取三个源码仓库并安装 ROS 依赖。构建期间第三方 C++ 依赖可能需要访问网络。

## 启动

先根据机器人修改 `config/robot.env`，然后运行：

```bash
./scripts/start.sh
```

如果 Livox 驱动由机器人系统单独启动，保持：

```bash
SLAM_START_DRIVER=false
```

只有确认 `livox_ros_driver2` 已安装且启动文件名称匹配时，才设置为 `true`。

启动参数也可以临时追加并覆盖，例如：

```bash
./scripts/start.sh environment:=indoor start_rviz:=true record_diagnostics:=false
```

## 模式控制

```bash
./scripts/mode.sh mapping          # 进入建图
./scripts/mode.sh incremental      # 进入增量建图
./scripts/mode.sh relocalization   # 进入重定位
./scripts/mode.sh exit             # 退出到常规定位
./scripts/mode.sh status           # 查询业务模式
./scripts/mode.sh recovery         # 查询恢复状态
./scripts/mode.sh acknowledge      # 确认已经恢复
```

特殊模式之间不能直接切换，必须先 `exit` 回到常规定位。

持续查看恢复状态：

```bash
source /opt/ros/humble/setup.bash
source install/setup.bash
ros2 topic echo /recovery/state
```

## 恢复权限

异常时算法仍允许底层人工遥控，但会关闭地图写入和自主导航权限：

| 状态 | 含义 | `map_writes_allowed` | `autonomy_allowed` |
| --- | --- | --- | --- |
| `NORMAL` | 正常 | true | true |
| `SUSPECTED` | 疑似异常 | false | false |
| `RECOVERING` | 自动恢复中 | false | false |
| `OPERATOR_ASSISTANCE_REQUIRED` | 需要人工协助 | false | false |
| `RECOVERED_WAITING_CONFIRMATION` | 已找回，等待确认 | false | false |

导航/任务控制必须订阅 `/recovery/state` 并执行 `autonomy_allowed`；SLAM 发布权限并不会自动阻止另一个控制节点发速度。

## 更新组件版本

不要把 `slam.repos` 的版本改成浮动的 `main`。升级某一组件后，应完成三包构建、测试和 rosbag 回归，再把验证过的完整 commit 写入 `slam.repos`。

## 真机迁移

外参、TF、雷达 topic、ROS domain、驱动启动方式和导航权限接入见 [docs/MIGRATION.md](docs/MIGRATION.md)。systemd 模板位于 `systemd/quadruped-slam.service`，安装前必须修改其中的用户和绝对路径。
