--!native
--!strict

-- ** THIS IS A SAMPLE AND MAY NOT BE UP TO DATE **

--[[-[Astute-Seat-Lock-Standalone-Edition]-------------------------------------
  FILE:             Astute-Seat-Lock-SE.luau
  DESCRIPTION:      Open-sourced script to lock seats in an A-Chassis vehicle to
                    a specified group. Use the accompanying repository links for 
                    documentation, help, or to propose a suggestion or comment.
					The NOTICE file can be found in the respository links.
  USAGE:            ./Astute-Seat-Lock-SE.luau
  LANGUAGE:         Luau
  
  AUTHOR:           Illinois_Roadbuff and the Astute-Corridor Contributors
  VERSION:          0.2.0-alpha.1
  CREATED:          2024-9-16 8:56 PM CDT  
  LAST UPDATED:     2025-4-22 8:35 PM CDT  
  LICENSE:          Apache-2.0

  CODEBERG REPO:    https://codeberg.org/Astute-Corridor/Astute-Seat-Lock/
  GITHUB REPO:      https://github.com/Astute-Corridor/Astute-Seat-Lock/ (DEPRECATED)
-----------------------------------------------------------------------------------]]  

--[[-[Apache-2.0 License Header]------------------------------------------------
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.   ]]---------------------------------------------------------

--[[-[INSTALLATION]--------------------------------------------------------
  Place this script under the VehicleSeat and set your GroupID down below.
-------------------------------------------------------------------------]]

--[[-[IMPORTANT]---------------------------------------------------------------
 If you wish to update this script, read the documentation, require assistance, 
 view the source files, view the LICENSE or NOTICE files, wish to 
 improve/contribute (pull request) to the project, post a comment, etc.,
 please refer to the accompanying repository links!
------------------------------------------------------------------------------]]

local VehicleSeat:VehicleSeat? = script:FindFirstAncestorWhichIsA("VehicleSeat")
local Car = nil
local Players:Players = game.GetService(game, "Players") :: Players -- This is faster than game:GetService()

-- // Core Configuration

local GroupID = 0 -- **(IMPORTANT) ENTER GROUP ID HERE** 
-- You can find this in your group link: www.roblox.com/groups/YOURID or www.roblox.com/communities/YOURID.
-- Example: local GroupID = 33088243

--// Detection Configuration

-- Detection Settings: Having both of these off will disable the script. Choose one or enable both.
local OccupantDetection = true -- Using VehicleSeat.Occupant
local SeatWeldDetection = true -- Using VehicleSeat.ChildAdded and checks if the child is named "SeatWeld"

-- Debug Settings
local LogInConsole = true -- Example: Player tried to drive an ISP car!
local ErrorInConsole = true -- Logs errors from protected calls (pcall). Recommended to keep this true.

-- Unauthorized Handling
local MoveAway = true -- Teleports the player away from the accompanying car
local MoveAwayDistance = 30 -- Distance between the player and the car in studs
local JumpPower = 200 -- Jump power when unauthorized
local KillPlayer = true -- Kills player if unauthorized

--// Advanced Settings 
local Enabled = true -- Self explanitory; whether the script should be used or not.

local warn, print = warn, print -- Kept if one uses an alternative debugger rather than the luau method.

-- (Not recommended to modify)
local GUIWaitTime = 0.2 -- The wait time to check if the A-Chassis Interface is in the PlayerGui
local GUIWaitTimeForDoubeCheck = 2 -- The wait time to double check if the A-Chassis Interface is in the PlayerGui
local DelayTime = 0.02 -- Delay time after detection

-- // Other Information
local version = "v0.2.0-alpha.1"

if Enabled then
 -- // Prerequisites; checking
	if not VehicleSeat then
		warn(`:: Astute-Seat-Lock, {version} :: Aborting; Is the VehicleSeat parent set?`)
		return
	end
	if not VehicleSeat.Parent then
		warn(`:: Astute-Seat-Lock, {version} :: Aborting; Is the VehicleSeat parented under a model?`)
		return
	else
		Car = VehicleSeat.Parent
	end 
	if typeof(GroupID) ~= "number" or GroupID <= 0 then
		warn(`:: Astute-Seat-Lock, {version} :: Aborting; Did you forget to add a group ID? Is the GroupID a positive integer? Is the GroupId an integer at all?`)
		return
	end
	if (not VehicleSeat:IsA("VehicleSeat") and not VehicleSeat:IsA("Seat")) then
		warn(`:: Astute-Seat-Lock, {version} :: Aborting; Is the script placed under a VehicleSeat or an ordinary seat?`)
		return
	end
	if VehicleSeat:IsA("Seat") and (LogInConsole or ErrorInConsole) then
		warn(`:: Astute-Seat-Lock, {version} :: WARNING - Ordinary seats are NOT fully compatible with this script. Use with caution!`)
	end
-- // Init
	if OccupantDetection or SeatWeldDetection then
		local function MoveRootPart(HumanoidRootPart: BasePart)
			local Success:boolean, Response: string? = pcall(function()
				if MoveAway and HumanoidRootPart then
					HumanoidRootPart.CFrame *= CFrame.new(MoveAwayDistance, MoveAwayDistance, MoveAwayDistance)
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`:: Astute-Seat-Lock, {version} :: An error occurred in MoveRootPart: {Response}`)
			end
		end

		local function DestroyInterface(Player:Player)
			local Success, Response: string? = pcall(function()
				local PlayerGui:PlayerGui? = Player:WaitForChild("PlayerGui", 1) :: PlayerGui?
				if PlayerGui then
					local Interface:ScreenGui? = PlayerGui:WaitForChild("A-Chassis Interface", 1) :: ScreenGui | nil
					if Interface and Interface:IsA("ScreenGui") then
						if LogInConsole then
							print(`:: Astute-Seat-Lock, {version} :: Destroyed UI from {Player.Name}`)
						end
						Interface:Destroy()
					end
					task.wait(GUIWaitTime)
					if Interface and Interface:IsA("ScreenGui") then
						if LogInConsole then
							print(`:: Astute-Seat-Lock, {version} :: (Double Check) Destroyed UI from {Player.Name}`)
						end
						Interface:Destroy()
					end
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`:: Astute-Seat-Lock, {version} :: An error occurred in DestroyInterface: {Response}`)
			end
		end

		local function DestroyWeld(VehicleSeat:VehicleSeat)
			local Success, Response: string? = pcall(function()
				local SeatWeld = VehicleSeat:FindFirstChild("SeatWeld")
				if SeatWeld:IsA("Weld") and SeatWeld.Part1 and SeatWeld.Part1.Parent:FindFirstChildOfClass("Humanoid") then 
					SeatWeld:Destroy()
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`:: Astute-Seat-Lock, {version} :: An error occurred in DestroyWeld: {Response}`)
			end
		end

		if SeatWeldDetection then
			VehicleSeat.ChildAdded:Connect(function(child)
				local Success, Response: string? = pcall(function()
					if child:IsA("Weld") and child.Name == "SeatWeld" then
						local Character = child.Part1.Parent
						local Humanoid:Humanoid = Character.Humanoid
						local Player = Players:GetPlayerFromCharacter(Character)
						if Player then
							local Success, Authorized: string? | boolean? = pcall(Player.IsInGroup, Player, GroupID) 
							if Success then
								if not Authorized then
									task.spawn(DestroyInterface, Player)
									if LogInConsole and Car then
										warn(`:: Astute-Seat-Lock, {version} :: {Player.Name} tried to drive {Car.Name}! (SeatWeld)`)
									end
									child:Destroy()
									task.wait(DelayTime)
									Humanoid.JumpPower += JumpPower
									Humanoid.Jump = true
									Humanoid.JumpPower -= JumpPower
									if KillPlayer then Humanoid.Health = 0 end
									MoveRootPart(Character.HumanoidRootPart)
								end
							else
								task.spawn(DestroyInterface, Player)
								if ErrorInConsole and Authorized then
									warn(`:: Astute-Seat-Lock, {version} :: An error occured while checking GroupID! Error: {Authorized}`) -- Error response if no success
								end 
								child:Destroy()
								task.wait(DelayTime)
								Humanoid.JumpPower += JumpPower
								Humanoid.Jump = true
								Humanoid.JumpPower -= JumpPower
								if KillPlayer then Humanoid.Health = 0 end
								MoveRootPart(Character.HumanoidRootPart)
							end
						end
					end
				end) :: boolean, type(string)
				if not Success and Response and ErrorInConsole then
					warn(`:: Astute-Seat-Lock, {version} :: An error occurred in SeatWeld detection: {Response}`)
				end
			end)
		end

		if OccupantDetection then
			VehicleSeat:GetPropertyChangedSignal("Occupant"):Connect(function()
				local Success, Response: string? = pcall(function()
					if VehicleSeat.Occupant then -- It would only be a Humanoid or nil, but we are already checking if it exists.
						local Humanoid = VehicleSeat.Occupant
						local Character = VehicleSeat.Occupant.Parent
						local Player = Players:GetPlayerFromCharacter(Character)
						if Player then
							local Sucess, Authorized: string? | boolean? = pcall(Player.IsInGroup, Player, GroupID)
							if Sucess then
								if not Authorized then
									if LogInConsole and Car then
										warn(`:: Astute-Seat-Lock, {version} :: {Player.Name} tried to drive {Car.Name}! (Occupant)`)
									end
									task.spawn(DestroyInterface, Player)
									task.spawn(DestroyWeld, VehicleSeat)
									task.wait(DelayTime)
									Humanoid.JumpPower += JumpPower
									Humanoid.Jump = true
									Humanoid.JumpPower -= JumpPower
									if KillPlayer then Humanoid.Health = 0 end
									MoveRootPart(Character.HumanoidRootPart)
								end
							else
								if ErrorInConsole and Authorized then
									warn(`:: Astute-Seat-Lock, {version} :: An error occured while checking GroupID! Error: {Authorized}`)-- Error response if no success
								end 
								task.spawn(DestroyInterface, Player)
								task.spawn(DestroyWeld, VehicleSeat)
								task.wait(DelayTime)
								Humanoid.JumpPower += JumpPower
								Humanoid.Jump = true
								Humanoid.JumpPower -= JumpPower
								if KillPlayer then Humanoid.Health = 0 end
								MoveRootPart(Character.HumanoidRootPart)
							end
						end
					end
				end) :: boolean, type(string)
				if not Success and Response and ErrorInConsole then
					warn(`:: Astute-Seat-Lock, {version} :: An error occurred in Occupant detection: {Response}`)
				end
			end)
		end
	end
else
	script.Enabled = false
end

