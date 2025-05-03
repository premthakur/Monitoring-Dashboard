readme.md


# System Resource Monitor (Enhanced)

## Overview
This script is a system resource monitor for Ubuntu that provides real-time information about CPU, memory, disk usage, network activity, and running services. It is designed to help users keep track of system performance and resource utilization.

## Features
- **Top 10 Applications by CPU and Memory**: Displays the top 10 processes consuming the most CPU and memory.
- **Network Monitoring**: Shows active connections, packet drops, and data received/sent.
- **Disk Usage**: Provides information on disk usage for all mounted filesystems.
- **System Load**: Displays the system load averages and CPU usage breakdown.
- **Memory Usage**: Shows total, used, and free memory, including swap memory.
- **Process Monitoring**: Lists the total number of active processes and the top 5 processes by CPU and memory usage.
- **Service Monitoring**: Checks the status of common services (ssh, nginx, apache2, iptables, ufw).

## Installation
1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Make the script executable**:
   ```bash
   chmod +x test-script/test.sh
   ```

## Usage
Run the script in the terminal:

### Command-Line Options
You can run the script with specific options to view particular information:
- `-cpu`: Display system load information.
- `-memory`: Show memory usage details.
- `-network`: Display network monitoring information.
- `-disk`: Show disk usage statistics.
- `-apps`: List the top 10 applications by CPU and memory usage.
- `-proc`: Display process monitoring information.
- `-services`: Check the status of specified services.
- `-all`: Show the full dashboard with all information.

### Example
To view the full dashboard, simply run:
```bash
./test-script/test.sh -all
```

## Refresh Interval
The dashboard refreshes every 10 seconds by default. You can modify the `INTERVAL` variable in the script to change this duration.

## Requirements
- This script is designed to run on Ubuntu and requires basic command-line tools such as `ps`, `netstat`, `df`, and `awk`.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- Inspired by various system monitoring tools and scripts available in the open-source community.
