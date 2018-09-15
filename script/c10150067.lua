--大怪兽大对波
function c10150067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10150067+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10150067.condition)
	e1:SetOperation(c10150067.activate)
	c:RegisterEffect(e1)	
end
function c10150067.confilter(c)
	return c:IsSetCard(0xd3) and c:IsFaceup()
end
function c10150067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c10150067.confilter,tp,LOCATION_MZONE,0,nil,0xd3)==1 and Duel.GetMatchingGroupCount(c10150067.confilter,tp,0,LOCATION_MZONE,nil,0xd3)==1
end
function c10150067.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c10150067.tg)
		c:RegisterEffect(e2)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		c:RegisterEffect(e2)
end
function c10150067.tg(e,c)
	return not c:IsSetCard(0xd3)
end