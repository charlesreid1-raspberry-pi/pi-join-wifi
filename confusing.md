
## Arch Wiki

### Add Network Manually

Create a minimal configuration file in `/etc/wpa_supplicant/example.conf`:

```
ctrl_interface=/run/wpa_supplicant
update_config=1
```

Then run `wpa_supplicant`:

```
$ wpa_supplicant -B -i interface -c /etc/wpa_supplicant/example.conf
```

Now run the wpa command line interface:

```
$ wpa_cli
```

This has its own shell/prompt. Use `scan` to run a scan, 
and `scan_results` to display the result.

```
> scan
> scan_results
```

To add a network, use `add_network`.

```
> add_network
0
> set_network 0 ssid "MYSSID"
> set_network 0 psk "passphrase"
> enable_network 0
```

Save config to `wpa_suppliant` file (why we needed to give permission to change configuration file):

```
> save_config
```

Lastly, obtain an IP address:

```
$ dhcpcd wlan0
```

### Add Network From Command Line

To set up a network without joining it live,
use `wpa_passphrase` to turn a passphrase into a hash.

```
$ wpa_passphrase MYSSID passphrase

network={
    ssid="MYSSID"
    #psk="passphrase"
    psk=59e0d07fa4c7741797a4e394f38a5c321e3bed51d54ad5fcbd3f84bc7415d73d
}
```

Rather than copying and pasting this manually, 
we can pipe the result of the command to `wpa_supplicant` directly:

```
wpa_supplicant -B -i interface -c <(wpa_passphrase MYSSID passphrase)
```

Note, this puts your passphrase into your shell history.

(This does not work. Error about network interface, 
something about drivers not supporting join network function.)




## JoinWifi

This joins a wifi network for the first time, and runs wpa-supplicant to put the passphrase hash into a file for later use.

## WPA Supplicant

To connect to a WPA wireless network from Linux, according to [raspberrypi.org](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md):

### Get Network Details

Use `wpa_passphrase` command to turn pass phrase into key to put into a file:

```
$ wpa_passphrase "test network name" "testingPassword"

network={
  ssid="test network name"
  #psk="testingPassword"
  psk=131e1e221f6e06e3911a2d11ff2fac9182665c004de85300f9cac208a6a80531
}
```

Remove commented line with plain text password.

Alternatively, if your password is in a file,

```plain
wpa_passphrase "test network name" << file_where_password_is_stored
```

### Adding Network Details to Pi

You can dump the output of the `wpa_passphrase` above to the `wpa_supplicant.conf` file:

```plain
wpa_passphrase "testing" "testingPassword" >> /etc/wpa_supplicant/wpa_supplicant.conf
```

Restart WPA with 

```plain
sudo wpa_cli reconfigure
```

### Unsecured Networks

If the network you are connecting to does not use a password, 
include the correct `key_mgmt` entry:

```plain
network={
    ssid="testing"
    key_mgmt=NONE
}
```



## Charlesreid1 method 

To connect to a wireless network according to [the charlesreid1.com wiki](https://charlesreid1.com/wiki/Linux/Wireless):

First add network configuration to `/etc/wpa_supplicant/wpa_supplicant.conf`:

```plain
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="Your SSID Here"
    proto=RSN
    key_mgmt=WPA-PSK
    pairwise=CCMP TKIP
    group=CCMP TKIP
    psk="YourPresharedKeyHere"
}
```

Next edit /etc/network/interfaces and modify the wlan0 entry.

If you have a static IP: 

```plain
# ------ Static IP --------
###allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet static
    address 10.1.2.20
    netmask 255.255.255.0
    network 10.1.2.0
    gateway 10.1.2.1
```

If you have an automatically-assigned IP from the DHCP controller:

```plain
# ------- DHCP ------------
###allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp
```

Now bring the wireless card down and back up:

```plain
ifdown wlan0
ifup wlan0
```

You should see the wireless network you specified in your wpa supplicant file when you run iwconfig:

```plain
iwconfig
```

You should also see an IP address when you run ifconfig:

```plain
ifconfig
```

To start wpa_supplicant manually:

```plain
# sudo /sbin/wpa_supplicant -P /var/run/wpa_supplicant.wlan0.pid -i wlan0 \
			-D nl80211,wext -c /etc/wpa_supplicant/wpa_supplicant.conf
```
