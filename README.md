# pi-join-wifi

Scripts to help Raspberry Pis join wifi networks.

## JoinWifi

This joins a wifi network for the first time, and runs wpa-supplicant to put the passphrase hash into a file for later use.

## WPA Supplicant

To connect to a WPA wireless network from Linux, according to [raspberrypi.org](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md):

### Get Network Details

Use `wpa_passphrase` command to turn pass phrase into key to put into a file:

```
$ wpa_passphrase "test network name" "testingPassword

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
