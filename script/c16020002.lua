--世界
function c16020002.initial_effect(c)
	c:SetUniqueOnField(1,0,16020002)
	--skip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	c:RegisterEffect(e1)
end
