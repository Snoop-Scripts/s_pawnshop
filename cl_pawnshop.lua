-- Koordinaatit
local kaupat = {
    { paikat = vec3(-326.2589, 6228.7666, 31.5015) }, --Pohjoinen
    { paikat = vec3(556.2896, 2674.0056, 42.1706) }, --Keskimaa
    { paikat = vec3(-1459.3010, -413.6412, 35.7444) }, --Lakitoimisto
    { paikat = vec3(412.1036, 315.1672, 103.1327) }, --Ruletti
    { paikat = vec3(182.2303, -1319.0579, 29.3159) } --Tori bensis
}

-- Kellon aika milloin auki
local aukeaa = 8  -- Aukioloaika alkaa klo 8
local sulkeutuu = 21 -- Aukioloaika päättyy klo 18

-- Blipin tiedot
local blipSprite = 59
local blipColour = 5
local blipScale = 0.8
local blipName = 'Panttilainaamo'

-- Ox target
local matka = 1.0
local alueet = false --debug
local avaa = 'Avaa panttilainaamo'
local fasfa = 'fas fa-shop'

-- Ox inputDialog
local kauppa_icon = 'shop'
local numero_icon = 'hashtag'
local nimike = 'Panttilainaamo'

-- Pelaajan ostettavat tavarat
local ostan = {
    --bread = { nimi = 'Leipä', hinta = 69 },
    --water = { nimi = 'Vesi', hinta = 69 }
}

-- Pelaajan myytävät tavarat
local myyn = {
    --bread = { nimi = 'Leipä', hinta = 69 },
    --water = { nimi = 'Vesi', hinta = 69 }
}

-------------------------
-- # PANTTILAINAAMO # --
-------------------------
for _, kauppa in ipairs(kaupat) do
    exports.ox_target:addBoxZone({
        coords = kauppa.paikat,
        debug = alueet,
        options = {
            {
                distance = matka,
                icon = fasfa,
                label = avaa,
                onSelect = function(data)
                    if not isKauppaAuki() then
                        notify('Kauppa ei ole auki. Aukioloajat: '..aukeaa..' - '..sulkeutuu..' päivällä')
                        return
                    end

                    local input = lib.inputDialog(nimike, {
                        {
                            type = 'select',
                            label = 'Mikä oli mielessä?',
                            required = true,
                            icon = kuvake,
                            clearable = true,
                            options = {
                                { label = 'Osta tavaroita', value = 'osta' },
                                { label = 'Myy tavaroita', value = 'myy' },
                            }
                        }
                    })
                
                    if not input then
                        notify('Poistuit valikosta')
                        return false
                    end
                    
                    if input[1] == 'osta' then
                        osta()
                    elseif input[1] == 'myy' then
                        myy()
                    end
                end,
            }
        }
    })
end


--------------
-- # OSTA # --
--------------
function osta()
    local vaihtoehdot = {}

    for avain, tuote in pairs(ostan) do
        table.insert(vaihtoehdot, { label = tuote.nimi .. ' - ' .. tuote.hinta .. '$', value = avain })
    end

    local input = lib.inputDialog('Panttilainaamo', {
        {
            type = 'select',
            label = 'Mitä haluaisit ostaa?',
            required = true,
            icon = kauppa_icon,
            clearable = true,
            options = vaihtoehdot
        },
        {
            type = 'number',
            label = 'Kuinka monta haluat ostaa?',
            required = true,
            icon = numero_icon,
            value = '1',
            min = 1,
            max = 100
        }
    })

    if not input then
        notify('Poistuit valikosta')
        return false
    end

    local valittuTuote = ostan[input[1]]

    if valittuTuote then
        TriggerServerEvent('s_pawnshop_osta', input[1], valittuTuote.hinta, tonumber(input[2]))
    else
        notify('Virheellinen tuotevalinta')
    end
end




-------------
-- # MYY # --
-------------
function myy()
    local vaihtoehdot = {}

    for avain, tuote in pairs(myyn) do
        table.insert(vaihtoehdot, { label = tuote.nimi .. ' - ' .. tuote.hinta .. '$', value = avain })
    end

    local input = lib.inputDialog('Panttilainaamo', {
        {
            type = 'select',
            label = 'Mitä haluaisit myydä?',
            required = true,
            icon = kuvake,
            clearable = true,
            options = vaihtoehdot
        }
    })

    if not input then
        notify('Poistuit valikosta')
        return false
    end

    local valittuTuote = myyn[input[1]]

    if valittuTuote then
        TriggerServerEvent('s_pawnshop_myy', input[1], valittuTuote.hinta)
    else
        notify('Virheellinen tuotevalinta')
    end
end

--------------------
-- # LUO BLIPIT # --
--------------------
for _, kauppa in ipairs(kaupat) do
    Citizen.CreateThread(function()
        local blip = AddBlipForCoord(kauppa.paikat)

        SetBlipSprite(blip, blipSprite)
        SetBlipColour(blip, blipColour)
        SetBlipScale(blip, blipScale)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(blipName)
        EndTextCommandSetBlipName(blip)
    end)
end

----------------------
-- # LUO MARKERIT # --
----------------------
for _, kauppa in ipairs(kaupat) do
    CreateThread(function()
        while true do
            Wait(50)
            local pelaajaPed = PlayerPedId()
            pelaajaCoords = GetEntityCoords(pelaajaPed)
            local etaisyys = #(pelaajaCoords - kauppa.paikat)

            if etaisyys <= 5.0 then
                DrawMarker(2, kauppa.paikat.x, kauppa.paikat.y, kauppa.paikat.z + 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0.1, 0.3, 43, 142, 255, 200, false, true, 2, nil, nil, true)
                DrawMarker(25, kauppa.paikat.x, kauppa.paikat.y, kauppa.paikat.z - 0.90, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 43, 142, 255, 200, false, true, 2, nil, nil, true)
            end
        end
    end)
end

----------------
-- # KELLO # --
----------------
function isKauppaAuki()
    local currentHour = GetClockHours()
    return currentHour >= aukeaa and currentHour < sulkeutuu
end

----------------
-- # NOTIFY # --
----------------
function notify(viesti)
    exports['mythic_notify']:SendAlert('inform', viesti, 5000, { ['background-color'] = '', ['color'] = '' })
end
