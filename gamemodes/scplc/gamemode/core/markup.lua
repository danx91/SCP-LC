--[[-------------------------------------------------------------------------
Markup Builder
---------------------------------------------------------------------------]]
MarkupBuilder = {}

function MarkupBuilder:New()
	if self != MarkupBuilder then
		return self
	end

	return setmetatable( {
		text = "",
		font_stack = 0,
		color_stack = 0,
	}, {
		__index = MarkupBuilder,
		__tostring = MarkupBuilder.ToString
	} )
end

function MarkupBuilder:PushFont( font )
	self.text = self.text.."<font="..font..">"
	self.font_stack = self.font_stack + 1

	return self
end

function MarkupBuilder:PopFont()
	self.text = self.text.."</font>"
	self.font_stack = self.font_stack - 1

	return self
end

function MarkupBuilder:PushColor( r, g, b )
	local clr

	if IsColor( r ) then
		clr = markup.Color( r )
	else
		clr = r..","..( g or r )..","..( b or r )
	end

	self.text = self.text.."<color="..clr..">"
	self.color_stack = self.color_stack + 1

	return self
end

function MarkupBuilder:PopColor()
	self.text = self.text.."</color>"
	self.color_stack = self.color_stack - 1

	return self
end

function MarkupBuilder:Print( txt, clr, font )
	if font then self.text = self.text.."<font="..font..">" end
	if clr then self.text = self.text.."<color="..markup.Color( clr )..">" end

	self.text = self.text..txt

	if font then self.text = self.text.."</font>" end
	if clr then self.text = self.text.."</color>" end

	return self
end

function MarkupBuilder.StaticPrint( txt, clr, font )
	local text = ""
	if font then text = text.."<font="..font..">" end
	if clr then text = text.."<color="..markup.Color( clr )..">" end

	text = text..txt

	if font then text = text.."</font>" end
	if clr then text = text.."</color>" end

	return text
end

function MarkupBuilder:Finish()
	while self.font_stack > 0 do
		self:PopFont()
	end

	while self.color_stack > 0 do
		self:PopColor()
	end

	return self
end

function MarkupBuilder:ToString()
	self:Finish()
	return self.text
end

function MarkupBuilder:Parse( width )
	if SERVER then return end

	self:Finish()
	return markup.Parse( self.text, width )
end

setmetatable( MarkupBuilder, { __call = MarkupBuilder.New } )