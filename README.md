# WiFiScanner
Sample application for probe request tracking.

Only tracks probe request for a specific SSID, ignoring the others.

## Requirements

* Linux or *BSD
* [Node.js](https://nodejs.org/)
* [MongoDB](https://www.mongodb.org/)
* [Bower](http://bower.io/) (for the client)
* [Grunt](http://gruntjs.com/) (for the client)

This is intended for running on a Linux installation with a WiFi adapter capable of running in [Monitor mode](https://wiki.wireshark.org/CaptureSetup/WLAN#Turning_on_monitor_mode)

## Components

It's composed of 2 parts:
* A [Node.js](https://nodejs.org/) backend doing the scanning, storing the data (on [MongoDB](https://www.mongodb.org/)), and providing REST services to access the data.
* An [AngularJS](https://angularjs.org/) client to present the data in a user friendly manner.

## Model

The model uses the following objects:

### MAC address

Represents the MAC address of the probe request origin. Example:
```
{
	mac: '00-00-00-00-00-00',
	vendor: 'Samsung',
	label: 'User defined label',
	ssidCount: 12
}
```
### SSID

Represents an SSID probed by a MAC address. Example:
```
'WiFi SSID'
```

### Session

Represents a capturing session. Example:
```
{
	number: 1,
	label: 'First session capturing from Home',
	from: '2015-04-11T14:00:00',
	to: '2015-04-11T15:00:00',
	latitude: '-34.00981',
	longitude: '30.88714'
}
```

## Server

### Running

1. Start MongoDB (/etc/init.d/mongodb start on most distributions)
2. Switch the adapter to Monitor mode. In this example using wlan0: 
```
ifconfig wlan0 stop
iwconfig wlan0 mode Monitor
ifconfig wlan0 start
```
3. On the server directory: `node server.js [your_adapter]`. For example: `node server.js wlan0`

### Services

#### Scan start/stop

* Start scanning for SSIDs: `GET http://localhost:3000/scan/ssid`
* Stop scanning: `GET http://localhost:3000/scan/stop`
* Get scanning status: `GET http://localhost:3000/scan`

#### SSIDs

* Get all captured SSIDs: `GET http://localhost:3000/ssid`
* Find MAC addresses probing for an SSID: `GET http://localhost:3000/ssid/[ssid_name]`

#### MAC addresses

* Get all captured MAC addresses: `GET http://localhost:3000/from`
* Get MAC address details (including vendor resolution): `GET http://localhost:3000/details/[from_mac_address]`
* Update MAC address details: `POST http://localhost:3000/details/[from_mac_address]`

Example:

`POST http://localhost:3000/details/00-00-00-00-00-01`

```
{
	label: 'Wifes cellphone'
}
```

#### Sessions

* Get all sessions: `GET http://localhost:3000/session`
* Get a specific session: `GET http://localhost:3000/session/[session_number]`
* Save a session: `POST http://localhost:3000/session/[session_number]`

Example:

`POST http://localhost:3000/session/1`

```
{
	label: 'First session capturing from Home',
	from: '2015-04-11T14:00:00',
	to: '2015-04-11T15:00:00',
	latitude: '-34.00981',
	longitude: '30.88714'
}
```