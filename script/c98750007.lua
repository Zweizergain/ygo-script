--裁决下达者 伏尔泰尼斯
function c98750007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c98750007.matfilter,4,3,nil,nil,5)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98750007,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98750007.condition)
	e1:SetCost(c98750007.descost)
	e1:SetTarget(c98750007.destg)
	e1:SetOperation(c98750007.desop)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCondition(c98750007.condition)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_COUNTER))
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98750007,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c98750007.regcon)
	e4:SetTarget(c98750007.target)
	e4:SetOperation(c98750007.operation)
	c:RegisterEffect(e4)
	--handdes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c98750007.ovop)
	c:RegisterEffect(e5)
end
function c98750007.matfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98750007.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()>=1
end
function c98750007.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98750007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98750007.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c98750007.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c98750007.filter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c98750007.filter2(c)
	return c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c98750007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98750007.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98750007.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if Duel.IsExistingMatchingCard(c98750007.filter1,tp,LOCATION_GRAVE,0,1,nil) and ct>0
		and Duel.SelectYesNo(tp,aux.Stringid(98750007,2)) then
		local g1=Duel.SelectMatchingCard(tp,c98750007.filter1,tp,LOCATION_GRAVE,0,1,ct,nil)
		local g2=Duel.SelectMatchingCard(tp,c98750007.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 and g2:GetCount()>0 then
			g1:Merge(g2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	else
		local sg2=Duel.SelectMatchingCard(tp,c98750007.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg2:GetCount()>0 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
end
function c98750007.ovop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_COUNTER) or Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 
		or e:GetHandler():GetOverlayGroup():GetCount()<1 then return end
	Duel.Hint(HINT_CARD,0,98750007)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local dg=g:RandomSelect(tp,1)
	Duel.Overlay(e:GetHandler(),dg)
end
