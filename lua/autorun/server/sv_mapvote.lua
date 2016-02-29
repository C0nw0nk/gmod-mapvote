--Maps are picked from the maps folder on your server install path.

local settings = {
	Length = 30, -- Vote lasts 30 seconds
	AllowCurrent = false, -- Don't allow current map to be re-voted
	Limit = 20, -- Only allow the max choice of 20 maps
	--Prefix = {"ttt_", "zs_", "gm_", "ze_", "cs_"}, -- Wildcard to only allow maps beginning with ttt_ , zs_, gm_, ze_ and cs_
	--Specify Individual map names instead of the wildcard approach above, This method will ensure that the votemap addon only lets maps be voted we tell it to.
	Prefix = {
	"gm_construct",
	"gm_flatgrass",
	"zs_abandoned_mall_v6b",
	"zs_snowy_castle",
	"zs_nysc_b4a",
	"zs_obj_dump_v10",
	"zs_obj_enervation_v16a",
	"zs_obj_pharmacy_v19",
	"zs_obj_vertigo_v14",
	"zs_lost_base" --Ensure the last mapname you specify in this list does not have a comma on the end of it ","
	},
}

--[[

DO NOT TOUCH ANYTHING BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING.

^^^^^ YOU WILL MOST LIKELY BREAK THE SCRIPT SO TO CONFIGURE THE FEATURES YOU WANT JUST USE WHAT I GAVE YOU ABOVE. ^^^^^

]]

hook.Add("Initialize", "MapVote", function()
	
	if GAMEMODE_NAME == "terrortown" then
		function CheckForMapSwitch()
			local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
			SetGlobalInt("ttt_rounds_left", rounds_left)
			local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
			if rounds_left <= 0 or time_left <= 0 then
				LANG.Msg("limit_vote")
				timer.Stop("end2prep")
				timer.Simple(8, function()
					MapVote.Start(settings.Length, settings.AllowCurrent, settings.Limit, settings.Prefix)
				end)
			end
		end
	end
	
	if GAMEMODE_NAME == "zombiesurvival" then
		--Hook to trigger map voting like the zombie survival FGD tells us
		--https://github.com/C0nw0nk/zombiesurvival/blob/master/gamemodes/zombiesurvival/scripting%20and%20addons.txt#L65
		hook.Add("LoadNextMap", "ZombieSurvival-LoadNextMap", function()
			MapVote.Start(settings.Length, settings.AllowCurrent, settings.Limit, settings.Prefix)
			return true
		end)
	end
	
end)
