require "table"
require "string"
require "math"
require "lib/lib_MapMarker"
require "lib/lib_InterfaceOptions"

--[[
Medic! Addon for Firefall by weableandbob

Version History:

Version 1:
Initial Release

Version 1.2:
*Fixed some really terrible grammar
*Moved enable button
*Added option for health on text notification
*Included a suggested addition to prevent freezing if the player is not fully loaded yet
*Added option for displaying the name of the person in need on the marker

Version 1.3:
*Fixed the bug where markers were getting stuck (I believe)
--]]

--Variables

addonEnabled = true
healDuration = 10
reviveDuration = 10
healEnabled = true
reviveEnabled = true
onlyHealOnBio = true
onlyReviveOnBio = false
markerName = true
textNotification = true
textHealth = true
maxDistance = 100
healColor = {alpha=1, tint="33CC00"}
reviveColor = {alpha=1, tint="CC0022"}

--Interface Stuff

InterfaceOptions.StartGroup({id="Options", label="Addon Options"})
InterfaceOptions.AddCheckBox({id="Enabled", label="Enable Addon", default=true})
InterfaceOptions.AddSlider({id="HealDuration", label="Duration of Heal Marker", default=10, min=1, max=30, inc=1, suffix="s"})
InterfaceOptions.AddSlider({id="ReviveDuration", label="Duration of Revive Marker", default=10, min=1, max=30, inc=1, suffix="s"})
InterfaceOptions.AddCheckBox({id="HealEnabled", label="Enable Heal Marker", tooltip="Determines whether a marker is displayed when someone calls for healing.", default=true})
InterfaceOptions.AddCheckBox({id="BioOnlyHeal", label="Notify For Heal Only When Possible", tooltip="When checked, makes it so that you only get heal notifications when you have something capable of healing them with", default=true})
InterfaceOptions.AddCheckBox({id="ReviveEnabled", label="Enable Revive Marker", tooltip="Determines whether a marker is displayed when someone calls for a revive.", default=true})
InterfaceOptions.AddCheckBox({id="BioOnlyRevive", label="Notify For Revive Only On Biotech", tooltip="When checked, makes it so that you only get revive notifications when you're playing Biotech", default=false})
InterfaceOptions.AddCheckBox({id="AddNameToMarker", label="Add Name To Marker", tooltip="When checked, makes the person in need's name appear on the marker", default=true})
InterfaceOptions.AddCheckBox({id="TextNotificationEnabled", label="Enable Text Notification", tooltip="When enabled, displays the person in need and what they need in chat.", default=true})
InterfaceOptions.AddCheckBox({id="TextNotificationHealth", label="Display Health In Text Notifications", tooltip="When enabled, health and percent health are displayed with the text notification", default=true})
InterfaceOptions.AddSlider({id="MaxDistance", label="Max Distance", tooltip="Adjusts the maximum distance someone can be from you and still provide a notification",default=100, min=10, max=250, inc=5, suffix="m"})
InterfaceOptions.StopGroup()

function OnComponentLoad()
	InterfaceOptions.SetCallbackFunc(function(id,val)
		OnOptionCallback({type = id, data = val})
	end, "Medic!");
end

--Options

function OnOptionCallback(args)
	local id = args.type
	local val = args.data
	if id == "Enabled" then
		addonEnabled = val
	end
	if id == "HealDuration" then
		healDuration = val
	end
	if id == "ReviveDuration" then
		reviveDuration = val
	end
	if id == "HealEnabled" then
		healEnabled = val
	end
	if id == "ReviveEnabled" then
		reviveEnabled = val
	end
	if id == "TextNotificationEnabled" then
		textNotification = val
	end
	if id == "TextNotificationHealth" then
		textHealth = val
	end
	if id == "MaxDistance" then
		maxDistance = val
	end
	if id == "BioOnlyHeal" then
		onlyHealOnBio = val
	end
	if id == "BioOnlyRevive" then
		onlyReviveOnBio = val
	end
	if id == "AddNameToMarker" then
		markerName = val
	end
end

--Logic

function OnFriendlyDistress(args)
	--args.need = "health" or something else
	--args.entityId = number
	--args.distance	
	if addonEnabled and Player.IsReady() then
		name = Game.GetTargetInfo(args.entityId).name
		distance = args.distance
		if distance <= maxDistance then
			if tostring(args.need) == "health" then
				if healEnabled then
					if onlyHealOnBio == false or onlyHealOnBio == true and canHeal() then
						local marker = MapMarker.Create()
						marker:BindToEntity(args.entityId, 100)
						if markerName then
							marker:SetTitle("Healing Needed - "..name)
						else
							marker:SetTitle("Healing Needed")
						end
						if textNotification then
							Component.GenerateEvent("MY_SYSTEM_MESSAGE", {text=tostring(name).." needs healing!"})
							if textHealth then
								Component.GenerateEvent("MY_SYSTEM_MESSAGE", {text=Game.GetTargetVitals(args.entityId).Health.." health"})
							end
						end
						marker:ShowOnHud(true)
						marker:ShowTrail(true)
						marker:SetThemeColor(healColor)
						--marker:GetIcon():SetTexture(healIcon)
						callback(function() marker:Destroy() end, nil, healDuration)	
					end
				end
			else
				if reviveEnabled then
					if onlyReviveOnBio == false or onlyReviveOnBio == true and isBio() then
						local marker = MapMarker.Create()
						marker:BindToEntity(args.entityId, 100)
						if markerName then
							marker:SetTitle("Revive Needed - "..name)
						else
							marker:SetTitle("Revive Needed")
						end
						if textNotification then
							Component.GenerateEvent("MY_SYSTEM_MESSAGE", {text=tostring(name).." needs a revive!"})
						end
						marker:ShowOnHud(true)
						marker:ShowTrail(true)
						marker:SetThemeColor(reviveColor)
						callback(function() marker:Destroy() end, nil, reviveDuration)
					end
				end
			end
		end
	end
end

--Determines if the player wants to receive messages

function isBio()
	if tostring(Player.GetCurrentArchtype()) == "medic" then
		return true
	else
		return false
	end
end

function canHeal()
	--This is used so that the addon doesn't freak out if the player has empty ability slots
	if 1 <= #Player.GetAbilities().slotted then
		a1 = Player.GetAbilities().slotted[1].abilityId
	end
	if 2 <= #Player.GetAbilities().slotted then
		a2 = Player.GetAbilities().slotted[2].abilityId
	end
	if 3 <= #Player.GetAbilities().slotted then
		a3 = Player.GetAbilities().slotted[3].abilityId
	end
	if 4 <= #Player.GetAbilities().slotted then
		a4 = Player.GetAbilities().slotted[4].abilityId
	end
	weapon = Player.GetWeaponInfo().WeaponType
	
	if weapon == "BioRifle" then
		return true
	elseif a1 == 35040 or a1 == 34832 or a1 == 31366 or a1 == 34928 or a1 == 35565 then
		return true
	elseif a2 == 35040 or a2 == 34832 or a2 == 31366 or a2 == 34928 or a2 == 35565 then
		return true
	elseif a3 == 35040 or a3 == 34832 or a3 == 31366 or a3 == 34928 or a3 == 35565 then
		return true
	elseif a4 == 35040 or a4 == 34832 or a4 == 31366 or a4 == 34928 or a4 == 35565 then
		return true
	else
		return false
	end
end

--[[
Healing Ability and Weapon IDs
BioRifle: BioRifle
Healing Pillar: 35040
Healing Ball: 34832
Healing Wave: 31366
Healing Dome: 34928
Accord Chemical Sprayer: 35565
--]]