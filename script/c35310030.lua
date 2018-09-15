--远古恶魔 小妖狐
function c35310030.initial_effect(c)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35310030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(c35310030.thop)
	c:RegisterEffect(e1) 
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1)
	e3:SetCondition(c35310030.thcon2)
	e3:SetOperation(c35310030.thop2)
	c:RegisterEffect(e3)   
end
function c35310030.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic() and Duel.GetTurnPlayer()==tp
end
function c35310030.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,1-tp,REASON_EFFECT)
	Duel.ShuffleHand(tp)
end
function c35310030.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)<=0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)   
	local b1=Duel.IsExistingMatchingCard(c35310030.spfilter,tp,0x2,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c35310030.thfilter,tp,0x1,0,1,nil)
	if not b1 and not b2 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(35310030,1)) then return end
	Duel.BreakEffect()
	if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(35310030,2))) then
	   Duel.Hint(HINT_OPSELECTED,1-tp,HINTMSG_SPSUMMON)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c35310030.spfilter,tp,0x2,0,1,1,nil,e,tp)
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
	   Duel.Hint(HINT_OPSELECTED,1-tp,HINTMSG_ATOHAND)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,c35310030.thfilter,tp,0x1,0,1,1,nil)
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
end
function c35310030.spfilter(c,e,tp)
	return c:IsSetCard(0x3656) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c35310030.thfilter(c)
	return c.setname=="acfiend" and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end 

