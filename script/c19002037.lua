--风之月灵术 卷
function c19002037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19002037.cost)
	e1:SetTarget(c19002037.target)
	e1:SetOperation(c19002037.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19002037.handcon)
	c:RegisterEffect(e2)	
end
function c19002037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c19002037.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c19002037.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c19002037.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c19002037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c19002037.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c19002037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19002037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c19002037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
end
function c19002037.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c19002037.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if sg:GetCount()<=0 then return end
	for tc in aux.Next(sg) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c19002037.hfilter(c)
	return c:IsFaceup() and c:IsCode(19002009,19002018)
end
function c19002037.handcon(e)
	return Duel.IsExistingMatchingCard(c19002037.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end