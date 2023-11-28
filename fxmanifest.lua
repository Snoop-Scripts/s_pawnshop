fx_version "adamant"
game "gta5"
lua54 'yes'

author "Snooppikoira"
version "1337"

shared_scripts {
	'@ox_lib/init.lua'
}

client_script {
	"pawnshop/cl_*.lua"
}

server_script {
	"pawnshop/sv_*.lua"
}

dependencies {
    'ox_lib',
    'ox_target',
    'es_extended',
	'mythic_notify',
	's_pawnshop'
}