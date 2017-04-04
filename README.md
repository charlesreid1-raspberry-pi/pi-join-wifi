# pi-join-wifi

Scripts to help Raspberry Pis join wifi networks.

## Simplest Possible Method

Should just be able to add the following lines to `/etc/network/interfaces`:

```
...

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid NetName
wpa-psk NetPassword
```

This will allow the Pi to connect to the wifi network automatically (on boot).
This can be manually added to the Pi for whichever network it is going to join.
Or...

## Scripted Method

The `/etc/network/interfaces` file can include the contents of other files.
From the contents of the interfaces manpage:

```
Lines beginning with "source" are used to include stanzas from other  files,  so
configuration can be split into many files. The word "source" is followed by the
path of file to be sourced. Shell wildcards can be used.   (See  wordexp(3)  for
details.)
```

So we can include or remove various wifi configurations
by including or removing a configuration file.
For example, for an open network like South Seattle,

```
source /etc/network/interfaces.d/southseattle.cf
```

where `southseattle.cf` contains the WPA ssid 
for the South Seattle wifi netowrk, 

```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid NetName
#wpa-psk 
```

Alternatively, for an encrypted network,

```
source /etc/network/interfaces.d/dropbear.cf
```

where `dropbear.cf` contains the WPA ssid and key 
for the dropbear wireless router:

```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid dropbear
wpa-psk abcdefg123
```


