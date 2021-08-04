sound.Add{
	name = "SLCPlayer.Breathing",
	sound = "scp_lc/misc/breathing.wav",
	volume = 0.75,
	level = 70,
	pitch = { 90, 110 },
	channel = CHAN_STATIC,
}

local vest = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav",
}

sound.Add{
	name = "SLCPlayer.Vest",
	sound = vest,
	volume = 1,
	level = 75,
	pitch = { 90, 110 },
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SLCPlayer.Heartbeat",
	sound = "scp_lc/misc/heartbeat.ogg",
	volume = 1,
	level = 0,
	pitch = 100,
	channel = CHAN_STATIC,
}

sound.Add{
	name = "SLCMisc.Overload",
	sound = { "ambient/energy/zap7.wav", "ambient/energy/zap8.wav", "ambient/energy/zap9.wav" },
	volume = 1,
	level = 110,
	pitch = 100,
	channel = CHAN_STATIC,
}

function AddSounds( name, sounds, level, volume, pitch, channel, numstart, numend )
	local tab = {}

	for i = numstart, numend do
		table.insert( tab, string.format( sounds, i ) )
	end

	sound.Add{
		name =  name,
		sound = tab,
		volume = volume,
		level = level,
		pitch = pitch,
		channel = channel,
	}
end

//AddSounds( "SLCPlayer.Vest", "npc/combine_soldier/gear%i.wav", 70, 1, { 90, 110 }, CHAN_STATIC, 6 )