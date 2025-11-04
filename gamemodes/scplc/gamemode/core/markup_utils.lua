--[[-------------------------------------------------------------------------
Markup Builder
---------------------------------------------------------------------------]]
local function color_fallback( clr )
	return clr.r..","..clr.g..","..clr.b..( clr.a == 255 and "" or ","..col.a )
end

MarkupBuilder = {}

function MarkupBuilder:New( font )
	if self != MarkupBuilder then
		return self
	end

	local builder = setmetatable( {
		text = "",
		font_stack = 0,
		color_stack = 0,
	}, {
		__index = MarkupBuilder,
		__tostring = MarkupBuilder.ToString
	} )

	if font then
		builder:PushFont( font )
	end

	return builder
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
		clr = markup and markup.Color( r ) or color_fallback( r )
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
	if isstring( clr ) then
		font = clr
		clr = nil
	end

	if font then self.text = self.text.."<font="..font..">" end
	if clr then self.text = self.text.."<color="..( markup and markup.Color( clr ) or color_fallback( clr ) )..">" end

	self.text = self.text..( txt or "~#NIL" )

	if font then self.text = self.text.."</font>" end
	if clr then self.text = self.text.."</color>" end

	return self
end

function MarkupBuilder.StaticPrint( txt, clr, font )
	if isstring( clr ) then
		font = clr
		clr = nil
	end

	local text = ""
	if font then text = text.."<font="..font..">" end
	if clr then text = text.."<color="..( markup and markup.Color( clr ) or color_fallback( clr ) )..">" end

	text = text..( txt or "~#NIL" )

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