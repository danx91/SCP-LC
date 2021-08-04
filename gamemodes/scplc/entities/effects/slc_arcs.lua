function EFFECT:Init( data )
    self.Origin = data:GetOrigin()
    self.Arcs = math.Round( data:GetMagnitude() )
    self.Radius = data:GetRadius()
    self.Normal = data:GetNormal()
    self.DieTime = CurTime() + 0.25

    self.ArcPos = {}

    local ang = math.pi * 2 / self.Arcs
    local normal = self.Normal

    debugoverlay.Axis( self.Origin, normal:Angle(), 5, 0, false )

    for i = 1, self.Arcs do
        local vec_ang = normal:Angle()
        local n_ang = ang * ( i - 1 ) + ang * ( math.random() * 0.5 + 1 )

        local up = vec_ang:Up()
        local right = vec_ang:Right()

        local endpos = self.Origin + right * math.sin( n_ang ) * self.Radius * (math.random() * 0.5 + 0.5) + up * -math.cos( n_ang ) * self.Radius * (math.random() * 0.5 + 0.5) --?
        self.ArcPos[i] = { endpos = endpos, up = up, right = right }
    end

    self:GenerateArcs( math.random( 3, 8 ) )

    self.GenDelay = 0.05
    self.NextGen = CurTime() + self.GenDelay
end

function EFFECT:Think()
    if self.NextGen <= CurTime() then
        self.NextGen = CurTime() + self.GenDelay
        self:GenerateArcs( math.random( 3, 8 ) )
    end

    return self.DieTime > CurTime()
end

function EFFECT:GenerateArcs( segments )
    self.ArcData = {}

    for i = 1, #self.ArcPos do
        self.ArcData[i] = {}

        local arcpos = self.ArcPos[i]
        local diff = arcpos.endpos - self.Origin

        self.ArcData[i][1] = self.Origin + VectorRand() * self.Radius / 25

        for j = 1, segments do
            self.ArcData[i][j + 1] = self.Origin + diff * j / segments + arcpos.right * math.random() * self.Radius / 6 + arcpos.up * math.random() * self.Radius / 6 + self.Normal * math.random() * self.Radius / 5
        end
    end
end

local arc = Material( "slc/misc/pc_laser" )
local arc_color = Color(107, 133, 153)

function EFFECT:RenderArc( data, endpos )
    debugoverlay.Line( self.Origin, endpos, 0, Color( 255, 0, 0 ), false )

    local len = #data

    render.SetMaterial( arc )
    render.StartBeam( len )

    for i = 1, len do
        render.AddBeam( data[i], 1, math.random() * 0.5, arc_color )
    end

    render.EndBeam()
end

function EFFECT:Render()
    for i = 1, self.Arcs do
        self:RenderArc( self.ArcData[i], self.ArcPos[i].endpos )
    end
end

/*if SERVER then
    concommand.Add( "efff", function( ply )
        local effect = EffectData()
        effect:SetOrigin( ply:GetEyeTrace().HitPos )
        effect:SetNormal( ply:GetEyeTrace().HitNormal )
        effect:SetRadius( 25 )
        effect:SetMagnitude( 5 )

        util.Effect( "slc_button_overload", effect, true, true )
    end )
end*/