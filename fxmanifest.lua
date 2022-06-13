fx_version 'adamant'
game 'gta5'
lua54 'yes'

this_is_a_map 'yes'

escrow_ignore {
    "config.lua",
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    '@es_extended/locale.lua',
    'client/*.lua',
    "server/server.lua",
}

shared_scripts {
    "config.lua"
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    '@es_extended/locale.lua',
    'client/*.lua',
    "config.lua"
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
    "config.lua"
}

files {
    'data/**/*.meta',
    'data/**/*.xml',
    'data/**/*.dat',
    'data/**/*.ytyp'
}


data_file 'HANDLING_FILE'            'data/**/handling*.meta'
data_file 'VEHICLE_LAYOUTS_FILE'    'data/**/vehiclelayouts*.meta'
data_file 'VEHICLE_METADATA_FILE'    'data/**/vehicles*.meta'
data_file 'CARCOLS_FILE'            'data/**/carcols*.meta'
data_file 'VEHICLE_VARIATION_FILE'    'data/**/carvariations*.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' 'data/**/*unlocks.meta'
data_file 'PTFXASSETINFO_FILE' 'data/**/ptfxassetinfo.meta'

file 'data/gusepe_timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'data/gusepe_timecycle_mods_1.xml'

data_file 'DLC_ITYP_REQUEST' 'stream/propsfivem/vw_prop_vw_casino_art_02.ytyp'

file 'data/timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'data/timecycle_mods_1.xml'

dependencies {
	'es_extended'
}