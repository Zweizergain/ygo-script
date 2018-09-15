--风之月灵术 卷
function c19002039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c19002039.cost)
	e1:SetTarget(c19002039.target)
	e1:SetOperation(c19002039.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19002039.handcon)
	c:RegisterEffect(e2)	
end
function c19002039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_FIRE)
	Duel.Release(g,REASON_COST)
end
function c19002039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c19002039.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c19002039.hfilter(c)
	return c:IsFaceup() and c:IsCode(19002007,19002019)
end
function c19002039.handcon(e)
	return Duel.IsExistingMatchingCard(c19002039.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end