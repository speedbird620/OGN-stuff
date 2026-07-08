#!/bin/bash

# Function to clear screen and display the menu
show_menu() {
    clear
    echo "=================================================="
    echo "            OGN RECEIVER - UTILITY MENU           "
    echo "=================================================="
    echo "1) View OverlayFS status"
    echo "2) Enable OverlayFS (Safe/Read-only mode)"
    echo "3) Disable OverlayFS (Write/Modification mode)"
    echo "--------------------------------------------------"
    echo "4) Telnet to port 50000 (Console)"
    echo "5) Telnet to port 50001 (Data stream)"
    echo "--------------------------------------------------"
    echo "6) Start OGN service"
    echo "7) Stop OGN service"
    echo "8) Restart OGN service"
    echo "--------------------------------------------------"
    echo "9) Run GSM scan"
    echo "10) Edit configuration file (OGN-receiver.conf)"
    echo "--------------------------------------------------"
    echo "0) Exit"
    echo "=================================================="
    echo -n "Select an option [0-10]: "
}

# Main loop
while true; do
    show_menu
    read -r choice

    case $choice in
        1)
            echo -e "\n--- OverlayFS Status ---"
            sudo overlayctl status
            ;;
        2)
            echo -e "\n--- Enabling OverlayFS ---"
            sudo overlayctl enable
            ;;
        3)
            echo -e "\n--- Disabling OverlayFS ---"
            sudo overlayctl disable
            ;;
        4)
            echo -e "\n--- Connecting to Telnet localhost 50000 ---"
            echo "Tip: Press 'Ctrl + ]' and type 'quit' to exit telnet."
            telnet localhost 50000
            ;;
        5)
            echo -e "\n--- Connecting to Telnet localhost 50001 ---"
            echo "Tip: Press 'Ctrl + ]' and type 'quit' to exit telnet."
            telnet localhost 50001
            ;;
        6)
            echo -e "\n--- Starting rtlsdr-ogn service ---"
            sudo service rtlsdr-ogn start
            ;;
        7)
            echo -e "\n--- Stopping rtlsdr-ogn service ---"
            sudo service rtlsdr-ogn stop
            ;;
        8)
            echo -e "\n--- Restarting rtlsdr-ogn service ---"
            sudo service rtlsdr-ogn restart
            ;;	
	    9)
            echo -e "\n--- GSM Scan Configuration ---"

            # Input for PPM
            echo -n "Enter Tuner crystal correction in PPM [Default: 50]: "
            read -r user_ppm
            if [ -z "$user_ppm" ]; then
                user_ppm=50
            fi

            # Input for Gain
            echo -e "\nSupported gains (dB) based on your hardware:"
            echo "0.0 0.9 1.4 2.7 3.7 7.7 8.7 12.5 14.4 15.7 16.6 19.7 20.7 22.9 25.4 28.0 29.7 32.8 33.8 36.4 37.2 38.6 40.2 42.1 43.4 43.9 44.5 48.0 49.6"
            echo -n "Enter Tuner gain in dB [Default: 20]: "
            read -r user_gain
            if [ -z "$user_gain" ]; then
                user_gain=20
            fi

            echo -e "\n--- Running GSM Scan (PPM: $user_ppm, Gain: $user_gain) ---"

            # Determine correct path and run scan
            if [ -f "./rtlsdr-ogn/gsm_scan" ]; then
                ./rtlsdr-ogn/gsm_scan --ppm "$user_ppm" --gain "$user_gain"
            elif [ -f "$HOME/rtlsdr-ogn/gsm_scan" ]; then
                $HOME/rtlsdr-ogn/gsm_scan --ppm "$user_ppm" --gain "$user_gain"
            else
                echo "Error: Could not find gsm_scan in ./rtlsdr-ogn/ or $HOME/rtlsdr-ogn/"
            fi
            ;;
        10)
            echo -e "\n--- Opening boot configuration file ---"
            sudo nano /boot/OGN-receiver.conf
            ;;
        0)
            echo -e "\nExiting menu. Goodbye!"
            exit 0
            ;;
        *)
            echo -e "\nInvalid option, please try again."
            ;;
    esac

    echo -e "\nPress [Enter] to return to the menu..."
    read -r
done		
			