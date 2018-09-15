--乱数合唱
function c21520034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520034,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520034.target)
	e1:SetOperation(c21520034.activate)
	c:RegisterEffect(e1)
	--to hand or set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520034,5))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c21520034.thcon)
	e2:SetCost(c21520034.thcost)
	e2:SetTarget(c21520034.thtg)
	e2:SetOperation(c21520034.thop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c21520034.handcon)
	c:RegisterEffect(e3)
end
function c21520034.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
end
function c21520034.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c21520034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		local tng=mg:Filter(Card.IsType,nil,TYPE_TUNER)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or tng:GetCount()==0 then return false end
		return Duel.IsExistingTarget(c21520034.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c21520034.filter2,tp,LOCATION_REMOVED,0,3,nil) 
			and tng:GetCount()>0 and mg:GetCount()>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520034.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c21520034.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true) then return end
	local mg=Duel.GetMatchingGroup(c21520034.filter2,tp,LOCATION_REMOVED,0,nil)
	if mg:GetCount()<3 then return end
	local tg=mg:Filter(Card.IsType,nil,TYPE_TUNER)
	if tg:GetCount()==0 then return end
	local tng=tg:RandomSelect(tp,1)
	mg:Sub(tng)
	local otg=mg:RandomSelect(tp,2)
	local rg=Group.CreateGroup()
	rg:Merge(tng)
	rg:Merge(otg)
	Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
	Duel.ConfirmCards(1-tp,rg)
	tc:SetMaterial(rg)
	--not randomly
	if not tc:IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520034.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local sum=tc:GetOriginalLevel()
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
end
function c21520034.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520034.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c21520034.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520034.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520034.cfilter,tp,LOCATION_GRAVE,0,nil)
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+30)
	local ct=math.random(1,g:GetCount())
	local rg=g:RandomSelect(tp,ct)
	Duel.ConfirmCards(1-tp,rg)
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c21520034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() end
	local op=2
	if (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable()) or e:GetHandler():IsAbleToHand() then
		op=Duel.SelectOption(tp,aux.Stringid(21520034,2),aux.Stringid(21520034,4))
	elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520034,2))
		op=0
	elseif e:GetHandler():IsAbleToHand() then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520034,4))
		op=1
	end
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE) end
	e:SetLabel(op)
end
function c21520034.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local op=e:GetLabel()
	if op==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
		Duel.SSet(tp,e:GetHandler())
		Duel.ConfirmCards(1-tp,e:GetHandler())
	elseif op==1 and e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c21520034.hafilter(c)
	return c:IsSetCard(0x493) and c:IsFaceup()
end
function c21520034.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c21520034.hafilter,tp,LOCATION_MZONE,0,nil)
	local rg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount() == rg:GetCount() and g:GetCount()>0
end
