--天魔的内核
function c35300008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c35300008.discon)
	e2:SetTarget(c35300008.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)  
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(1)
	e3:SetCondition(c35300008.indcon)
	c:RegisterEffect(e3)
end
c35300008.setname="skydemon"
function c35300008.indcon(e)
	return Duel.IsExistingMatchingCard(c35300008.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c35300008.cfilter(c)
	return c:IsSetCard(0x1656) and c:IsFaceup()
end
function c35300008.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and not c:IsSetCard(0x1656)
end
function c35300008.discon(e)
	return Duel.IsExistingMatchingCard(c35300008.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
