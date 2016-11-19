wifi设置
---

## 热点

* /etc/hostapd/hostapd.conf 
```
ssid=my-ssid
utf8_ssid=1
wpa_passphrase=change-me
interface=wlp3s0
bridge=br0
auth_algs=3
channel=7
driver=nl80211
hw_mode=g
logger_stdout=-1
logger_stdout_level=2
max_num_sta=5
rsn_pairwise=CCMP
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
```

```
sudo pacman -S iw hostapd
iw list #无线网卡必须支持AP模式

ip link set dev wlp3s0 up
sudo systemctl start hostapd
sudo systemctl status hostapd
```


## 最简单的
* [create_ap](https://github.com/oblique/create_ap)
