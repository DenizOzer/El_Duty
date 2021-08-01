resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page 'files/index.html'

files {
    'files/index.html',
    'files/app.js',
    'files/image.png'
}

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'config.lua'
}