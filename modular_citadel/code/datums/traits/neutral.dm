// Citadel-specific Neutral Traits

/datum/quirk/libido
	name = "Nymphomania"
	desc = "You're always feeling a bit in heat. Also, you get aroused faster than usual."
	value = 0
	category = CATEGORY_SEXUAL
	mob_trait = TRAIT_NYMPHO
	gain_text = "<span class='notice'>You are feeling extra wild.</span>"
	lose_text = "<span class='notice'>You don't feel that burning sensation anymore.</span>"

/datum/quirk/libido/add()
	quirk_holder.min_arousal = 16
	quirk_holder.arousal_rate = 3

/datum/quirk/libido/remove()
	if(quirk_holder)
		quirk_holder.min_arousal = initial(quirk_holder.min_arousal)
		quirk_holder.arousal_rate = initial(quirk_holder.arousal_rate)

/datum/quirk/libido/on_process()
	var/mob/living/M = quirk_holder
	if(M.canbearoused == FALSE)
		to_chat(quirk_holder, "<span class='notice'>Having high libido is useless when you can't feel arousal at all!</span>")
		qdel(src)

/datum/quirk/maso
	name = "Masochism"
	desc = "You are aroused by pain."
	value = 0
	category = CATEGORY_SEXUAL
	mob_trait = TRAIT_MASO
	gain_text = "<span class='notice'>You desire to be hurt.</span>"
	lose_text = "<span class='notice'>Pain has become less exciting for you.</span>"

/datum/quirk/choke_slut
	name = "Choke Slut"
	desc = "You are aroused by suffocation."
	value = 0
	category = CATEGORY_SEXUAL
	mob_trait = TRAIT_CHOKE_SLUT
	gain_text = "<span class='notice'>You feel like you want to feel fingers around your neck, choking you until you pass out or make a mess... Maybe both.</span>"
	lose_text = "<span class='notice'>Seems you don't have a kink for suffocation anymore.</span>"
/*
/datum/quirk/pharmacokinesis //Prevents unwanted organ additions.
	name = "Acute hepatic pharmacokinesis"
	desc = "You've a rare genetic disorder that causes Incubus draft and Sucubus milk to be absorbed by your liver instead."
	value = 0
	category = CATEGORY_SEXUAL
	mob_trait = TRAIT_PHARMA
	lose_text = "<span class='notice'>Your liver feels different.</span>"
	var/active = FALSE
	var/power = 0
	var/cachedmoveCalc = 1

/datum/quirk/fluid_leak
	name = "Leaky breasts"
	desc = "You don't stop making milk, and you have a habit of leaking everywhere when your breasts are full"
	mob_trait = TRAIT_FLUID_LEAK
	value = 0
	medical_record_text = "Patient poorly controls their fluids."
	gain_text = "<span class='notice'>You feel like your leaking everywhere.</span>"
	lose_text = "<span class='notice'>You feel like you can control your fluids.</span>"
*/
