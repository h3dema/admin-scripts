
#!/usr/bin/env bash

set -euo pipefail

# VirtualBox management script
# Usage: ./vbox.sh <command> [arguments]

SCRIPT_NAME=$(basename "$0")

# Check VBoxManage availability
if ! command -v VBoxManage >/dev/null 2>&1; then
    echo "Error: VBoxManage not found. Is VirtualBox installed?" >&2
    exit 1
fi

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME <command> [arguments]

Commands:
  list                         List all VMs
  running                      List running VMs
  reboot <vm>                  Force reboot a running VM
  off <vm>                     Force power off a running VM
  stop <vm>                    Gracefully stop a running VM
  start <vm>                   Start a VM if not running
  show <vm>                    Show basic VM information
  net <vm>                     Show IP addresses of all VM interfaces
  snap <vm>                    Take a timestamped snapshot
  snap-list <vm>               List all snapshots
  snap-delete <vm> <snap-name> Delete a snapshot

VM can be specified by name or UUID.
EOF
}

# Return the VM UUID from its name or UUID
get_vm_uuid() {
    local vm="$1"

    VBoxManage showvminfo "$vm" --machinereadable 2>/dev/null |
        sed -n 's/^UUID="\(.*\)"$/\1/p'
}

# Check if VM exists
check_vm() {
    local vm="$1"

    if ! get_vm_uuid "$vm" >/dev/null; then
        echo "Error: VM '$vm' not found." >&2
        exit 1
    fi
}

# Get VM state
get_state() {
    VBoxManage showvminfo "$1" --machinereadable |
        sed -n 's/^VMState="\([^"]*\)"$/\1/p'
}

# Check whether VM is running
is_running() {
    [[ "$(get_state "$1")" == "running" ]]
}

# List all VMs
cmd_list() {
    VBoxManage list vms
}

# List running VMs
cmd_running() {
    VBoxManage list runningvms
}

# Reboot VM (force reset)
cmd_reboot() {
    local vm="$1"
    check_vm "$vm"

    if is_running "$vm"; then
        echo "Force rebooting '$vm'..."
        VBoxManage controlvm "$vm" reset
    else
        echo "VM '$vm' is not running."
    fi
}

# Force power off VM
cmd_off() {
    local vm="$1"
    check_vm "$vm"

    if is_running "$vm"; then
        echo "Forcing power off '$vm'..."
        VBoxManage controlvm "$vm" poweroff
    else
        echo "VM '$vm' is not running."
    fi
}

# Gracefully stop VM (ACPI shutdown)
cmd_stop() {
    local vm="$1"
    check_vm "$vm"

    if is_running "$vm"; then
        echo "Requesting graceful shutdown of '$vm'..."
        VBoxManage controlvm "$vm" acpipowerbutton
    else
        echo "VM '$vm' is not running."
    fi
}

# Start VM
cmd_start() {
    local vm="$1"
    check_vm "$vm"

    if is_running "$vm"; then
        echo "VM '$vm' is already running."
    else
        echo "Starting '$vm'..."
        VBoxManage startvm "$vm" --type headless
    fi
}

# Show VM information
cmd_show() {
    local vm="$1"
    check_vm "$vm"

    VBoxManage showvminfo "$vm" --machinereadable |
        grep -E '^(name|UUID|ostype|memory|cpus|VMState|VMStateChangeTime|CfgFile|hardwareuuid|nic[0-9]+|macaddress[0-9]+|bridgeadapter[0-9]+|hostonlyadapter[0-9]+|natnet[0-9]+|SharedFolder)' |
        sed 's/=/ = /'
}

# Show IP addresses of all interfaces
cmd_net() {
    local vm="$1"
    check_vm "$vm"

    if ! is_running "$vm"; then
        echo "VM '$vm' is not running. IP information may be unavailable."
    fi

    VBoxManage guestproperty enumerate "$vm" --patterns '/VirtualBox/GuestInfo/Net/*' 2>/dev/null ||
        echo "Could not retrieve guest network information. Check that Guest Additions are installed and running."
}

# Take a timestamped snapshot
cmd_snap() {
    local vm="$1"
    check_vm "$vm"

    local timestamp
    timestamp=$(date '+%Y%m%d_%H%M%S')

    local snap_name="${vm}_${timestamp}"

    echo "Taking snapshot '$snap_name'..."
    VBoxManage snapshot "$vm" take "$snap_name"
}

# List snapshots
cmd_snap_list() {
    local vm="$1"
    check_vm "$vm"

    VBoxManage snapshot "$vm" list --machinereadable |
        sed -n 's/^SnapshotName-[^=]*="\(.*\)"$/\1/p'
}

# Delete snapshot
cmd_snap_delete() {
    local vm="$1"
    local snap_name="$2"

    check_vm "$vm"

    echo "Deleting snapshot '$snap_name'..."
    VBoxManage snapshot "$vm" delete "$snap_name"
}

# Main command dispatcher
main() {
    local cmd="${1:-}"

    case "$cmd" in
        list)
            [[ $# -eq 1 ]] || { usage; exit 1; }
            cmd_list
            ;;
        running)
            [[ $# -eq 1 ]] || { usage; exit 1; }
            cmd_running
            ;;
        reboot|off|stop|start|show|net|snap|snap-list)
            [[ $# -eq 2 ]] || { usage; exit 1; }

            case "$cmd" in
                reboot)    cmd_reboot "$2" ;;
                off)       cmd_off "$2" ;;
                stop)      cmd_stop "$2" ;;
                start)     cmd_start "$2" ;;
                show)      cmd_show "$2" ;;
                net)       cmd_net "$2" ;;
                snap)      cmd_snap "$2" ;;
                snap-list) cmd_snap_list "$2" ;;
            esac
            ;;
        snap-delete)
            [[ $# -eq 3 ]] || { usage; exit 1; }
            cmd_snap_delete "$2" "$3"
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

main "$@"
