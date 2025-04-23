# Astute Seat-Lock
**Lock seats in an A-Chassis vehicle to a specified group. Licensed under Apache-2.0 (open-source).**

**Features:**
* Customizeable
* Two types of detection methods which uses `SeatWelds` and the `.Occupant` property.
* Automatically deletes the `A-Chassis Interface` from the unauthorized user.
* Three methods of unauthorized handling: teleporting the user away from the vehicle, killing the user, and jumping the user away from the VehicleSeat.
* Double checks if the `A-Chassis Interface` *is* deleted.

**Internal Checks and Safeguards:**
* Protected call  (`pcall()`) usage
* GroupId validation
* Seat and script hierarchy checks
* Compatibility warnings

This *should* work with every A-Chassis vehicle which inserts an `A-Chassis Interface`.

All contributions are welcome!

## Installation

![image](https://codeberg.org/Astute-Corridor/Astute-Seat-Lock/raw/branch/development/photos/Screenshot%202025-04-22%20201454.png)

Insert the script as a descendant the `VehicleSeat` of the vehicle. May be called "DriveSeat" or other names. The `VehicleSeat` must be parented under the Vehicle.
Do not insert this script into A-Chassis plugins; it will not work.

---

![image](https://codeberg.org/Astute-Corridor/Astute-Seat-Lock/raw/branch/development/photos/Screenshot%202025-04-22%20201720.png)

Change the `GroupId` variable to your group/community ID. 
You can find this in your group link: `www.roblox.com/groups/YOURID` or `www.roblox.com/communities/YOURID`.

---

![image](https://codeberg.org/Astute-Corridor/Astute-Seat-Lock/raw/branch/development/photos/Screenshot%202025-04-22%20201751.png)

Modify the accompanying configuration to your liking. 

---


All the other information you need is in the script. If you are unable to set this up by yourself, you may use the sample in this repository. If you need additional help, you may join my [communications server](https://illinois-roadbuff.github.io/to/dis-primary).

## Showcase (all features) (outdated)
[![YouTube](http://i.ytimg.com/vi/003UnVzvEI4/hqdefault.jpg)](https://www.youtube.com/watch?v=003UnVzvEI4)

---

Second open-sourced asset!
