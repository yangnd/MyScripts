echo "Power Cycle Count:"
smartctl -A -d sat /dev/sda | grep Power_Cycle_Count | awk '{print $10}'
