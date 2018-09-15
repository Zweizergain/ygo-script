--灵噬圣堂
function c79131301.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
--  e0:SetCountLimit(1,79131301) 
	e0:SetOperation(c79131301.activate)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131301,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79131301.condition)
	e2:SetCountLimit(1,79131301)
	e2:SetTarget(c79131301.sptg)
	e2:SetOperation(c79131301.spop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c79131301.reptg)
	e3:SetValue(c79131301.repval)
	e3:SetOperation(c79131301.repop)
	c:RegisterEffect(e3)
end
function c79131301.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1201) and c:IsAbleToHand()
end
function c79131301.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c79131301.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetFlagEffect(tp,79131301)==0 and Duel.SelectYesNo(tp,aux.Stringid(79131301,0)) then
		Duel.RegisterFlagEffect(tp,79131301,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function c79131301.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c79131301.spfilter(c,e,sp)
	return c:IsSetCard(0x1201) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79131301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131301.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) 
		and Duel.GetUsableMZoneCount(tp)>0 and Duel.GetFlagEffect(tp,79131301)==0 end
	Duel.RegisterFlagEffect(tp,79131301,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c79131301.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c79131301.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,nil,e,tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if g:GetCount()>0 and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79131301.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1201) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79131301.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,1,REASON_COST) and eg:IsExists(c79131301.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(79131301,2))
end
function c79131301.repval(e,c)
	return c79131301.repfilter(c,e:GetHandlerPlayer())
end
function c79131301.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,1,REASON_COST)
end
