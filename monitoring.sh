#!/bin/bash
 
# ---------------- COLORS --------------------------------------
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; CYAN='\033[1;36m'; NC='\033[0m'; BOLD='\033[1m'

INTERVAL=10

 

header() {
  # header "🔥  TOP 10 APPLICATIONS"
  echo -e "${CYAN}"
  echo "──────────────────────────────────────────────────────────────"
  echo -e "${BOLD}$1${NC}"
  echo "──────────────────────────────────────────────────────────────"
}

# 1. Top 10 Applications by CPU and Memory
top_apps() {
  header "🔥  TOP 10 APPLICATIONS (CPU & MEM)"
  printf "${BLUE}%-6s %-22s %-10s %-10s${NC}\n" "PID" "Command" "%CPU" "%MEM"
  echo "──────────────────────────────────────────────────────────────"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | tail -n +2 | head -n 10 |
    awk '{printf "%-6s %-22s %-9s %-9s\n", $1,$2,$3"%",$4"%"}'
  echo
}

# 2. Network Monitoring
network_monitor() {
  local conn=$(netstat -ntu | tail -n +3 | wc -l)
  local inb=$(awk '/:/ {s+=$2} END{printf"%.2f",s/1024/1024}' /proc/net/dev)
  local outb=$(awk '/:/ {s+=$10} END{printf"%.2f",s/1024/1024}' /proc/net/dev)
  local drops=$(netstat -s | grep -i dropped | awk '{d+=$1} END{print d+0}')

  header "📡  NETWORK MONITORING"
  printf "  • Active Connections : %-6s   • Packet Drops : %-6s\n" "$conn" "$drops"
  printf "  • Data Received      : %-8s MB • Data Sent     : %-8s MB\n" "$inb" "$outb"
  echo
}

# 3. Disk Usage
disk_usage() {
  header "💾  DISK USAGE"
  printf "${BLUE}%-18s %-8s %-15s${NC}\n" "Filesystem" "Usage" "Mount"
  echo "──────────────────────────────────────────────────────────────"
  df -h --output=source,pcent,target | tail -n +2 | while read fs pc mt; do
    use=${pc%\%}; clr=$NC; [ $use -ge 80 ] && clr=$RED
    printf "%-18s ${clr}%-8s${NC} %-15s\n" "$fs" "$pc" "$mt"
  done
  echo
}

# 4. System Load
system_load() {
  header "⚙️   SYSTEM LOAD"
  local load=$(uptime | awk -F'load average: ' '{print $2}')
  local cpu=$(top -bn1 | grep '%Cpu(s)')
  printf "  • Load Avg (1/5/15 min) : %s\n" "$load"
  printf "  • %s User  %s System  %s Idle\n" \
     "$(echo $cpu | awk '{print $2"%"}')" \
     "$(echo $cpu | awk '{print $4"%"}')" \
     "$(echo $cpu | awk '{print $8"%"}')"
  echo
}

# 5. Memory Usage
memory_usage() {
  header "🧠  MEMORY USAGE"
  read -r t u f < <(free -m | awk '/^Mem:/ {print $2,$3,$4}')
  read -r st su sf < <(free -m | awk '/^Swap:/ {print $2,$3,$4}')
  printf "  • Total : %-6sMB  Used : %-6sMB  Free : %-6sMB\n" "$t" "$u" "$f"
  printf "  • Swap  : %-6sMB  Used : %-6sMB  Free : %-6sMB\n" "$st" "$su" "$sf"
  echo
}

# 6. Process Monitoring
process_monitoring() {
  header "🔍  PROCESS MONITORING"
  local total=$(ps -e --no-headers | wc -l)
  echo "  • Total Active Processes : $total"
  echo
  echo "  Top 5 by CPU:"
  ps -eo comm,%cpu --sort=-%cpu | head -n 6 |
    awk '{printf "    %-20s %6s%%\n",$1,$2}'
  echo
  echo "  Top 5 by MEM:"
  ps -eo comm,%mem --sort=-%mem | head -n 6 |
    awk '{printf "    %-20s %6s%%\n",$1,$2}'
  echo
}

# 7. Service Monitoring
service_monitoring() {
  header "🔐  SERVICE MONITORING"
  for s in ssh nginx apache2 iptables ufw; do
    if systemctl is-active --quiet "$s"; then
      echo -e "  • $s : ${GREEN}RUNNING${NC}"
    else
      echo -e "  • $s : ${RED}STOPPED${NC}"
    fi
  done
  echo
}

# -------------------- DASHBOARD -------------------------------
full_dashboard() {
   
  top_apps
  network_monitor
  disk_usage
  system_load
  memory_usage
  process_monitoring
  service_monitoring
  echo -e "${CYAN}──────────────────────────────────────────────────────────────${NC}"
  echo -e "   Press ${CYAN}CTRL-C${NC} to exit | Refreshing every ${CYAN}${INTERVAL}s${NC}"
  echo -e "${CYAN}──────────────────────────────────────────────────────────────${NC}"
}

# -------------------- ARGUMENTS --------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
    -cpu)      system_load;         exit ;;
    -memory)   memory_usage;        exit ;;
    -network)  network_monitor;     exit ;;
    -disk)     disk_usage;          exit ;;
    -apps)    top_apps;            exit ;;
    -proc)     process_monitoring;  exit ;;
    -services) service_monitoring;  exit ;;
    -all)     full_dashboard;              exit ;;
    *) echo "Invalid option: $1"; exit 1 ;;
  esac
done

# default loop
while true; do full_dashboard; sleep $INTERVAL; done
