
/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
	parent_type = /datum


	/// hides the byond verb panel as we use our own custom version
	show_verb_panel = FALSE
		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/click_intercept = null // Needs to implement InterceptClickOn(user,params,atom) proc
	var/AI_Interact		= 0

	var/jobbancache = null //Used to cache this client's jobbans to save on DB queries
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.
	var/ircreplyamount = 0

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/last_turn = 0
	var/move_delay = 0
	var/area			= null



	/// our current tab
	var/stat_tab

	/// whether our browser is ready or not yet
	var/statbrowser_ready = FALSE

	/// list of all tabs
	var/list/panel_tabs = list()

	/// list of tabs containing spells and abilities
	var/list/spell_tabs = list()
	/// list of tabs containing verbs
	var/list/verb_tabs = list()
		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	control_freak = 1

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = -1	//Used to determine how old the account is - in days.
	var/player_join_date = null //Date that this account was first seen in the server
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/account_join_date = null	//Date of byond account creation in ISO 8601 format
	var/account_age = -1	//Age of byond account in days

	preload_rsc = PRELOAD_RSC

	var/obj/screen/click_catcher/void

	//These two vars are used to make a special mouse cursor, with a unique icon for clicking
	var/mouse_up_icon = null
	var/mouse_down_icon = null

	var/ip_intel = "Disabled"

	//datum that controls the displaying and hiding of tooltips
	var/datum/tooltip/tooltips

	var/lastping = 0
	var/avgping = 0
	var/connection_time //world.time they connected
	var/connection_realtime //world.realtime they connected
	var/connection_timeofday //world.timeofday they connected

	var/inprefs = FALSE
	var/list/topiclimiter
	var/list/clicklimiter

	var/datum/chatOutput/chatOutput

	var/list/credits //lazy list of all credit object bound to this client

	var/datum/player_details/player_details //these persist between logins/logouts during the same round.

	var/list/char_render_holders			//Should only be a key-value list of north/south/east/west = obj/screen.


	var/client_keysend_amount = 0
	var/next_keysend_reset = 0
	var/next_keysend_trip_reset = 0
	var/keysend_tripped = FALSE

	/// Messages currently seen by this client
	var/list/seen_messages

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0
