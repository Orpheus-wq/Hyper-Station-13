// Approved manifest.
// +200 credits flat.
/datum/export/manifest_correct
	cost = 200
	k_elasticity = 0
	unit_name = "approved manifest"
	export_types = list(/obj/item/paper/fluff/jobs/cargo/manifest)

/datum/export/manifest_correct/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	if(M.is_approved() && !M.errors)
		return TRUE
	return FALSE

// Correctly denied manifest.
// Refunds the package cost minus the cost of crate.
/datum/export/manifest_error_denied
	cost = -500
	k_elasticity = 0
	unit_name = "correctly denied manifest"
	export_types = list(/obj/item/paper/fluff/jobs/cargo/manifest)

/datum/export/manifest_error_denied/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	if(M.is_denied() && M.errors)
		return TRUE
	return FALSE

/datum/export/manifest_error_denied/get_cost(obj/O)
	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	return ..() + M.order_cost


// Erroneously approved manifest.
// Substracts the package cost.
/datum/export/manifest_error
	unit_name = "erroneously approved manifest"
	export_types = list(/obj/item/paper/fluff/jobs/cargo/manifest)

/datum/export/manifest_error/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	if(M.is_approved() && M.errors)
		return TRUE
	return FALSE

/datum/export/manifest_error/get_cost(obj/O)
	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	return -M.order_cost


// Erroneously denied manifest.
// Substracts the package cost minus the cost of crate.
/datum/export/manifest_correct_denied
	cost = 500
	unit_name = "erroneously denied manifest"
	export_types = list(/obj/item/paper/fluff/jobs/cargo/manifest)

/datum/export/manifest_correct_denied/applies_to(obj/O)
	if(!..())
		return FALSE

	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	if(M.is_denied() && !M.errors)
		return TRUE
	return FALSE

/datum/export/manifest_correct_denied/get_cost(obj/O)
	var/obj/item/paper/fluff/jobs/cargo/manifest/M = O
	return ..() - M.order_cost

// Paper work done correctly

/datum/export/paperwork_correct
	cost = 50 // finicky number 20 x 50 = 1000 per crate, nerfed from 120 to 50 gaining 2400 versus 1000 (CC is running out of space to put all this paper somewhere)
	k_elasticity = 0
	unit_name = "correct paperwork"
	export_types = list(/obj/item/folder/paperwork_correct)

// Paper work not done retruned

/datum/export/paperwork_incorrect
	cost = -500 // Failed to meet NT standers
	k_elasticity = 0
	unit_name = "returned incorrect paperwork"
	export_types = list(/obj/item/folder/paperwork)
