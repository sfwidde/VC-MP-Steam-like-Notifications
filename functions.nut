// --------------------------------------------------

function ColourToGUITag(x) {
	return format("[#%.2x%.2x%.2x]", x.r, x.g, x.b);
}

// --------------------------------------------------

function PushPlayerPopup(player, message, soundId = POPUP_SOUND_POP_UP) {
	Stream.StartWrite();
	Stream.WriteByte(POPUP_STREAM_IDENTIFIER);
	Stream.WriteString(message);
	Stream.SendStream(player);
	player.PlaySound(soundId);
}

// --------------------------------------------------