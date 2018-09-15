--法皇之绿
function c16020003.initial_effect(c)
	c:SetUniqueOnField(1,0,16020003)
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(16020003)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end
