// --------------------------------------------------

const MAX_POPUPS           = 3;     // Max permitted popups on the screen at a time.
const MAX_POPUP_LINES      = 3;     // Max text lines per popup.
const MAX_POPUP_LINE_WIDTH = 110;   // Prevents line overflowing.
const MAX_POPUP_MOVE_TIMES = 9;     // How many times a popup should move upwards or downwards.
const POPUP_LINE_OFFSET    = 0.02;  // Offset between lines.
const POPUP_LIFESPAN       = 10000; // Popup lifespan.

// --------------------------------------------------

/* Popup class signature */
class Popup {
	background       = null; // The background (GUISprite).
	logo             = null; // The logo (GUISprite).
	lines            = null; // Array containing our text (GUILabel).
	ticksWhenCreated = null; // Whatever Script.GetTicks() returns when instantiating an object.

	stopped    = false; // Is our popup static?
	movedTimes = 0;     // Prevent moving our popup upwards or downwards indefinitely.
	fadingOut  = false; // Is our popup fading out?
};

// --------------------------------------------------

function Popup::SetUpBackground() {
	background = ::Util.NewGUISprite("popup_bg.png",
		::Util.RelativeVectorScreen(0.15, 0.1),
		::Util.RelativeVectorScreen(0.851, 1.0),
		::Colour(255, 255, 255, 0));
}

// --------------------------------------------------

function Popup::SetUpLogo() {
	logo = ::Util.NewGUISprite("popup_logo.png",
		::Util.RelativeVectorScreen(0.03, 0.06),
		::Util.RelativeVectorScreen(0.01, 0.02),
		::Colour(255, 255, 255, 0));
	background.AddChild(logo);
}

// --------------------------------------------------

function SetUpText(text) {
	// Make 'lines' to point to valid data.
	lines = ::array(MAX_POPUP_LINES);

	// Set our text up.
	local x = 0.01;
	local line;
	foreach (i, lineText in ::split(text, "\n")) {
		// Exit the loop if we have added
		// too many lines already.
		if (i > (MAX_POPUP_LINES - 1)) {
			break;
		}

		// Add line.
		line = lines[i] = ::Util.NewGUILabel(GUI_FLAG_TEXT_SHADOW | GUI_FLAG_TEXT_TAGS,
			::Util.RelativeVectorScreen(0.105, 0.03),
			::Util.RelativeVectorScreen(0.045, x),
			::Colour(0, 0, 0, 0),
			::strip(lineText),
			"Verdana",
			::Util.RelativeFontSize(0.0085),
			::Colour(255, 255, 255),
			GUI_FFLAG_NONE,
			GUI_ALIGN_LEFT);
		::Util.TruncateGUIElementText(line, MAX_POPUP_LINE_WIDTH); // In case our text is too long.
		background.AddChild(line);
		// On the next iteration,
		// add next line on a new line.
		x += POPUP_LINE_OFFSET;
	}
}

// --------------------------------------------------

function Popup::MoveUpwards() {
	background.Position.Y -= (::gameWindowReso.Y * 0.01);  // Move.
	background.Alpha += 29; // Show.
}

// --------------------------------------------------

function Popup::MoveDownwards() {
	background.Position.Y += (::gameWindowReso.Y * 0.01); // Move.
	background.Alpha -= 29; // Fade.
}

// --------------------------------------------------

function Popup::constructor(text) {
	SetUpBackground();
	SetUpLogo();
	SetUpText(text);
	ticksWhenCreated = ::Script.GetTicks();
}

// --------------------------------------------------

function Popup::Process() {
	// Is our popup static?
	if (stopped) {
		// Is it ready to fade?
		if ((::Script.GetTicks() - ticksWhenCreated) >= POPUP_LIFESPAN) {
			// Move downwards.
			if (movedTimes++ < MAX_POPUP_MOVE_TIMES) {
				fadingOut = true;
				MoveDownwards();
			}
			// Already moved too many times.
			else {
				// We can delete it now.
				return true;
			}
		}
	}
	// Not static.
	else {
		// Move upwards.
		if (movedTimes++ < MAX_POPUP_MOVE_TIMES) {
			MoveUpwards();
		}
		// Already moved too many times.
		else {
			// Stop it now and wait until
			// its lifespan is completed.
			stopped    = true;
			movedTimes = 0;
		}
	}

	// It's still not ready
	// to be deleted.
	return false;
}

// --------------------------------------------------

popupPool <- {
	popups = ::array(MAX_POPUPS)
};

// --------------------------------------------------

function popupPool::PushBack() {
	for (local i = 0, popup; i < (MAX_POPUPS - 1); ++i) {
		// Push it back.
		popup = popups[i] = popups[i + 1];
		// Do nothing if our popup is invalid or
		// if it's fading out (bacause it will
		// be gone soon).
		if (!popup || popup.fadingOut) {
			continue;
		}

		// Another popup is about to be pushed
		// therefore existing ones should start
		// moving upwards.
		//
		// Is our popup moving upwards already?
		if (!popup.stopped) {
			popup.movedTimes -= MAX_POPUP_MOVE_TIMES;
		}
		// Let it know it should start
		// moving upwards in any case.
		popup.stopped = false;
	}
}

// --------------------------------------------------

function popupPool::PushPopup(text) {
	PushBack();
	popups[MAX_POPUPS - 1] = ::Popup(text);
}

// --------------------------------------------------

function popupPool::Process() {
	foreach (i, popup in popups) {
		if (!popup) {
			continue;
		}

		// Ready to be killed off?
		if (popup.Process()) {
			// Do it!
			popups[i] = null;
		}
	}
}

// --------------------------------------------------