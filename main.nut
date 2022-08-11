// --------------------------------------------------

const POPUP_STREAM_IDENTIFIER = 0x32;
const POPUP_SOUND_POP_UP      = 50000;
const POPUP_SOUND_PM          = 50001;

// --------------------------------------------------

const GUI_TAG_GREY    = "[#b0b0b0]";
const GUI_TAG_RESTORE = "[#d]";

// --------------------------------------------------

const MAX_PM_MESSAGE_LENGTH_PER_LINE = 24;

// --------------------------------------------------

dofile("scripts/functions.nut", true);

// --------------------------------------------------

function onPlayerJoin(player) {
	PushPlayerPopup(player,
		format("Welcome to the\nserver, %s%s%s!",
			GUI_TAG_GREY, player.Name, GUI_TAG_RESTORE));
}

// --------------------------------------------------

function onPlayerDeath(player, reason) {
	PushPlayerPopup(player,
		format("You have died.\nReason for death:\n%s%s%s.",
			GUI_TAG_GREY, GetWeaponName(reason), GUI_TAG_RESTORE));
}

// --------------------------------------------------

function onPlayerPM(player, targetPlayer, message) {
	if (message.len() > MAX_PM_MESSAGE_LENGTH_PER_LINE) {
		message = format("%s\n%s", message.slice(0, MAX_PM_MESSAGE_LENGTH_PER_LINE), message.slice(MAX_PM_MESSAGE_LENGTH_PER_LINE));
	}
	PushPlayerPopup(targetPlayer,
		format("%s%s%s says:\n%s",
			ColourToGUITag(player.Colour), player.Name, GUI_TAG_RESTORE,
			message),
		POPUP_SOUND_PM);
	return 1;
}

// --------------------------------------------------