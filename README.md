# Discord notification script for qBittorrent
This is a simple bash script for sending notifications to a Discord webhook for completed downloads from qBittorrent. Useful for those already using radarr, sonarr, readarr for downloading.

## Features
* Uses embed styling for a nicer look. Read more about Discord embeds [here](https://birdie0.github.io/discord-webhooks-guide/structure/embeds.html)
* Can be adapted to create different messages based on qBittorrent categories (optional).
* Easily expanded to capture other parameters from [qBittorrent.](https://github.com/qbittorrent/qBittorrent/wiki/External-programs:-How-to)
* Will automatically convert size from bytes to kB, MB or GB based on the size of the torrent. Useful if you are downloading shows, movies and books in various sizes. 
* Tested in qBittorrent for docker but should work in all versions.

<img src="/assets/radarr.png" width="50%">
<img src="/assets/readarr.png" width="50%">
<img src="/assets/4k.png" width="50%">

## Usage
1. Create a Discord webhook URL - [instructions](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
2. Download the bash script and make it available to qBittorrent. For docker instances, ensure it is placed in a mounted folder. Make it executable with `chmod +X /path/to/script/discord_qbit_notification.sh`. 
3. Input your Discord webhook URL at the top of the script.
4. Adapt the categories to align with your qBittorrent instance. For example, besides the usual sonarr, radarr categories, I have watch folders for manually adding torrents which I like to use for notifications.
5. You can test the script by running it in your terminal with some test parameters. For example: <code>bash /path/to/script/discord_qbit_notification.sh TestName 9999922 12 tracker.com radarr savepath</code>. If successful you should see confirmation in the terminal along with a discord notification.
6. Add the following to 'run external program on torrent completion' under your qBittorrent settings:
<code>/path/to/script/discord_qbit_notification.sh "%N" "%Z" "%C" "%T" "%L" "%D"</code>
***Note:*** The order of the parameters is important as they are captured accordingly in the script, make sure to edit accordingly if adapting the script for different parameters.
7. Done!

## Tip: adding categories to watched folders in qBittorrent (docker)
If you're using qBittorrent through [linuxserver's container](https://hub.docker.com/r/linuxserver/qbittorrent), the webUI doesn't surface a way to add categories to watched folders. To do this, you have to edit the `watched_folders.json` file located in the containers config folder. The path will be something like `containerConfig/qbittorrent/qBittorrent/watched_folders.json`. An example is provided in the repo.

## Using on Synology systems
See this [issue](https://github.com/uncapped1599/discord_qbittorrent/issues/1). The bc package is not included with Synology so you will have to adapt the script by removing the `bc` related functions or find ways to install bc via a package manager.
