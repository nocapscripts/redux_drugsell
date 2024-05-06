fx_version 'cerulean'
game 'gta5'
lua54 'yes'



shared_scripts {
    --'@qb-core/shared/locale.lua',
    '@rs_base/shared/locale.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua',
    'locales/et.lua',
}

client_scripts {
    'framework/client.lua',
    'client/*.lua',
}

server_scripts {
    'framework/server.lua',
    'server/*.lua',
}

dependencies {
    'ox_lib'
}