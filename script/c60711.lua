--禁忌「Four of a Kind」
function c60711.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetTarget(c60711.sptg)
	e1:SetOperation(c60711.spop)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c60711.handcon)
	c:RegisterEffect(e3)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c60711.target3)
	e2:SetOperation(c60711.operation3)
	c:RegisterEffect(e2)
end
function c60711.filter(c)
	return c:IsCode(60700) and c:IsAbleToHand()
end
function c60711.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60711.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60711.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c60711.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60711.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x813) 
end
function c60711.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount()
end
function c60711.filter2(c)
	return c:IsCode(60700) and c:IsAbleToGrave()
end
function c60711.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60711.filter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60711,0,0x814,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60711.spop(e,tp,eg,ep,ev,re,r,rp)
	local bbc=0
	local ac=Duel.SelectMatchingCard(tp,c60711.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if ac and ac:GetCount()>0 then
		if Duel.SendtoGrave(ac,REASON_EFFECT)~=0 then 
			bbc=bbc+1
		end 
	end 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,60711,0,0x814,2000,2000,7,RACE_FIEND,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then 
			bbc=bbc+1
			c:AddMonsterAttributeComplete()
			Duel.SpecialSummonComplete()
		end 
	end
	if bbc>0 then 
		local sg=e:GetHandler():GetColumnGroup()
		if Duel.Destroy(sg,REASON_EFFECT)<1 then 
			Duel.Damage(1-tp,1000,REASON_EFFECT)			
		end
	end 
end
