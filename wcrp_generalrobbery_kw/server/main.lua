VORP = exports.vorp_inventory:vorp_inventoryApi()

data = {}
TriggerEvent("vorp_inventory:getData",function(call)
    data = call
end)

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Locations = {
    vector3(-324.26, 804.1, 117.93),
    vector3(2828.26, -1320.1, 46.8),
    vector3(-785.47, -1323.85, 43.9),
    vector3(-1789.34, -387.5, 160.37),
    vector3(-3687.2, -2622.31, -13.3), 
    vector3(-5486.33, -2937.6, -0.35),
    vector3(1328.03, -1293.70,  77.07),

}

RegisterNetEvent("wcrp_robbery:startToRob")
AddEventHandler("wcrp_robbery:startToRob", function(robtimer)
    local _source = source
    local Character = VorpCore.getUser(source).getUsedCharacter
    local count = VORP.getItemCount(_source, "lockpick")

    if count >= 1 then
      --  playerjobloop()
        VORP.subItem(_source,"lockpick", 1)
        TriggerClientEvent('wcrp_robbery:startAnimation', _source)
        Wait(Config.LockpickTime)
        TriggerClientEvent("vorp:TipBottom", _source, "You have successfully lockpicked the register", 6000)
        --TriggerEvent("wcrp_robbery:payout")
       -- print('current timer for shop is: '..tostring(robtimer))
       -- TriggerClientEvent('wcrp_robbery:startTimer', _source, robtimer)
    else
        TriggerClientEvent("vorp:TipBottom", _source, "You dont have a lockpick", 6000)
    end     
end)





RegisterNetEvent("wcrp_robbery:payout")
AddEventHandler("wcrp_robbery:payout", function()
    TriggerEvent('vorp:getCharacter', source, function(user)
        local _source = source
        local _user = user
        randommoney = math.random(50,250)
        ritem = math.random(1,5)
        local randomitempull = math.random(1, #Config.Items)
        local itemName = Config.Items[randomitempull]
      --  print('items randomlly pulled : '..randommoney)
      --  print('items being given : '..itemName)
           TriggerEvent("vorp:addMoney", _source, 0, randommoney, _user)
           VORP.addItem(_source, itemName, ritem)
    end)
        TriggerClientEvent("vorp:TipBottom", _source, 'You got $ '.. tostring(randommoney) .. ' and some items', 5000)
end)



RegisterNetEvent("policenotify")
AddEventHandler("policenotify", function(players, coords, alert)
    local Character = VorpCore.getUser(source).getUsedCharacter
    for each, player in ipairs(players) do
        if Character ~= nil then
			if Character.job == 'police' or Character.job == 'marshal' or Character.job == 'sheriff' then
				TriggerClientEvent("Witness:ToggleNotification2", player, coords, alert)
			end
        end
    end
end)


            
      

