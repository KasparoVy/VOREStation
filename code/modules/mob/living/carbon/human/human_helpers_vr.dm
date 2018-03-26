var/static/icon/ingame_hud_vr = icon('icons/mob/hud_vr.dmi')
var/static/icon/ingame_hud_med_vr = icon('icons/mob/hud_med_vr.dmi')

/mob/living/carbon/human/make_hud_overlays()
	. = ..()
	hud_list[HEALTH_VR_HUD]   = gen_hud_image(ingame_hud_med_vr, src, "100", plane = PLANE_CH_HEALTH_VR)
	hud_list[STATUS_R_HUD]    = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_STATUS_R)
	hud_list[BACKUP_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_BACKUP)
	hud_list[VANTAG_HUD]      = gen_hud_image(ingame_hud_vr, src, plane = PLANE_CH_VANTAG)

/mob/living/carbon/human/proc/get_mass_exertion_mod(var/weight_only, var/nutrition_only) //Affected by weight and nutrition.
	var/list/mods			= list("weight_mod" = 1, "nutrition_mod" = 1)
	var/median_mod			= 1		//~150 pounders with ~300 nutrition will have this modifier.
	var/min_mod				= 0.75	//Individual modifiers from weight/nutrition calculations cannot be lower than this.
	var/min_final_mod		= 0.7	//The average all modifiers cannot drop below this.


	var/DEBUG_STRING = "[real_name]"
	if(!nutrition_only)
		//Handle weight.
		var/median_weight	= 150	//Median of the healthy weight range defined in examine_vr.dm. Being overweight will incur penalty while being underweight incurs benefit.
		if(weight > 0 && weight < 100)		//Modifier decreases more slowly the lighter than 100 lbs you are. Still a steep curve, though.
			var/scale_factor	= 0.00016	//Affects the severity of the curvature of the function.
			var/apex_x			= 70
			var/apex_y			= 0.75
			mods["weight_mod"]	= (scale_factor * ((weight - apex_x) ** 2)) + apex_y
			world << "skinny weight mod: [mods["weight_mod"]]"
			mods["weight_mod"]	= min(max(mods["weight_mod"], min_mod), median_mod)
		else if(weight > 99 && weight < 126) //Increasing returns the lighter you become, getting steeper. Returns deminish the closer to average weight (125-150) you get.
			var/scale_factor	= 0.00016
			var/apex_x			= 125
			mods["weight_mod"]	= (-scale_factor * ((weight - apex_x) ** 2)) + median_mod
			world << "average weight mod: [mods["weight_mod"]]"
			mods["weight_mod"]	= min(max(mods["weight_mod"], min_mod), median_mod)
		else if(weight > 150)				//Modifier increases faster the more weight you gain.
			var/scale_factor	= 0.00002
			mods["weight_mod"]	= (scale_factor * ((weight - median_weight) ** 2)) + median_mod
			world << "fat weight mod: [mods["weight_mod"]]"
			mods["weight_mod"]	= max(mods["weight_mod"], median_mod)
		world << "<span class='notice'>weight mod == [mods["weight_mod"]]</span>"

	if(!weight_only)
		//Handle nutrition.
		var/median_nutrition 	= 300		//Median of the random nutrition values humanoids can spawn in with. Overnutrition will incur penalty while light meals incur benefit.
		if(nutrition > 0 && nutrition < 300)
			var/scale_factor 		= 0.000005	//Affects the severity of the curvature of the function. Reaches 0.75 at 80 nutrition.
			mods["nutrition_mod"]	= (-scale_factor * ((nutrition - median_nutrition) ** 2)) + median_mod
			world << "average nutrition mod: [mods["nutrition_mod"]]"
			mods["nutrition_mod"]	= min(max(mods["nutrition_mod"], min_mod), median_mod)
		if(nutrition > 299)
			var/scale_factor		= 0.00002
			mods["nutrition_mod"]	= (scale_factor * ((nutrition - median_nutrition) ** 2)) + median_mod
			world << "fat nutrition mod: [mods["nutrition_mod"]]"
			mods["nutrition_mod"]	= max(mods["nutrition_mod"], median_mod)
		world << "<span class='notice'>nutrition mod == [mods["nutrition_mod"]]</span>"

	var/final_mod = 0
	for(var/mod in mods)
		final_mod += mods[mod]
	world << "number of mods == [mods.len]"
	final_mod /= mods.len
	world << "<span class='notice'>mod == [max(round(final_mod, 0.01), min_final_mod)]</span>"
	return max(round(final_mod, 0.01), min_final_mod)
