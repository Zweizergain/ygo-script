--大怪兽大破坏
function c10150066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10150066.condition)
	e1:SetTarget(c10150066.target)
	e1:SetOperation(c10150066.activate)
	c:RegisterEffect(e1)
end
function c10150066.confilter(c)
	return c:IsSetCard(0xd3) and c:IsFaceup()
end
function c10150066.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c10150066.confilter,tp,LOCATION_MZONE,0,nil,0xd3)==1 and Duel.GetMatchingGroupCount(c10150066.confilter,tp,0,LOCATION_MZONE,nil,0xd3)==1
end
function c10150066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10150066.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(c10150066.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c10150066.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c10150066.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c10150066.desfilter(c)
	return c:IsDestructable() and not (c:IsFaceup() and c:IsSetCard(0xd3) and c:IsType(TYPE_MONSTER))
end
