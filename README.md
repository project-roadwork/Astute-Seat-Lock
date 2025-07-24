# Roadwork: Seat-Lock
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

![image](https://codeberg.org/project-roadwork/seat-lock/raw/branch/development/photos/Screenshot%202025-04-22%20201454.png)

Insert the script as a descendant the `VehicleSeat` of the vehicle. May be called "DriveSeat" or other names. The `VehicleSeat` must be parented under the vehicle.
Do not insert this script into A-Chassis plugins; it will not work.

---

![image](https://codeberg.org/project-roadwork/seat-lock/raw/branch/development/photos/Screenshot%202025-04-22%20201720.png)

Change the `GroupId` variable to your group/community ID. 
You can find this in your group link: `www.roblox.com/groups/YOURID` or `www.roblox.com/communities/YOURID`.

---

![image](https://codeberg.org/project-roadwork/seat-lock/raw/branch/development/photos/Screenshot%202025-04-22%20201751.png)

Modify the accompanying configuration to your liking. 

---


All the other information you need is in the script. If you are unable to set this up by yourself, you may use the sample in this repository. If you need additional help, you may join my [communications server](https://illinois-roadbuff.github.io/to/dis-primary).

## Showcase (all features) (outdated; v0.1.0-alpha.4)
[![YouTube](http://i.ytimg.com/vi/003UnVzvEI4/hqdefault.jpg)](https://www.youtube.com/watch?v=003UnVzvEI4)

---

## License
**Roadwork: Seat-Lock** is licensed under the **Apache License 2.0**. Hope you do cool stuff with it! 

### License Comparison (not legal advice)

| Feature / License        | Expact (aka "MIT")    | Apache 2.0 | MPL 2.0       | GPL / AGPL v3               |
| ------------------------ | ------ | ---------- | ------------- | ------------------------ |
| **Permissive**           | ✅      | ✅          | ℹ️ Partial    | ❌                        |
| **Patent Clause**         | ❌      | ✅          | ✅             | ✅                        |
| **Proprietary Use OK**   | ✅      | ✅          | ✅¹           | ❌  (Must release whole source)                       |
| **Roblox Asset Usage**   | ✅      | ✅          | ℹ️ Depends; must share any changes    | ❌ May violate terms      |

* ¹ Proprietary use in MPL is permitted (allowed) as long as the MPL-covered files remain open souce.
* (Opinion) I've seen multiple individuals license Roblox code under GPL / AGPL which honestly doesn't make sense to me in my opinion. Technically, the whole Roblox engine has to be "open-sourced" in order for the code to be used even though the place can be uncopylocked which doesn't make any sense at all.
* (Opinion) Why not MIT? Some developers may prefer a specific patent clause to protect from a patent lawsuit from contributors, which the MIT license doesn't provide. There is also a MIT-like license "BSD-3+Clause" which includes a patent clause. HOWEVER, this sparked legal issues and confusion when it was utilized in Facebook's react library. This is why I use the Apache License 2.0 for most of my low-end work.

---

**Second open-sourced asset!**
