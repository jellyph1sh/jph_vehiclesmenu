local function LoadModel(model)
    local hash = GetHashKey(model)
    if not IsModelInCdimage(hash) then
        return 0
    end
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(50)
    end
    return hash
end

local function SpawnVehicle(hash)
    local ped = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local h = GetEntityHeading(ped)
    local veh = CreateVehicle(hash, x, y, z, h, true, true)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehRadioStation(veh, "OFF")
    TaskWarpPedIntoVehicle(ped, veh, -1)
    SetEntityAsNoLongerNeeded()
    return veh
end

local function CreateVehicleItems(submenu, category, vehicles)
    for i, veh in pairs(vehicles) do
        if veh.category == category.name then
            submenu:AddItem(NativeUI.CreateItem(veh.name, veh.model))
        end
    end
end

local function ActionVehiclesItems(submenu, vehicles)
    submenu.OnItemSelect = function(sender, item, index)
        for index, veh in pairs(vehicles) do
            if item._Description == veh.model then
                local hash = LoadModel(veh.model)
                SpawnVehicle(hash)
            end
        end
    end
end

local function CreateVehiclesCategories(menuPool, menu, categories, vehicles)
    for index, category in pairs(categories) do
        local submenu = menuPool:AddSubMenu(menu, category.name, category.description)
        CreateVehicleItems(submenu, category, vehicles)
        ActionVehiclesItems(submenu, vehicles)
    end
end

local function CreateVehiclesMenu()
    local menuPool = NativeUI.CreatePool()
    local vehiclesMenu = NativeUI.CreateMenu(Language[Config.Lang]["menu_title"], Language[Config.Lang]["menu_desc"])
    menuPool:Add(vehiclesMenu)

    CreateVehiclesCategories(menuPool, vehiclesMenu, Config.Categories, Config.VehiclesList)

    return menuPool, vehiclesMenu
end

Citizen.CreateThread(function()
    local menuPool, vehiclesMenu = CreateVehiclesMenu()
    menuPool:MouseControlsEnabled(false)
    menuPool:MouseEdgeEnabled(false)
    menuPool:ControlDisablingEnabled(false)

    while true do
        menuPool:ProcessMenus()
        if IsControlJustPressed(1, Config.ControlMenu) then
            vehiclesMenu:Visible(not vehiclesMenu:Visible())
        end
        Citizen.Wait(0)
    end
end)
