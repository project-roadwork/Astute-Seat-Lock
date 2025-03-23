--!native
--!strict

--[[-[AC-GroupSeatLock]-----------------------------------------------------------
  FILE:             AC-GroupSeatLock.luau
  DESCRIPTION:      Lock seats in an A-Chassis vehicle to a specified group.
  USAGE:            ./AC-GroupSeatLock.luau
  LANGUAGE:         Luau
  
  AUTHOR:           Illinois_Roadbuff
  VERSION:          0.1.0-alpha.3
  CREATED:          2024-9-16 8:56 PM CDT  
  LAST UPDATED:     2025-3-23 4:40 PM CDT  
  LICENSE:          MIT License

  GITHUB REPO:      https://github.com/illinois-roadbuff/AC-GroupSeatLock
------------------------------------------------------------------------------]]  

--[[-[INSTALLATION]--------------------------------------------------------
  Place this script under the VehicleSeat and set your GroupID down below.
-------------------------------------------------------------------------]]

local VehicleSeat:VehicleSeat = script.Parent
local Car = VehicleSeat.Parent
local Players:Players = game.GetService(game, "Players") :: Players

-- // Core Configuration

local GroupID = 2561922 -- **(IMPORTANT) ENTER GROUP ID HERE**
-- Example: local GroupID = 00000000
local Enabled = true
local UseNewDetection = true

--// New Detection Configuration

-- Detection Settings: Having both of these off will disable the script. Choose one or enable both.
local OccupantDetection = true -- Using VehicleSeat.Occupant
local SeatWeldDetection = true -- Using VehicleSeat.ChildAdded and checks if the child is named "SeatWeld"

-- Debug Settings
local LogInConsole = true -- Example: Player tried to drive an ISP car!
local ErrorInConsole = true -- Logs errors from protected calls (pcall).

-- Unauthorized Handling
local MoveAway = true -- Teleports the player away from the accompanying car
local MoveAwayDistance = 30 -- Distance between the player and the car in studs
local JumpPower = 200 -- Jump power when unauthorized
local KillPlayer = true -- Kills player if unauthorized

--// Advanced Settings 

-- (Not recommended to modify)
local GUIWaitTime = 0.2 -- The wait time to check if the A-Chassis Interface is in the PlayerGui
local GUIWaitTimeForDoubeCheck = 2 -- The wait time to double check if the A-Chassis Interface is in the PlayerGui
local DelayTime = 0.02 -- Delay time after detection

if Enabled then
	if not Car and ErrorInConsole then
		warn(": GroupSeatLock : Is the VehicleSeat parent set?")
		return
	end
	if not GroupID and ErrorInConsole then
		warn(": GroupSeatLock : Aborting; Did you forget to add a group ID?")
		return
	end
	if UseNewDetection and (OccupantDetection or SeatWeldDetection) then
		local function MoveRootPart(HumanoidRootPart: BasePart)
			local Success:boolean, Response: string | nil = pcall(function()
				if MoveAway and HumanoidRootPart then
					HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(MoveAwayDistance, MoveAwayDistance, MoveAwayDistance)
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`: GroupSeatLock : An error occurred in MoveRootPart: {Response}`)
			end
		end

		local function DestroyInterface(Player:Player)
			local Success, Response: string | nil = pcall(function()
				local PlayerGui:PlayerGui? = Player:FindFirstChildOfClass("PlayerGui")
				if PlayerGui then
					task.wait(GUIWaitTime)
					local Interface:ScreenGui? = PlayerGui:FindFirstChild("A-Chassis Interface") :: ScreenGui | nil
					if Interface then
						if LogInConsole then
							print(`: GroupSeatLock : Destroyed UI from {Player.Name}`)
						end
						Interface:Destroy()
					end

					task.wait(GUIWaitTime)

					if Interface then
						if LogInConsole then
							print(`: GroupSeatLock : (Double Check) Destroyed UI from {Player.Name}`)
						end
						Interface:Destroy()
					end
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`: GroupSeatLock : An error occurred in DestroyInterface: {Response}`)
			end
		end

		local function DestroyWeld(VehicleSeat:VehicleSeat)
			local Success, Response: string | nil = pcall(function()
				local SeatWeld = VehicleSeat:FindFirstChild("SeatWeld")
				if SeatWeld:IsA("Weld") and SeatWeld.Part1 and SeatWeld.Part1.Parent:FindFirstChild("Humanoid") then 
					SeatWeld:Destroy()
				end
			end) :: boolean, type(string)
			if not Success and Response and ErrorInConsole then
				warn(`: GroupSeatLock : An error occurred in DestroyWeld: {Response}`)
			end
		end

		if SeatWeldDetection then
			VehicleSeat.ChildAdded:Connect(function(child)
				local Success, Response: string | nil = pcall(function()
					if child.Name == "SeatWeld" then
						local Character = child.Part1.Parent
						local Player = Players:GetPlayerFromCharacter(Character)
						if Player then
							local Sucess, Authorized: string? = pcall(Player.IsInGroup, Player, GroupID) :: boolean, type(string)
							if Sucess then
								if not Authorized then
									task.spawn(DestroyInterface, Player)
									if LogInConsole and Car then
										warn(`: GroupSeatLock : {Player.Name} tried to drive {Car.Name}! (SeatWeld)`)
									end
									child:Destroy()
									task.wait(DelayTime)
									Character.Humanoid.JumpPower += JumpPower
									Character.Humanoid.Jump = true
									Character.Humanoid.JumpPower -= JumpPower
									if KillPlayer then Character.Humanoid.Health = 0 end
									MoveRootPart(Character.HumanoidRootPart)
								end
							else
								task.spawn(DestroyInterface, Player)
								if ErrorInConsole and Authorized then
									warn(`: GroupSeatLock : An error occured while checking GroupID! Error: {Authorized}`) -- Error response if no success
								end 
								child:Destroy()
								task.wait(DelayTime)
								Character.Humanoid.JumpPower += JumpPower
								Character.Humanoid.Jump = true
								Character.Humanoid.JumpPower -= JumpPower
								if KillPlayer then Character.Humanoid.Health = 0 end
								MoveRootPart(Character.HumanoidRootPart)
							end
						end
					end
				end) :: boolean, type(string)
				if not Success and Response and ErrorInConsole then
					warn(`An error occurred in SeatWeld detection: {Response}`)
				end
			end)
		end

		if OccupantDetection then
			VehicleSeat:GetPropertyChangedSignal("Occupant"):Connect(function()
				local Success, Response: string? = pcall(function()
					if VehicleSeat.Occupant and VehicleSeat.Occupant:IsA("Humanoid") then
						local Humanoid = VehicleSeat.Occupant
						local Character = VehicleSeat.Occupant.Parent
						local Player = Players:GetPlayerFromCharacter(Character)
						if Player then
							local Sucess, Authorized: string? = pcall(Player.IsInGroup, Player, GroupID)
							if Sucess then
								if not Authorized then
									if LogInConsole and Car then
										warn(`: GroupSeatLock : {Player.Name} tried to drive {Car.Name}! (Occupant)`)
									end
									task.spawn(DestroyInterface, Player)
									task.spawn(DestroyWeld, VehicleSeat)
									task.wait(DelayTime)
									Humanoid.JumpPower += JumpPower
									Character.Humanoid.Jump = true
									Humanoid.JumpPower -= JumpPower
									if KillPlayer then Character.Humanoid.Health = 0 end
									MoveRootPart(Character.HumanoidRootPart)
								end
							else
								if ErrorInConsole and Authorized then
									warn(`: GroupSeatLock : An error occured while checking GroupID! Error: {Authorized}`)-- Error response if no success
								end 
								task.spawn(DestroyInterface, Player)
								task.spawn(DestroyWeld, VehicleSeat)
								task.wait(DelayTime)
								Humanoid.JumpPower += JumpPower
								Character.Humanoid.Jump = true
								Humanoid.JumpPower -= JumpPower
								if KillPlayer then Character.Humanoid.Health = 0 end
								MoveRootPart(Character.HumanoidRootPart)
							end
						end
					end
				end) :: boolean, type(string)
				if not Success and Response and ErrorInConsole then
					warn(`: GroupSeatLock : An error occurred in Occupant detection: {Response}`)
				end
			end)
		end
	elseif not UseNewDetection then
		VehicleSeat.ChildAdded:Connect(function(child)
			if child.Name == "SeatWeld" then
				if GroupID and not Players:GetPlayerFromCharacter(child.Part1.Parent):IsInGroup(GroupID) then
					child:Destroy()
					child.Part1.Parent.Humanoid.Jump = true
				end
			end
		end)
	end
else
	script.Enabled = false
end
