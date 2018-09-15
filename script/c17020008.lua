--樱火装机使徒 利斯
function c17020008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17020008.splimit)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020008,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,17020008)
	e2:SetTarget(c17020008.destg)
	e2:SetOperation(c17020008.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17020008,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,17020108)
	e3:SetCondition(c17020008.thcon)
	e3:SetTarget(c17020008.thtg)
	e3:SetOperation(c17020008.thop)
	c:RegisterEffect(e3)  
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17020008,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,17020208)
	e4:SetCost(c17020008.descost)
	e4:SetTarget(c17020008.destg2)
	e4:SetOperation(c17020008.desop2)
	c:RegisterEffect(e4)   
end
function c17020008.dfilter(c)
	return c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and c:IsDiscardable()
end
function c17020008.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(c17020008.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c17020008.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c17020008.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17020008.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c17020008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c17020008.thfilter(c,e,tp,ft)
	return c:IsSetCard(0x702) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp))) and c:IsFaceup()
end
function c17020008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCountFromEx(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020008.thfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler(),e,tp,ft) end
end
function c17020008.thop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17020008.thfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler(),e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(17020008,3))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c17020008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c17020008.sfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c17020008.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
end
function c17020008.sfilter(c)
	if not c:IsSetCard(0x702) then return false end
	return c:IsAbleToHand() or ((c:IsType(TYPE_PENDULUM) and not c:IsForbidden()))
end
function c17020008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()<=0 or Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c17020008.sfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	local th=tc:IsAbleToHand()
	local set=(tc:IsType(TYPE_PENDULUM) and not tc:IsForbidden())
	if th and (not set or not Duel.SelectYesNo(tp,aux.Stringid(17020008,2))) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tc)
	else
	   Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
	end
end
function c17020008.desfilter(c)
	return c:IsSetCard(0x702)
end
function c17020008.splimit(e,c)
	return not c:IsSetCard(0x702) and not c:IsCode(17020019)
end