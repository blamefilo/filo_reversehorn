fx_version "cerulean"
game "gta5"
lua54 "yes"

name "filo_reversehorn"
author "filo studios."
discord "https://discord.gg/bErPEKvRXg"
description ""
version "1.0.0"

shared_scripts {
    "@ox_lib/init.lua",
    "shared/sh-*.lua",
    "config.lua"
}

server_scripts {
    "bridge/**/sv-*.lua",
    "server/sv-*.lua"
}

client_scripts {
    "bridge/**/cl-*.lua",
    "client/cl-*.lua"
}

escrow_ignore {}
files {
    "sounds/*"
}