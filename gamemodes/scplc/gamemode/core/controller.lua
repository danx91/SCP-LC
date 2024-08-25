--[[-------------------------------------------------------------------------
Much better (and simplier) alternative for crappy gmod drive system
---------------------------------------------------------------------------]]
local registry = {}
controller = {}

function controller.Register( name, data )
	registry[name] = data
	data.Name = name

	data.Stop = function( self )
		self.ShouldStop = true
	end
end

function controller.Start( ply, name )
	ply:SetController( name )
end

function controller.Stop( ply )
	ply:SetController( "" )
end

function controller.IsEnabled( ply, name )
	if name then
		return ply:GetController() == name
	else
		return ply:GetController() != ""
	end
end

function controller.GetData( ply )
	local name = ply:GetController()
	if name == "" or ply._ControllerData and ply._ControllerData.Name != name then
		if ply._ControllerData then
			if ply._ControllerData.OnFinish then
				ply._ControllerData:OnStop( ply )
			end

			ply._ControllerData = nil
		end

		return
	end

	if !ply._ControllerData then
		local func = registry[name]
		if !func then return end

		ply._ControllerData = setmetatable( {}, { __index = func } )
		if ply._ControllerData.OnStart then
			ply._ControllerData:OnStart( ply )
		end
	end

	if ply._ControllerData.ShouldStop then
		controller.Stop( ply )
		return
	end

	return ply._ControllerData
end

function controller.CalcView( ply, view )
	local data = controller.GetData( ply )
	if !data or !data.CalcView then return end

	if data:CalcView( ply, view ) then return true end
end

function controller.StartCommand( ply, cmd )
	local data = controller.GetData( ply )
	if !data or !data.StartCommand then return end

	if data:StartCommand( ply, cmd ) then return true end
end

function controller.SetupMove( ply, mv, cmd )
	local data = controller.GetData( ply )
	if !data or !data.SetupMove then return end

	if data:SetupMove( ply, mv, cmd ) then return true end
end

function controller.Move( ply, mv )
	local data = controller.GetData( ply )
	if !data or !data.Move then return end

	if data:Move( ply, mv ) then return true end
end

function controller.FinishMove( ply, mv )
	local data = controller.GetData( ply )
	if !data or !data.FinishMove then return end

	if data:FinishMove( ply, mv ) then return true end
end