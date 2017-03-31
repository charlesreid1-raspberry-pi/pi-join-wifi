import subprocess
from subprocess import Popen, PIPE

wlan = "wlan0"

# wlan0 should show up as UP
subprocess.call(["ip","link","set",wlan,"up"])
subprocess.call(["ip","link","show",wlan])

# should say, not connected
subprocess.call(["iw",wlan,"link"])

# this is not working
#subprocess.call(["iw",wlan,"scan"])

# this will ask you for the passphrase,
# and add info and hash of password 
# in wpa_supplicant file
print("You should see the message \"Not connected\" above.")
print
print("Run the following command to connect to a wifi network:")
print
print(" ".join(["wpa_passphrase","SouthSeattle",">>","/etc/wpa_supplicant.conf"]))

