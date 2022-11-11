fx_version "cerulean"
game "gta5"

version "1.0"
description "Vehicle spawn menu."
author "Time_XP"

client_scripts {
    "@NativeUI/NativeUI.lua",
    "client/cl_vehiclesmenu.lua"
}

server_script "server/sv_vehiclesmenu.lua"

shared_script "shared/config.lua"

dependency "NativeUI"
