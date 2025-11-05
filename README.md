# Block PS5 Updates on OpenWrt

This script configures your OpenWrt router to block PS5 system updates. You can easily turn the block on or off.

### Important Note

This script also **blocks game updates**. Generally, all blocks do.

If you need to update a game, you have to turn the block off first. Just run the script with the `off` command, update your game, and then run it with `on` again when you're done. That's why I made the script in the first place.

### How It Works

The script adds rules to your router's `dnsmasq` service.

When your PS5 tries to find Sony's update servers, the router tells it the domain doesn't exist, aka an `NXDOMAIN` response. This method is quick because the PS5 doesn't have to wait for a connection to time out.

### Before You Start

Make sure your PS5 is using your router for DNS. Go to your PS5's network settings and turn off any custom DNS servers. The DNS setting should be on automatic (which is the default).

### Usage

To turn the block on:
```
./toggle_ps5_updates.sh on
```

To turn the block off:
```
./toggle_ps5_updates.sh off
```

## Web UI

When the block is on, you will be able to see it in openwrt web UI, Network - DHCP/DNS - (first tab) - Address.
 
