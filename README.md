# BLEToolkit

A toolkit (Swift/iOS for now) to bootstrap building "account free" apps for interacting with BLE devices.

## Motivation

Many Bluetooth enabled devices: scales, multimeters, medical devices, use a smartphone as a display, to log data, or to connect to another (local) service such as Apple Health -- for most of these use cases there is no need for an account, but the apps that support the devices require that you create an account to use them. There too many privacy and security issues involved for this to be a good idea...

So, inspired by KrystianD's [bm2-battery-monitor][bm2] and olixdev's [openScale][openscale], I set out to build a set of tools to make it easier to create alternative apps for these devices -- and learn some new tricks along the way.

[bm2]: <https://github.com/KrystianD/bm2-battery-monitor>
[openscale]: <https://github.com/oliexdev/openScale>

##  Tools

* BLEScan: a macOS / iOS app to scan for BLE peripherals.
