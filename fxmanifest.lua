fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

ui_page "build/index.html"

dependencies {
  'ox_lib',
  'MP-Base',
  'MP-Inventory',
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

server_scripts {
  'server.lua'
}

client_scripts {'client/init.lua', 'client/client.lua'}

files {
  'locales/*.json',
  'data/stations.lua',
  'client/*.lua',
  "build/index.html",
  "build/**/*"
}

ox_libs {
  'math',
  'locale',
}
