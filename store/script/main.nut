// --------------------------------------------------

const POPUP_STREAM_IDENTIFIER = 0x32;

// --------------------------------------------------

gameWindowReso <- GUI.GetScreenSize();

// --------------------------------------------------

dofile("utils.nut");
dofile("popup.nut");

// --------------------------------------------------

function Script::ScriptProcess() {
	::popupPool.Process();
}

// --------------------------------------------------

function Server::ServerData(stream) {
	local identifier = stream.ReadByte();
	switch (identifier) {
	case POPUP_STREAM_IDENTIFIER: {
		local message = stream.ReadString();
		::popupPool.PushPopup(message);
	}
	}
}

// --------------------------------------------------

function GUI::GameResize(width, height) {
	::gameWindowReso = ::VectorScreen(width, height);
}

// --------------------------------------------------