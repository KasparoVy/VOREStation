/datum/skin
	var/list/whitelisted_to		//List of ckeys that are allowed to pick this in charsetup.

//////////////// General VS-only skins /////////////////
/datum/skin/vulpkanin_thin //Less cheek fluff. Works best with the thin and jackal ear styles.
	name = "Vulpkanin - Thin"
	state = "thin"
	species_allowed = list("Vulpkanin")
	parts = list(BP_HEAD)

/datum/skin/vulpkanin_terrier //Shorter muzzle with a more prominent nose. Works best with the terrier ears.
	name = "Vulpkanin - Short"
	state = "terrier"
	species_allowed = list("Vulpkanin")
	parts = list(BP_HEAD)
	part_modifiers = list(
		BP_HEAD = list(
			"eye_icon" = "eyes_wide",
			"eye_icon_location" = 'icons/mob/human_face_vr.dmi'
		)
	)
