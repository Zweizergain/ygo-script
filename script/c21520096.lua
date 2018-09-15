--同步率
function c21520096.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520096,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21520096.target)
	e1:SetOperation(c21520096.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520096,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
--	e2:SetCondition(c21520096.thcon)
	e2:SetCost(c21520096.thcost)
	e2:SetTarget(c21520096.thtg)
	e2:SetOperation(c21520096.thop)
	c:RegisterEffect(e2)
end
function c21520096.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and Duel.IsExistingMatchingCard(c21520096.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c21520096.filter2(c,e,tp,tc)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOriginalLevel()==tc:GetLevel() and c:GetOriginalRace()==tc:GetRace()
		and c:GetTextAttack()==tc:GetAttack() and c:GetTextDefense()==tc:GetDefense() and bit.band(c:GetOriginalCode(),tc:GetCode())~=c:GetOriginalCode()
end
function c21520096.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c21520096.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingTarget(c21520096.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21520096.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21520096.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCountFromEx(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and ft>0 and Duel.IsExistingMatchingCard(c21520096.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c21520096.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21520096.rfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SYNCHRO)
end
function c21520096.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520096.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520096.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520096.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c21520096.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	if e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
