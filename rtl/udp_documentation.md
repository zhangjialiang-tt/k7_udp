# UDP Module Documentation

## udp_top.v - Top-level UDP Module

### Overview
The `udp_top` module integrates the UDP core, transmit path, and receive path. It handles:
- System/application clock domain (50-100MHz)
- Core clock domain (125MHz)
- Ethernet RGMII interface
- Application data interface

### Key Parameters
| Parameter      | Default Value           | Description               |
|----------------|-------------------------|---------------------------|
| `TARGET`       | "GENERIC"               | Target platform           |
| `LOCAL_IP`     | 192.168.1.128           | Local IP address          |
| `LOCAL_PORT`   | 1234                    | Listening port            |
| `DEST_IP`      | 192.168.1.129           | Destination IP            |
| `DEST_PORT`    | 5678                    | Destination port          |
| `DATA_W`       | 64                      | Application data width    |

### Ports
```verilog
module udp_top #(
    parameter TARGET     = "GENERIC",
    parameter LOCAL_IP   = {8'd192, 8'd168, 8'd1, 8'd128},
    parameter LOCAL_PORT = 16'd1234,
    parameter DEST_IP    = {8'd192, 8'd168, 8'd1, 8'd129},
    parameter DEST_PORT  = 16'd5678,
    parameter DATA_W     = 64
) (
    // System clock domain
    input  wire              sys_clk,
    input  wire              sys_rstn,
    
    // Application interface
    input  wire [DATA_W-1:0] din_data,
    input  wire              din_valid,
    input  wire              din_last,
    output wire              din_ready,
    output wire [DATA_W-1:0] dout_data,
    output wire              dout_valid,
    output wire              dout_last,
    input  wire              dout_ready,
    
    // Core clock domain (125MHz)
    input  wire              clk,
    input  wire              clk90,
    input  wire              rst,
    
    // Ethernet RGMII interface
    input  wire       phy_rx_clk,
    input  wire [3:0] phy_rxd,
    input  wire       phy_rx_ctl,
    output wire       phy_tx_clk,
    output wire [3:0] phy_txd,
    output wire       phy_tx_ctl,
    output wire       phy_reset_n
);
```

### Submodule Instantiation
1. **UDP Core** (`udp_core`):
   - Handles Ethernet PHY interface
   - Manages MAC/IP layer processing
   - Connects to TX/RX paths

2. **TX Path** (`udp_tx_path`):
   - Transmits application data to network
   - Converts wide data to byte stream
   - Generates UDP headers

3. **RX Path** (`udp_rx_path`):
   - Receives network data for application
   - Converts byte stream to wide data
   - Filters packets by IP/port

---

## udp_tx_path.v - UDP Transmit Path

### Overview
Converts application data (wide bus) to byte stream and transmits via UDP.

### Key Features
- Clock domain crossing (sys_clk → clk)
- Data width conversion (64-bit → 8-bit)
- UDP header generation
- FIFO buffering (8KB depth)

### State Machine (sys_clk domain)
```verilog
localparam TX_APP_IDLE = 3'd0;
localparam TX_APP_COUNT = 3'd1;
localparam TX_APP_DATA = 3'd2;
localparam TX_APP_FINISH = 3'd3;
```

### Data Flow
1. Application writes data (`din_data`) with handshake signals
2. State machine collects data into buffer
3. Data converted to byte stream
4. Bytes written to TX FIFO
5. Core clock domain FSM sends UDP header + payload

### Header Configuration
```verilog
assign tx_udp_ip_source_ip = local_ip;
assign tx_udp_ip_dest_ip = dest_ip;
assign tx_udp_source_port = local_port;
assign tx_udp_dest_port = dest_port;
assign tx_udp_length = tx_payload_len_reg + 8;  // UDP header length
```

---

## udp_rx_path.v - UDP Receive Path

### Overview
Receives UDP packets, filters by IP/port, and delivers to application.

### Key Features
- Clock domain crossing (clk → sys_clk)
- Data width conversion (8-bit → 64-bit)
- Packet filtering (IP/port matching)
- Metadata extraction (source IP/port)

### Packet Filtering
```verilog
wire packet_match = 
    (rx_udp_dest_port == local_port) && 
    (rx_udp_ip_source_ip == dest_ip) && 
    (rx_udp_source_port == dest_port);
```

### State Machine (sys_clk domain)
```verilog
localparam RX_APP_IDLE = 2'd0;
localparam RX_APP_COLLECT = 2'd1;
localparam RX_APP_OUTPUT = 2'd2;
```

### Data Flow
1. Incoming packets checked against filter
2. Valid payload written to RX FIFO
3. Metadata (source IP/port) stored in separate FIFO
4. Application reads assembled wide data (`dout_data`)

### FIFO Configuration
- **Payload FIFO**: 8KB depth, 8-bit → 64-bit conversion
- **Metadata FIFO**: 16 entry, stores {source IP, source port}

---

## Configuration Notes
- **Local MAC**: Hardcoded to `48'h02_00_00_00_00_00`
- **Gateway IP**: `192.168.1.1`
- **Subnet Mask**: `255.255.255.0`
- **UDP Checksum**: Disabled (set to 0)