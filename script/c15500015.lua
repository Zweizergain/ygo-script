--链接扫描的对象删除
function c15500015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c15500015.target)
	e1:SetOperation(c15500015.operation)
	c:RegisterEffect(e1)
end
function c15500015.filter(c)
	return (c:IsFacedown() or c:IsType(TYPE_LINK)) and c:IsAbleToGrave()
end
function c15500015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if chk==0 then return g:FilterCount(c15500015.filter,nil)>=2 end
end
function c15500015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_EXTRA,0,nil,TYPE_LINK)
	if g:GetCount()<2 then return end
	local rg=g:RandomSelect(tp,2)
	Duel.SendtoGrave(rg,REASON_EFFECT)
end
