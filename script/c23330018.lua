--霞光的守护
function c23330018.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)	
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c23330018.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c23330018.cfilter(c)
	return c:IsSetCard(0x1555) and c:IsFaceup()
end
function c23330018.tg(e,c)
	return c:GetEquipGroup() and c:GetEquipGroup():IsExists(c23330018.cfilter,1,nil)
end