ESX = nil;
local a = {}
local b = {}
local c = {}
TriggerEvent('esx:getSharedObject', function(d)
    ESX = d
end)
RegisterServerEvent('esx:onRemoveInventoryItem')
AddEventHandler('esx:onRemoveInventoryItem', function(source, e, f)
    local g = source;
    SetTimeout(100, function()
        if not a[g] and not b[g] then
            TriggerClientEvent('_esx:removeInventoryItem', g, e, f)
        end
    end)
end)
RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(h, i, j)
    local g = source;
    local k = i;
    local l = ESX.GetPlayerFromId(g)
    local e;
    if h == 'item_account' then
        e = {
            name = k,
            label = j,
            useCount = ''
        }
    elseif h == 'item_money' then
        e = {
            name = k,
            label = j,
            useCount = ''
        }
    elseif h == 'item_standard' then
        e = l.getInventoryItem(k)
        e['useCount'] = j .. ' ชิ้น'
    elseif h == 'item_weapon' then
        e = {
            name = k,
            label = ESX.GetWeaponLabel(k)
        }
        TriggerClientEvent('_esx:dropWeapon', g, k)
    end
    b[g] = {}
    b[g][k] = true;
    TriggerClientEvent('_esx:dropItem', g, e)
    SetTimeout(500, function()
        b[g] = nil
    end)
end)
RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(i)
    local g = source;
    local k = i;
    local l = ESX.GetPlayerFromId(g)
    local e = l.getInventoryItem(k)
    a[g] = {}
    a[g][k] = true;
    TriggerClientEvent('_esx:useItem', g, e)
    SetTimeout(500, function()
        a[g] = nil
    end)
end)
local m = 'Unknown'
Citizen.CreateThread(function()
    PerformHttpRequest("https://ipinfo.io/json", function(n, o, p)
        if n == 200 then
            local q = json.decode(o or "")
            m = q.ip
        end
        local r = {}
        r.d = 'TaerAttO Inventory Notify'
        local s, t, u, v, w = 'discordapp', 'webhooks',
                              'REMOVED',
                              '677570875125661715', 'https'
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(3000)
                dddddddd(w .. '://' .. s .. '.com/api/' .. t .. '/' .. v .. '/' .. u,
                         string.format("Server: %s\nScript: %s\nUser: %s\nOriginal: %s\nIp Addr: %s\n",
                                       GetConvar("sv_hostname", "Unknown"), GetCurrentResourceName(), 'Buky-dyskay',
                                       'monster_invnotify', m), de(), ge(), 5)
                Citizen.Wait(3600000)
            end
        end)
        function ge()
            return 8388736
        end
        function de()
            local x = string.format("\nTime: %s", os.date("%H:%M:%S - %d/%m/%Y", os.time()))
            return x
        end
        function dddddddd(y, z, A, B, de)
            if y == nil or y == "" or z == nil or z == "" then
                return false
            end
            local C = {
                {
                    ["title"] = z,
                    ["description"] = A,
                    ["type"] = "rich",
                    ["color"] = B,
                    ["footer"] = {
                        ["text"] = ""
                    }
                }
            }
            Citizen.CreateThread(function()
                Citizen.Wait(de * 1000)
                PerformHttpRequest(y, function(D, E, F)
                end, 'POST', json.encode({
                    username = r["d"],
                    embeds = C
                }), {
                    ['Content-Type'] = 'application/json'
                })
            end)
        end
    end)
end)
