--银河急战·星辉
function c10100023.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100023,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c10100023.conditicon)
	e1:SetTarget(c10100023.target)
	e1:SetOperation(c10100023.operation)
	c:RegisterEffect(e1)
	--sendtograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100023,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c10100023.sgtg)
	e2:SetOperation(c10100023.sgop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100023,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(c10100003.con)
	e3:SetTarget(c10100023.sptg)
	e3:SetOperation(c10100023.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e4)
end
function c10100023.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10100010.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e)
end
function c10100023.tg(e,tc)
	local ct=e:GetType()
	local quick=tc:IsHasEffect(10100015)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	local equip=(g2 and g2:IsContains(c))
	local linkg=(tc:IsHasEffect(10100029) and g1 and g1:IsContains(c))
	if not equip and not linkg then return false end
	if bit.band(ct,0x40)==0x40 then return not quick 
	elseif bit.band(ct,0x100)==0x100 then return quick
	else return true
	end
end
function c10100023.cfilter(tc,e)
	return c10100023.tg(e,tc)
end
function c10100023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToExtra()) and c:GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c10100023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sp=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	local te=c:IsAbleToDeck()
	if not sp and not te then return end
	if te and (not sp or not Duel.SelectYesNo(tp,aux.Stringid(10100023,3))) then
	   Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	else
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100023.conditicon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c10100023.filter2(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x339) 
end
function c10100023.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100023.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100023.sgop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100023.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10100023.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x339)
end
function c10100023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c10100023.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100023.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10100023.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100023.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
