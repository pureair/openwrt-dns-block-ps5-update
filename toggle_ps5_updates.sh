#!/bin/sh

# Configuration variables
PACKAGE="dhcp"
SECTION_REF="@dnsmasq[0]"
OPTION="address"

# Define hosts as a single, multi-line string.
HOSTS="
/dau01.ps5.update.playstation.net/
/dbr01.ps5.update.playstation.net/
/dcn01.ps5.update.playstation.net/
/deu01.ps5.update.playstation.net/
/dhk01.ps5.update.playstation.net/
/djp01.ps5.update.playstation.net/
/dkr01.ps5.update.playstation.net/
/dmx01.ps5.update.playstation.net/
/dru01.ps5.update.playstation.net/
/dsa01.ps5.update.playstation.net/
/dtw01.ps5.update.playstation.net/
/duk01.ps5.update.playstation.net/
/dus01.ps5.update.playstation.net/
/fau01.ps5.update.playstation.net/
/fbr01.ps5.update.playstation.net/
/fcn01.ps5.update.playstation.net/
/feu01.ps5.update.playstation.net/
/fhk01.ps5.update.playstation.net/
/fjp01.ps5.update.playstation.net/
/fkr01.ps5.update.playstation.net/
/fmx01.ps5.update.playstation.net/
/fru01.ps5.update.playstation.net/
/fsa01.ps5.update.playstation.net/
/ftw01.ps5.update.playstation.net/
/fuk01.ps5.update.playstation.net/
/fus01.ps5.update.playstation.net/
/hau01.ps5.update.playstation.net/
/hbr01.ps5.update.playstation.net/
/hcn01.ps5.update.playstation.net/
/heu01.ps5.update.playstation.net/
/hhk01.ps5.update.playstation.net/
/hjp01.ps5.update.playstation.net/
/hkr01.ps5.update.playstation.net/
/hmx01.ps5.update.playstation.net/
/hru01.ps5.update.playstation.net/
/hsa01.ps5.update.playstation.net/
/htw01.ps5.update.playstation.net/
/huk01.ps5.update.playstation.net/
/hus01.ps5.update.playstation.net/
/sgst.prod.dl.playstation.net/
/gs2.ww.prod.dl.playstation.net/
"

UCI_BASE_PATH="$PACKAGE.$SECTION_REF.$OPTION"

# Function to turn the block ON (Adds all list items)
turn_on() {
    echo "Enabling PS5 Update Blocking by adding list entries..."

    # 1. Clear ONLY the PS5-related entries first, to avoid duplicates.
    echo "Ensuring no duplicate entries exist (running OFF logic)..."
    echo "$HOSTS" | while read -r host; do
        if [ -n "$host" ]; then
            ARG="${UCI_BASE_PATH}=${host}"
            uci del_list "$ARG"
        fi
    done
    
    # 2. Add all the PS5 addresses back.
    echo "Adding all PS5 update addresses..."
    echo "$HOSTS" | while read -r host; do
        if [ -n "$host" ]; then
            ARG="${UCI_BASE_PATH}=${host}"
            uci add_list "$ARG"
        fi
    done
    
    uci commit "$PACKAGE"
    /etc/init.d/dnsmasq restart
    echo "PS5 Update Blocking is now ON."
    echo "Dnsmasq service restarted."
}

# Function to turn the block OFF (Safely removes only the PS5 addresses)
turn_off() {
    echo "Disabling PS5 Update Blocking by safely removing specific list entries..."
    
    # Iterate through our known PS5 hosts and remove them one-by-one.
    echo "$HOSTS" | while read -r host; do
        if [ -n "$host" ]; then
            ARG="${UCI_BASE_PATH}=${host}"
			uci del_list "$ARG"
        fi
    done

    uci commit "$PACKAGE"
    /etc/init.d/dnsmasq restart
    echo "PS5 Update Blocking is now OFF."
    echo "Dnsmasq service restarted. Other DNS addresses are preserved."
}

# Main script logic
case "$1" in
    on)
        turn_on
        ;;
    off)
        turn_off
        ;;
    *)
        echo "Usage: $0 {on|off}"
        exit 1
        ;;
esac
