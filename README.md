# OpenWRT-PowerDNS-Updater

* This placed script which can to update your OpenWRT dynamic public IP address on your PowerDNS servers

## Dependencies on openwrt hosts

* You can see all installed packages on developer device from where that gets follow by [link!](https://github.com/westsouthnight/openwrt-powerdns-updater/blob/master/installed.md)


# Install steps

## OpenWRT shell steps, first:

* Place script to some dir, as example /wrk/scripts/, and set executable bit
* Fill your settings to script
* Install necessary OpenWRT packages by run opkg-update then opkg install {{ missed_packages }}
* Configure your DDNS service to use that script by OpenWRT WebUI.


## OpenWRT configuration step by step with images, second:

* You can see configuration on developer device from where that gets follow by [link!](https://github.com/westsouthnight/openwrt-powerdns-updater/blob/master/router_ui.md)

