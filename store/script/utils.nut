// --------------------------------------------------

Util <- {}; // C++-like namespace.

// --------------------------------------------------

function Util::RelativeVectorScreen(x, y) {
	return ::VectorScreen((::gameWindowReso.X * x).tointeger(), (::gameWindowReso.Y * y).tointeger());
}

// --------------------------------------------------

function Util::RelativeFontSize(x) {
	return (::gameWindowReso.X * x).tointeger();
}

// --------------------------------------------------

function Util::TruncateGUIElementText(element, maxWidth) {
	local textWidth = element.TextSize.X;
	if (textWidth <= maxWidth) {
		return;
	}

	element.Text = ::format("%s...", element.Text.slice(0, element.Text.len() * maxWidth / textWidth));
}

// --------------------------------------------------

function Util::NewGUILabel(flags, size, position, colour, text, fontName, fontSize, textColour, fontFlags, textAlignment) {
	local label = ::GUILabel();
	label.AddFlags(flags);
	label.Size          = size;
	label.Position      = position;
	label.Colour        = colour;
	label.Text          = text;
	label.FontName      = fontName;
	label.FontSize      = fontSize;
	label.TextColour    = textColour;
	label.FontFlags     = fontFlags;
	label.TextAlignment = textAlignment;
	return label;
}

// --------------------------------------------------

function Util::NewGUISprite(fileName, size, position, colour) {
	local sprite = ::GUISprite();
	sprite.SetTexture(fileName);
	sprite.Size     = size;
	sprite.Position = position;
	sprite.Colour   = colour;
	return sprite;
}

// --------------------------------------------------