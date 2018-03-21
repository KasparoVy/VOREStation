var/list/all_skins = list()
var/list/skin_data = list()
var/list/chargen_skins = list()

var/datum/skin/basic_skin

/proc/populate_skin_list()
	basic_skin = new()
	for(var/skin_type in typesof(/datum/skin))
		var/datum/skin/S = new skin_type()
		all_skins[S.name] = S
		if(!S.unavailable_at_chargen)
			chargen_skins[S.name] = S

/datum/skin
	var/name = "Default"				//Shown when selecting the limb.
	var/state = "default"				//Icon state suffix. Icon state is compiled like: [whatever_the_organ's_state_is]_[state]
	var/unavailable_at_chargen			//If set, not available at chargen.
	var/list/species_allowed = list()
	var/parts = list()				 	//Defines what limbs get reskinned.
	var/list/part_modifiers = list()	//List of lists of values on the target part datum to be modified. i.e. list(BP_HEAD = list("eye_icon" = "eyes_wide")). Should LAZYLEN these lists in reskin() procs.

/datum/skin/proc/apply(var/obj/item/organ/external/E) //A-la traits application. Very handy trick, accessing the vars list like this!
	ASSERT(E)
	E.skin = name //Apply the skin.
	E.icon_name = "[initial(E.icon_name)]_[state]"
	if(part_modifiers && part_modifiers[E.organ_tag]) //Apply the mods.
		for(var/M in part_modifiers[E.organ_tag])
			E.vars[M] = part_modifiers[E.organ_tag][M]
	return

/datum/skin/lizard_sharp //Pointier Unathi snout. That's it.
	name = "Unathi - Sharp"
	state = "sharp"
	species_allowed = list(SPECIES_UNATHI)
	parts = list(BP_HEAD)
