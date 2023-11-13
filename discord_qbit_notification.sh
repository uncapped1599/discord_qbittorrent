#!/bin/bash

# Discord webhook details
discord_webhook_url="https://discord.com/api/webhooks/XXXXXXXXXXXX"  # Update with your Discord webhook URL

# Get variables from qBitTorrent. Remember to make sure these align with your qBittorrent variables passed in settings.
torrent_name="$1"
size="$2"
files="$3"
tracker="$4"
category="$5"
path="$6"

# Function to convert size from bytes to megabytes (MB)
calculate_size_in_mb() {
    size_in_mb=$(bc <<< "scale=2; $size / (1024 * 1024)")
    echo "$size_in_mb MB"
}

# Function to convert size from bytes to gigabytes (GB)
calculate_size_in_gb() {
    size_in_gb=$(bc <<< "scale=2; $size / (1024 * 1024 * 1024)")
    echo "$size_in_gb GB"
}

# Function to convert size from bytes to kilobytes (KB)
calculate_size_in_kb() {
    size_in_kb=$(bc <<< "scale=2; $size / 1024")
    echo "$size_in_kb KB"
}

# Determine download type based on the category. 
# This is optional, only if you want to change the notification message based on the category. 
# You can also comment out this entire section and simply use $category in the 'title' field of the payload below.
case "$category" in
    "sonarr")
        download_type="Sonarr"
        ;;
    "readarr")
        download_type="Readarr"
        ;;
    "radarr")
        download_type="Radarr"
        ;;
    "4K movies")
        download_type="4K Movie"
        ;;
    "movies")
        download_type="Watch Movie"
        ;;
    "tv")
        download_type="Watch TV Show"
        ;;
    "alternative")
        download_type="Alt"
        ;;
    "books")
        download_type="Book"
        ;;
    *)
        download_type="Uncategorised"
        ;;
esac

# Calculate the size message based on the size in megabytes, kilobytes, or gigabytes
if (( size < 1024 * 1024 )); then
    size_message=$(calculate_size_in_kb)
elif (( size < 1024 * 1024 * 1024 )); then
    size_message=$(calculate_size_in_mb)
else
    size_message=$(calculate_size_in_gb)
fi

# Construct the JSON payload for Discord
# You can change the color of the left hand stripe of the notification using the "color" field. 
payload='{
    "embeds": [
        {
            "author": {
                "name": "qBittorrent",
                "icon_url": "https://i.imgur.com/6LTKLgZ.jpg"
            },
            "title": "'$download_type' download completed",
            "color": 7506394,
            "fields": [
                {
                    "name": "Torrent",
                    "value": "'$torrent_name'"
                },
                {
                    "name": "Size",
                    "value": "'$size_message'",
                    "inline": true
                },
                {
                    "name": "Files",
                    "value": "'$files'",
                    "inline": true
                },
                {
                    "name": "Tracker",
                    "value": "'$tracker'"
                },
                {
                    "name": "Save Path",
                    "value": "'$path'"
                }
            ]
        }
    ]
}'

# Function to send a notification to Discord
send_discord_notification() {
    curl -H "Content-Type: application/json" -X POST -d "$payload" "$discord_webhook_url" >/dev/null 2>&1
}

# Send a notification to Discord
send_discord_notification

# Print an info message in the console
echo "[$torrent_name] ${download_type} completed. Discord notification sent."
