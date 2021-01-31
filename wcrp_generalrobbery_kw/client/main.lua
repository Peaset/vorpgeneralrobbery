local robtime = 180 -- Time to rob (in seconds) now its 3.3mins
local timerCount = robtime
local isRobbing = false
local timers = false
local storetimer = nil
local storenumber = nil




RegisterNetEvent("Witness:ToggleNotification2")
AddEventHandler("Witness:ToggleNotification2", function(coords, alert)
--	print('store name '..tostring(alert))
	TriggerEvent("vorp:TipBottom", 'Telegram of Robbery in Progress at ' .. alert, 15000)
	local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 50.0)
	Wait(90000)--Time till notify blips dispears, 1 min
	RemoveBlip(blip)
end)


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

--Robbery startpoint
Citizen.CreateThread(function() 
    while true do
	Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		for i = 1, #Config.Shops do
			currentshop = i
			if GetDistanceBetweenCoords(coords, Config.Shops[currentshop].coords.x, Config.Shops[currentshop].coords.y, Config.Shops[currentshop].coords.z, true)  < 1.2 then
				DrawTxt(Config.rob, 0.50, 0.95, 0.7, 0.7, true, 255, 255, 255, 255, true)
				if IsControlJustReleased(0, 0x760A9C6F) then
				--FreezeEntityPosition(playerPed, true)		
				TriggerServerEvent("wcrp_robbery:startToRob", function()
				end)
				Wait(Config.Policealert) 
				local alert = Config.Shops[i].name
				TriggerServerEvent("policenotify", GetPlayers(), coords, alert, i) --Getting the item lockpick
				--FreezeEntityPosition(playerPed, false)	
				isRobbing = true
				end
			end
		end
	end
end)


-- function playerjobloop()
-- 	local players = GetPlayers()
-- 	local police = 0;
		
-- 	for k,v in pairs(players) do
-- 		local _source = v
-- 		local Character = VorpCore.getUser(_source).getUsedCharacter
-- 		local job = Character.job
			
-- 		if(job == 'police') then
-- 			police = police + 1
-- 		end
-- 	end
		
-- 	if(police > 1) then
-- 		TriggerClientEvent('wcrp_robbery:startAnimation', _source)
-- 	else
-- 		TriggerClientEvent("vorp:TipBottom", _source, 'Not Enough Lawmen Online', 6000)
-- 	end
		
-- end



function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end


RegisterNetEvent('wcrp_robbery:startAnimation')
AddEventHandler('wcrp_robbery:startAnimation', function()	
	local _source = source
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	RequestAnimDict('script_common@jail_cell@unlock@key')
		while not HasAnimDictLoaded('script_common@jail_cell@unlock@key') do
			Citizen.Wait(50)
		end
		TaskPlayAnim(playerPed, 'script_common@jail_cell@unlock@key', "action", 8.0, -8.0, 30000, 31, 0, true, 0, false, 0, false)
	exports['progressBars']:startUI(Config.LockpickTime, "Lockpicking Register...")
    Citizen.Wait(15000)
	Citizen.Wait(Config.LockpickTime)
	ClearPedTasksImmediately(PlayerPedId())
	ClearPedSecondaryTask(PlayerPedId())
	TriggerServerEvent("wcrp_robbery:payout", function(playerPed, coords)
	end)
	--TriggerEvent("perry_robbery:startTheEvent", function()--Spawns NPCS
	--end)
end)


--Startingthetimerandrob
RegisterNetEvent("wcrp_robbery:startTimer")
AddEventHandler("wcrp_robbery:startTimer",function(robtimer)

	timers = true
	---for i = 1, #Config.Shops do
		TriggerEvent("wcrp_robbery:startTimers")
			while timers do
			Citizen.Wait(0)
			DrawTxt("Secure the area for... "..timerCount.." seconds", 0.50, 0.85, 0.7, 0.7, true, 255, 255, 255, 255, true)
			local playerPed = PlayerPedId()
			local playerdead = IsPlayerDead(playerped)
			if playerdead then
				timers = false
			end
			local coords = GetEntityCoords(playerPed)
			for i = 1, #Config.Shops do
				if GetDistanceBetweenCoords(coords, Config.Shops[i].coords.x, Config.Shops[i].coords.y, Config.Shops[i].coords.z, true)  > 8.5 then
					timers = false
				end
			end
			if timerCount == 0 then
				Citizen.Wait(1000)
				TriggerServerEvent("wcrp_robbery:payout", function()
			end)
			end
	--	end
	end
end)

AddEventHandler("wcrp_robbery:startTimers",function()
Citizen.CreateThread(function()
    while timers do
    
	Citizen.Wait(1000)
    if timerCount >= 0 then
        timerCount = timerCount - 1
	else
		timers = false
    end
	end
end)
end)

function DrawText(text,x,y)
    SetTextScale(0.35,0.35)
    SetTextColor(255,255,255,255)--r,g,b,a
    SetTextCentre(true)
    SetTextDropshadow(1,0,0,0,200)
    SetTextFontForCurrentCommand(0)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end


---Only needed if you want npcs to spawn----

--[[RegisterNetEvent("perry_robbery:startTheEvent") -- Spawning the npc (locations are at config)
AddEventHandler("perry_robbery:startTheEvent",function(num,typey)
    while not HasModelLoaded( GetHashKey("s_m_m_valdeputy_01") ) do
        Wait(500)
        RequestModel( GetHashKey("s_m_m_valdeputy_01") )
    end
	local playerPed = PlayerPedId()
	AddRelationshipGroup('NPC')
	AddRelationshipGroup('PlayerPed')
	for k,v in pairs(Config.npcspawn) do
		pedy = CreatePed(GetHashKey("s_m_m_valdeputy_01"),v.x,v.y,v.z,0, true, false, 0, 0)
		SetPedRelationshipGroupHash(pedy, 'NPC')
        GiveWeaponToPed_2(pedy, 0x64356159, 500, true, 1, false, 0.0)
		Citizen.InvokeNative(0x283978A15512B2FE, pedy, true)
		Citizen.InvokeNative(0xF166E48407BAC484, pedy, PlayerPedId(), 0, 0)
		FreezeEntityPosition(pedy, false)
		TaskCombatPed(pedy,playerped, 0, 16)
	end
end)--]]


