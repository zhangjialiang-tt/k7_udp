// rtl\UDP 接收路径 (`udp_rx_path`) 设计说明文档.md
# UDP 接收路径 (`udp_rx_path`) 设计说明文档

## 1. 模块概述

`udp_rx_path` 模块是 UDP/IP 协议栈的接收路径核心部分。它的主要职责是：
1.  从 UDP 核心模块接收网络上传来的 UDP 数据包头部和数据负载。
2.  根据用户配置的 IP 地址和端口号对数据包进行过滤。
3.  将被接受数据包的有效载荷（Payload）通过一个异步 FIFO 从网络时钟域（`clk`）安全地传递到应用时钟域（`sys_clk`）。
4.  在应用时钟域，将字节流数据转换成应用层所需的数据总线宽度（例如64位），并提供给上层应用。

该模块是连接底层网络硬件接口和上层数据处理应用的关键桥梁。

## 2. 参数

| 参数名 | 描述 | 默认值 |
| :--- | :--- | :--- |
| `DATA_W` | 应用层数据输出总线 `dout_data` 的位宽。 | 64 |

## 3. 端口说明

模块接口分为几个部分，分属不同的时钟域。

### 3.1. 应用接口 (sys\_clk 时钟域)

| 端口名 | 方向 | 位宽 | 描述 |
| :--- | :--- | :--- | :--- |
| `sys_clk` | `input` | 1 | 应用层时钟。 |
| `sys_rst` | `input` | 1 | 应用层同步复位，高电平有效。 |
| `dout_data` | `output`| `DATA_W-1:0` | 输出给应用层的有效载荷数据。 |
| `dout_valid`| `output`| 1 | `dout_data` 的有效指示信号。 |
| `dout_last` | `output`| 1 | 表明 `dout_data` 是当前数据包的最后一个数据字。 |
| `dout_ready`| `input` | 1 | 由应用层驱动，表示已准备好接收下一个数据。 |

### 3.2. UDP 核心接口 (clk 时钟域)

| 端口名 | 方向 | 位宽 | 描述 |
| :--- | :--- | :--- | :--- |
| `clk` | `input` | 1 | UDP 核心时钟（通常来自 PHY）。 |
| `rst` | `input` | 1 | UDP 核心同步复位，高电平有效。 |
| `rx_udp_hdr_ready` | `output` | 1 | 通知 UDP 核心，本模块已准备好接收新的包头。 |
| `rx_udp_hdr_valid` | `input` | 1 | UDP 核心发来的包头有效信号。 |
| `rx_udp_ip_source_ip`| `input` | 31:0 | 接收包的源 IP 地址。 |
| `rx_udp_ip_dest_ip` | `input` | 31:0 | 接收包的目标 IP 地址。 |
| `rx_udp_source_port` | `input` | 15:0 | 接收包的源 UDP 端口。 |
| `rx_udp_dest_port` | `input` | 15:0 | 接收包的目标 UDP 端口。 |
| `rx_udp_payload_axis_tdata`| `input`| 7:0 | UDP 载荷数据 (AXI-Stream 字节流)。 |
| `rx_udp_payload_axis_tvalid`|`input`| 1 | `tdata` 有效信号。 |
| `rx_udp_payload_axis_tready`|`output`| 1 | 本模块准备好接收 `tdata`。 |
| `rx_udp_payload_axis_tlast`| `input` | 1 | 表明 `tdata` 是包的最后一个字节。 |
| `rx_udp_payload_axis_tuser`| `input` | 1 | AXI-Stream 用户信号，通常用于错误指示。 |

### 3.3. 元数据输出 (sys\_clk 时钟域)

| 端口名 | 方向 | 位宽 | 描述 |
| :--- | :--- | :--- | :--- |
| `m_app_rx_src_ip` | `output` | 31:0 | 接收包的源 IP 地址。 |
| `m_app_rx_src_port`| `output` | 15:0 | 接收包的源端口号。 |
| `m_app_rx_valid` | `output` | 1 | 元数据有效信号。 |
> **注意**：在当前代码中，这三个元数据输出端口虽然已声明，但未在模块内部被赋值。因此它们不会提供有效信息。需要额外添加逻辑来实现元数据跨时钟域传递。

### 3.4. 配置端口

| 端口名 | 方向 | 位宽 | 描述 |
| :--- | :--- | :--- | :--- |
| `local_ip` | `input` | 31:0 | 本地 IP 地址配置。 |
| `dest_ip` | `input` | 31:0 | 期望通信的远端 IP 地址。 |
| `local_port` | `input` | 15:0 | 本地 UDP 端口号。 |
| `dest_port` | `input` | 15:0 | 期望通信的远端 UDP 端口号。 |

## 4. 设计详解

### 4.1. 总体结构

模块采用双时钟域设计：
*   **核时钟域 (`clk`)**: 处理与 UDP 核心的交互，包括包过滤和初步的数据接收。
*   **应用时钟域 (`sys_clk`)**: 负责将数据格式化并提交给上层应用。

两者之间通过一个 **异步 AXI-Stream FIFO** (`axis_async_fifo`) 进行数据缓冲和安全的时钟域穿越。

### 4.2. 报文过滤

当 `rx_udp_hdr_valid` 信号有效时，模块会立刻对包头信息进行检查。`packet_match` 信号的产生逻辑如下：
```verilog
assign packet_match = (rx_udp_ip_dest_ip == local_ip) && 
                      (rx_udp_dest_port == local_port) && 
                      (rx_udp_ip_source_ip == dest_ip) && 
                      (rx_udp_source_port == dest_port);
```
一个数据包必须 同时满足 以下所有条件才会被接受：
1. 其目标 IP 地址 (rx_udp_ip_dest_ip) 必须与配置的 local_ip 完全匹配。
2. 其目标 UDP 端口 (rx_udp_dest_port) 必须与配置的 local_port 完全匹配。
3. 其源 IP 地址 (rx_udp_ip_source_ip) 必须与配置的 dest_ip 完全匹配。
4. 其源 UDP 端口 (rx_udp_source_port) 必须与配置的 dest_port 完全匹配。
> 重要说明: 此过滤规则非常严格，仅接受来自特定 IP 和端口的"点对点"数据包。
### 4.3. 接收控制逻辑 (clk 时钟域)
此逻辑的核心是两个状态寄存器 rx_packet_active_reg 和 rx_drop_packet_reg。

- 当一个匹配的包头到达 (rx_udp_hdr_valid 为高)，且下游 FIFO 未满时，rx_packet_active_reg 置位，表示模块进入数据包处理状态。
- 如果包头不匹配，或 FIFO 已满，rx_drop_packet_reg 会置位，后续该包的所有 payload 都将被丢弃。
- rx_udp_hdr_ready 信号在模块未处理任何数据包 (!rx_packet_active_reg) 时置为高电平，这向 UDP 核心表明本模块已准备好对下一个新包头进行仲裁。
- 对于被丢弃的包，rx_udp_payload_axis_tready 会被强行拉高，以尽快消耗掉无效数据。对于接受的包，tready 则由下游的异步 FIFO 控制。

### 4.4. 异步 FIFO
模块使用了一个深度为 8192 字节的8位宽 axis_async_fifo。

- 功能: 作为 clk 和 sys_clk 两个时钟域之间的数据桥梁。
- 模式: 配置为 FRAME_FIFO 模式，使其能正确处理基于 tlast 信号的完整数据帧。

### 4.5. 应用层接口逻辑 (sys_clk 时钟域)
此部分包含一个四状态的状态机，负责从 FIFO 中读取字节流并将其组装成 DATA_W 宽度的并行数据。

- RX_APP_IDLE (空闲状态): 等待 FIFO 中有数据 (m_app_rx_axis_tvalid)。若有，则进入准备状态。

- RX_APP_PREP (准备状态): 此状态仅持续一个时钟周期。它负责清空内部的数据缓冲区 (rx_data_buffer)并重置字节计数器，为接收新数据字做准备，然后立即转换到收集状态。

- RX_APP_COLLECT (收集状态): 从 FIFO 中逐字节读取数据，并存入 rx_data_buffer 寄存器。当收集满 DATA_W/8 个字节，或遇到 tlast 信号时，切换到输出状态。

- RX_APP_OUTPUT (输出状态): 拉高 dout_valid，将 rx_data_buffer 的内容输出。等待应用层拉高 dout_ready 后，根据是否为包的末尾，决定返回 RX_APP_IDLE (包结束) 或 RX_APP_PREP (包未结束，准备接收下一个字) 状态。

> 设计改进: RX_APP_PREP 状态的引入确保了当接收到一个长度小于 DATA_W 的数据字时（例如在数据包末尾），dout_data 输出总线中未被使用的比特位会被可靠地清零，从而避免将上一次操作的陈旧数据传递给应用层。

这种“准备-收集-输出-握手”的机制确保了数据在应用层的可靠和正确传输。