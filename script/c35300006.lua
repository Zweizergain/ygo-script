--天魔的本源
function c35300006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c35300006.aclimit)
	e2:SetCondition(c35300006.actcon)
	c:RegisterEffect(e2)	
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(1)
	e3:SetCondition(c35300006.indcon)
	c:RegisterEffect(e3)
end
c35300006.setname="skydemon"
function c35300006.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c35300006.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c35300006.cfilter(c)
	return c:IsSetCard(0x1656) and c:IsFaceup()
end
function c35300006.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c35300006.actcon(e)
	return Duel.GetAttacker() and Duel.GetAttacker():IsControler(e:GetHandlerPlayer()) and Duel.GetAttacker():IsSetCard(0x1656)
end
