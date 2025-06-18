### 设计目标

将现有的UDP回环实现修改为一个全双工的、应用层接口友好的UDP协议栈。新的设计将能够：
1.  监听一个由参数定义的本地UDP端口，接收来自指定源IP和源端口的数据包，并将数据负载传递给应用层。
2.  从应用层获取数据，并将其发送到由参数定义的目标IP和目标端口。

### 核心思路

1.  **解耦收发路径**：断开从接收逻辑到发送逻辑的直接回环连接，实现完全独立的接收和发送路径。
2.  **简化应用层接口**：在 `udp_top` 模块上定义极简的应用层接口。
    *   **发送 (TX)**: 应用层只需提供 `din_data`、`din_valid` 和 `din_last` 信号即可发送一个数据包。
    *   **接收 (RX)**: 应用层通过简单的 `dout_data` 和 `dout_valid` 信号接收数据。
3.  **内部接口转换**：在 `udp_top` 模块内部创建转换逻辑，该逻辑负责：
    *   在发送路径上，将 `din_*` 接口的数据缓存、计算长度，并转换为AXI-Stream格式写入发送FIFO。
    *   在接收路径上，将从接收FIFO读出的AXI-Stream数据转换为简单的 `dout_*` 信号。
4.  **使用FIFO进行缓冲和时钟域转换**：继续使用异步FIFO在 `sys_clk`（应用层时钟）和 `clk`（协议栈核心时钟）之间安全地传输数据负载，并起到缓冲作用。
5.  **静态IP/端口配置**：将本地和远端的IP地址及端口号作为模块参数（`parameter`）进行定义，使得接口更加简洁，配置在编译时完成。

### 详细设计方案

#### 1. 模块接口修改 (Interface Changes)

`udp_top` 模块的接口将被大幅简化，以参数化配置和简化的数据通路为核心。

**新增参数 (Parameters)**
这些参数用于在综合时静态配置UDP连接的端点信息。
*   `parameter LOCAL_IP = 32'hC0A8_010A;` // 本地IP地址 (e.g., 192.168.1.10)
*   `parameter LOCAL_PORT = 16'd1234;`   // 本地UDP端口 (监听端口)
*   `parameter DEST_IP = 32'hC0A8_010B;`   // 目标IP地址 (e.g., 192.168.1.11)
*   `parameter DEST_PORT = 16'd5678;`     // 目标UDP端口
*   `parameter DATA_W = 64;`            // 应用层数据位宽 (e.g., 64-bit)

**新增应用层发送接口 (App TX Interface - `sys_clk` domain)**
这些输入由应用层驱动，用于发送数据。
*   `input wire [DATA_W-1:0] din_data;`     // 发送的数据
*   `input wire din_valid;`                    // 数据有效信号 (推荐为单周期脉冲)
*   `input wire din_last;`                     // 包结尾信号，与 `din_valid` 同步有效，表示是当前包的最后一个数据
*   `output wire din_ready;`                   // 模块就绪信号，高表示可以接收数据

**新增应用层接收接口 (App RX Interface - `sys_clk` domain)**
这些输出连接到应用层，用于接收数据。
*   `output wire [DATA_W-1:0] dout_data;`    // 接收到的数据
*   `output wire dout_valid;`                   // 接收数据有效信号
*   `output wire dout_last;`                    // 包结尾信号，与 `dout_valid` 同步有效
*   `input wire dout_ready;`                    // 应用层就绪信号，高表示可以接收数据

#### 2. 接收路径实现 (Receive Path Implementation)

接收路径的目标是：监听 `LOCAL_PORT`，收到来自 `DEST_IP:DEST_PORT` 的数据包后，将其数据负载通过 `dout_*` 接口传递给应用层。

1.  **端口与IP过滤**: 在 `clk` 域，增强现有的匹配逻辑，使用参数进行过滤。
    ```verilog
    // 只有当目标端口、源IP、源端口全部匹配时，才认为包有效
    wire packet_match = (rx_udp_dest_port == LOCAL_PORT) && 
                        (rx_udp_ip_source_ip == DEST_IP) &&
                        (rx_udp_source_port == DEST_PORT); 
    ```
2.  **接收控制与FIFO写入**:
    *   当 `rx_udp_hdr_valid` 和 `packet_match` 同时为高时，表示一个有效的数据包头部到达。
    *   此时，准备将后续的 `rx_udp_payload_axis_*` 数据流写入接收异步FIFO (`rx_payload_fifo`)。
    *   接收FIFO的写端在 `clk` 时钟域。
3.  **接口转换与数据输出 (`sys_clk` 域)**:
    *   在 `sys_clk` 域，从 `rx_payload_fifo` 的读端读取数据。
    *   将FIFO的读接口 (`axis_tdata`, `axis_tvalid`, `axis_tlast`) 直接转换为 `dout_data`, `dout_valid`, `dout_last`。
    *   FIFO的读使能 (`axis_tready`) 由 `dout_ready` 信号控制。即 `assign rx_fifo_rd_en = dout_valid && dout_ready;`。这形成了一个标准的反压握手。

#### 3. 发送路径实现 (Transmit Path Implementation)

发送路径的目标是：从 `din_*` 接口接收一个完整的数据包，然后将其封装成UDP包，通过物理层发送出去。

1.  **接口转换与数据输入 (`sys_clk` 域)**:
    *   在 `sys_clk` 域，创建一个小型的控制逻辑来处理 `din_*` 接口。
    *   当 `din_valid` 和 `din_ready` 同时为高时，表示一个有效的数据传入。
    *   该逻辑需要将 `din_data` 写入发送异步FIFO (`tx_payload_fifo`)，同时计数数据量（例如，数据拍数或字节数）。
    *   当 `din_last` 信号有效时，表示应用层的一个数据包发送完毕。此时，将最终计算出的数据包长度锁存。
2.  **跨时钟域 (CDC) 控制信号传递**:
    *   当一个包在 `sys_clk` 域接收完毕后（检测到 `din_last`），需要将 **数据包总长度** 和一个 **发送启动信号** 安全地传递到 `clk` 域。
    *   这可以通过一个专门传递控制信息的小型异步FIFO实现，或者通过脉冲同步器（用于启动信号）和带有多周期约束的格雷码/寄存器组（用于长度）来实现。
3.  **发送控制状态机 (FSM) (`clk` 域)**:
    *   `clk` 域的发送FSM等待来自CDC逻辑的 **发送启动信号**。
    *   收到启动信号后，FSM从CDC逻辑获取 **数据包长度**。
    *   **发送头部**: FSM拉高 `tx_udp_hdr_valid`，并使用参数 `LOCAL_IP`, `LOCAL_PORT`, `DEST_IP`, `DEST_PORT` 以及获取的 **数据包长度** 来填充UDP头部信息。
    *   **发送负载**: 头部发送被接受后 (`tx_udp_hdr_ready` 为高)，FSM开始从 `tx_payload_fifo` 读出数据，并驱动 `tx_udp_payload_axis_*` 接口，直到所有数据发送完毕。
    *   完成后，FSM返回空闲状态，等待下一次发送请求。

### 代码结构调整建议

*   **使用异步FIFO**: 确保收发路径上的两个FIFO (`rx_payload_fifo`, `tx_payload_fifo`) 都是异步FIFO (`axis_async_fifo`)，正确连接 `sys_clk` 和 `clk`。
*   **新增接口转换逻辑**: 在 `udp_top.v` 中增加两个`always`块或子模块：
    *   一个在 `sys_clk` 域，用于实现 `din_*` 到 `tx_payload_fifo` 的转换和长度计算。
    *   一个在 `sys_clk` 域，用于实现 `rx_payload_fifo` 到 `dout_*` 的转换。
*   **移除旧逻辑**: 删除所有与动态IP/端口输入相关的逻辑以及旧的AXI-Stream应用层接口。
*   **更新参数化逻辑**: 确保所有使用到IP和端口的地方都已更新为引用新的 `parameter` 定义。

此方案将 `udp_top` 模块的用户接口大大简化，隐藏了AXI-Stream和时钟域转换的复杂性，使其成为一个易于集成、配置简单的UDP通信IP核。