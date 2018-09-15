local m=13580608
local cm=_G["c"..m]
cm.name="机宇域之潘多拉"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link
	aux.AddLinkProcedure(c,cm.lfilter,3)
	--Get Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Link
function cm.lfilter(c)
	return c:IsLinkType(TYPE_LINK)
end
--Get Hand
function cm.filter(c)
	return c:IsType(TYPE_LINK)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) > Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetLinkedGroup():FilterCount(cm.filter,nil)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local ct=e:GetHandler():GetLinkedGroup():FilterCount(cm.filter,nil)
	if g:GetCount()==0 or ct==0 then return end
	if ct>g:GetCount() then ct=g:GetCount() end
	local sg=g:RandomSelect(tp,ct)
	local count=Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	Duel.ConfirmCards(1-tp,sg)
	Duel.SetLP(tp,Duel.GetLP(tp)-count*2000)
end