#define PH_WEAK 		(1 << 0)
#define TEMP_WEAK 		(1 << 1)

/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = WEIGHT_CLASS_TINY
	var/amount_per_transfer_from_this = 5
	var/list/possible_transfer_amounts = list(5,10,15,20,25,30)
	var/volume = 30
	var/reagent_flags
	var/list/list_reagents = null
	var/spawned_disease = null
	var/disease_amount = 20
	var/spillable = FALSE
	var/beaker_weakness_bitflag = NONE//Bitflag!
	var/container_HP = 2
	var/cached_icon
	var/splashable = FALSE

/obj/item/reagent_containers/Initialize(mapload, vol)
	. = ..()
	if(isnum(vol) && vol > 0)
		volume = vol
	create_reagents(volume, reagent_flags)
	if(spawned_disease)
		var/datum/disease/F = new spawned_disease()
		var/list/data = list("blood_DNA" = "UNKNOWN DNA", "blood_type" = "SY","viruses"= list(F))
		reagents.add_reagent(/datum/reagent/blood, disease_amount, data)
	add_initial_reagents()

/obj/item/reagent_containers/proc/add_initial_reagents()
	if(list_reagents)
		reagents.add_reagent_list(list_reagents)

/obj/item/reagent_containers/attack_self(mob/user)
	if(possible_transfer_amounts.len)
		var/i=0
		for(var/A in possible_transfer_amounts)
			i++
			if(A == amount_per_transfer_from_this)
				if(i<possible_transfer_amounts.len)
					amount_per_transfer_from_this = possible_transfer_amounts[i+1]
				else
					amount_per_transfer_from_this = possible_transfer_amounts[1]
				to_chat(user, "<span class='notice'>[src]'s transfer amount is now [amount_per_transfer_from_this] units.</span>")
				return

/obj/item/reagent_containers/attack(mob/M, mob/user, def_zone)
	if(user.a_intent == INTENT_HARM)
		return ..()

/obj/item/reagent_containers/proc/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return 0
	var/mob/living/carbon/C = eater
	var/covered = ""
	if(C.is_mouth_covered(head_only = 1))
		covered = "headgear"
	else if(C.is_mouth_covered(mask_only = 1))
		covered = "mask"
	if(covered)
		var/who = (isnull(user) || eater == user) ? "your" : "[eater.p_their()]"
		to_chat(user, "<span class='warning'>You have to remove [who] [covered] first!</span>")
		return 0
	if(!eater.has_mouth())
		if(eater == user)
			to_chat(eater, "<span class='warning'>You have no mouth, and cannot eat.</span>")
		else
			to_chat(user, "<span class='warning'>You can't feed [eater], because they have no mouth!</span>")
		return 0
	return 1

/obj/item/reagent_containers/ex_act()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			R.on_ex_act()
	if(!QDELETED(src))
		..()

/obj/item/reagent_containers/fire_act(exposed_temperature, exposed_volume)
	reagents.expose_temperature(exposed_temperature)
	..()

/obj/item/reagent_containers/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	SplashReagents(hit_atom, TRUE)

/obj/item/reagent_containers/proc/bartender_check(atom/target)
	. = FALSE
	var/turf/T = get_turf(src)
	if(!T || !thrownby || !thrownby.actions)
		return
	for(var/datum/action/innate/D in thrownby.actions)
		if(D.active && istype(D, /datum/action/innate/drink_fling))
			return TRUE


/obj/item/reagent_containers/proc/ForceResetRotation()
	transform = initial(transform)

/obj/item/reagent_containers/proc/SplashReagents(atom/target, thrown = FALSE)
	if(!reagents || !reagents.total_volume || !(splashable ? splashable : spillable))
		return

	if(ismob(target) && target.reagents)
		if(thrown)
			reagents.total_volume *= rand(5,10) * 0.1 //Not all of it makes contact with the target
		var/mob/M = target
		var/R
		target.visible_message("<span class='danger'>[M] has been splashed with something!</span>", \
						"<span class='userdanger'>[M] has been splashed with something!</span>")
		for(var/datum/reagent/A in reagents.reagent_list)
			R += "[A.type] ([A.volume]),"

		if(thrownby)
			log_combat(thrownby, M, "splashed", R)
		reagents.reaction(target, TOUCH)

	else if(bartender_check(target) && thrown)
		if(!istype(src, /obj/item/reagent_containers/food/drinks))	//drinks smash against solid objects
			visible_message("<span class='notice'>[src] lands upright without spilling a single drop!</span>")
			transform = initial(transform)
		return

	else
		if(isturf(target) && reagents.reagent_list.len && thrownby)
			log_combat(thrownby, target, "splashed (thrown) [english_list(reagents.reagent_list)]", "in [AREACOORD(target)]")
			log_game("[key_name(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] in [AREACOORD(target)].")
			message_admins("[ADMIN_LOOKUPFLW(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] in [ADMIN_VERBOSEJMP(target)].")
		visible_message("<span class='notice'>[src] spills its contents all over [target].</span>")
		reagents.reaction(target, TOUCH)
		if(QDELETED(src))
			return

	reagents.clear_reagents()

//melts plastic beakers
/obj/item/reagent_containers/microwave_act(obj/machinery/microwave/M)
	reagents.expose_temperature(1000)
	if(beaker_weakness_bitflag & TEMP_WEAK)
		var/list/seen = viewers(5, get_turf(src))
		var/iconhtml = icon2html(src, seen)
		for(var/mob/H in seen)
			to_chat(H, "<span class='notice'>[iconhtml] \The [src]'s melts from the temperature!</span>")
			playsound(get_turf(src), 'sound/FermiChem/heatmelt.ogg', 80, 1)
		qdel(src)
	..()

//melts plastic beakers
/obj/item/reagent_containers/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	reagents.expose_temperature(exposed_temperature)
	temp_check()

/obj/item/reagent_containers/proc/temp_check()
	if(beaker_weakness_bitflag & TEMP_WEAK)
		if(reagents.chem_temp >= 444)//assuming polypropylene
			START_PROCESSING(SSobj, src)

//melts glass beakers
/obj/item/reagent_containers/proc/pH_check()
	if(beaker_weakness_bitflag & PH_WEAK)
		if((reagents.pH < 1.5) || (reagents.pH > 12.5))
			START_PROCESSING(SSobj, src)


/obj/item/reagent_containers/process()
	if(!cached_icon)
		cached_icon = icon_state
	var/damage
	var/cause
	if(beaker_weakness_bitflag & PH_WEAK)
		if(reagents.pH < 2)
			damage = (2 - reagents.pH)/20
			cause = "from the extreme pH"
			playsound(get_turf(src), 'sound/FermiChem/bufferadd.ogg', 50, 1)

		if(reagents.pH > 12)
			damage = (reagents.pH - 12)/20
			cause = "from the extreme pH"
			playsound(get_turf(src), 'sound/FermiChem/bufferadd.ogg', 50, 1)

	if(beaker_weakness_bitflag & TEMP_WEAK)
		if(reagents.chem_temp >= 444)
			if(damage)
				damage += (reagents.chem_temp/444)/5
			else
				damage = (reagents.chem_temp/444)/5
			if(cause)
				cause += " and "
			cause += "from the high temperature"
			playsound(get_turf(src), 'sound/FermiChem/heatdam.ogg', 50, 1)

	if(!damage || damage <= 0)
		STOP_PROCESSING(SSobj, src)

	container_HP -= damage

	var/list/seen = viewers(5, get_turf(src))
	var/iconhtml = icon2html(src, seen)

	var/damage_percent = ((container_HP / initial(container_HP)*100))
	switch(damage_percent)
		if(-INFINITY to 0)
			for(var/mob/M in seen)
				to_chat(M, "<span class='notice'>[iconhtml] \The [src]'s melts [cause]!</span>")
				playsound(get_turf(src), 'sound/FermiChem/acidmelt.ogg', 80, 1)
			SSblackbox.record_feedback("tally", "fermi_chem", 1, "Times beakers have melted")
			STOP_PROCESSING(SSobj, src)
			qdel(src)
			return
		if(0 to 35)
			icon_state = "[cached_icon]_m3"
			desc = "[initial(desc)] It is severely deformed."
		if(35 to 70)
			icon_state = "[cached_icon]_m2"
			desc = "[initial(desc)] It is deformed."
		if(70 to 85)
			desc = "[initial(desc)] It is mildly deformed."
			icon_state = "[cached_icon]_m1"

	update_icon()
	if(prob(25))
		for(var/mob/M in seen)
			to_chat(M, "<span class='notice'>[iconhtml] \The [src]'s is damaged by [cause] and begins to deform!</span>")
