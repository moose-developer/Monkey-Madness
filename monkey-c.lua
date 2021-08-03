local teams = {
    {name = "allies", model = "a_c_chimp", weapon = "WEAPON_ASSAULTRIFLE"},
    {neme = "enemies", model = "a_c_chimp", weapon = "WEAPON_ASSAULTRIFLE"}
}

for i=1, #teams, 1 do
    AddRelationshipGroup(teams[i].name)
end

local j = nil

RegisterCommand("monkeym", function(source, args)
    local totalPeople = tonumber(args[1])
    -- /monkeym "20"
    -- > 2- (int)
    for i=1, totalPeople, 1 do
        j = math.random(1, #teams)
        local ped = GetHashKey(teams[j].model)
        RequestModel(ped)
        while not HasModelLoaded(ped) do 
            Citizen.Wait(1)
        end
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
        newPed = CreatePed(4, ped, x+math.random(-totalPeople, totalPeople), y+math.random(-totalPeople, totalPeople), z, 0.0, false, true)
        SetPedCombatAttributes(newPed, 0, true) -- Be able to take cover
        SetPedCombatAttributes(newPed, 5, true) -- BF_CanFightArmedPedWhenNotArmed
        SetPedCombatAttributes(newPed, 46, true) -- Always Fight
        SetPedFleeAttributes(newPed, 0, true)

        SetPedRelationshipGroupHash(newPed, GetHashKey(teams[j].name))
        SetRelationshipBetweenGroups(5, GetHashKey(teams[1].name), GetHashKey(teams[2].name))
        if teams[j].name == "allies" then
            SetRelationshipBetweenGroups(0, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
            SetPedAccuracy(newPed, 65)
        else
            SetRelationshipBetweenGroups(5, GetHashKey(teams[j].name), GetHashKey("PLAYER"))
        end
        TaskStartScenarioInPlace(newPed, "WORLD_HUMAN_SMOKING", 0, true)
        GiveWeaponToPed(newPed, GetHashKey(teams[j].weapon), 2000, true, false)
        SetPedArmour(newPed, 100)
        SetPedMaxHealth(newPed, 100)
    end
end)