pimatic-owfs
===============

pimatic plugin to interface with the 1-Wire File System (OWFS).

You will need to have installed [OWFS](owfs.org). On a Raspberry Pi running the Raspbian distribution, OWFS can be installed using:
```bash
sudo apt-get install owfs ow-shell
```

You then need to start `owserver`, the OWFS server. The configuration of `owserver` depends on your 1-wire bus master device, check the [documentation](http://owfs.org/index.php?page=owserver) relevant to your device. 

You can list the 1-wire devices detected on the bus by running `owdir`.  


### Supported values:

* `"sensorPath"`: OWFS path to the 1-wire sensor.
* `"name"`: sensor name.
* `"unit"`: measurement unit.
* `"acronym"`: Acronym to show as value label in the frontend.
* `"label"`: A custom label to use in the frontend.

### Example:

```json
"plugins": [
  { 
    "plugin": "owfs"
  }
],
"devices": [
{
  "class": "OwfsSensor",
  "id": "my-onewire-sensor",
  "name": "One-wire sensors",
  "host": "10.168.5.1",
  "port": 4304,
  "attributes": [
    {
      "name": "Temperature 1",
      "sensorPath": "/10.2F8B71020800/temperature",
      "unit": "°C",
      "acronym": "T1",
      "label": "Temperature OWFS"
    },
    {
      "name": "Temperature 2",
      "sensorPath": "/28.4196F3010000/fasttemp",
      "unit": "°C",
      "acronym": "T2",
      "label": "Temperature with fasttemp"
    }
  ]
}
```
