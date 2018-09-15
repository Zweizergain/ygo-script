--白魔术龙
function c34340008.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c34340008.splimit)
	c:RegisterEffect(e1)  
	--Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34340008,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c34340008.discon)
	e3:SetTarget(c34340008.distg)
	e3:SetOperation(c34340008.disop)
	c:RegisterEffect(e3) 
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(34340008,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c34340008.spcon)
	e4:SetTarget(c34340008.sptg)
	e4:SetOperation(c34340008.spop)
	c:RegisterEffect(e4)
end
c34340008.setname="WhiteMagician"
function c34340008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c34340008.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER+RACE_DRAGON) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand())
end
function c34340008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c34340008.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c34340008.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c34340008.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c34340008.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local b1=(tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	local b2=tc:IsAbleToHand()
	if not b1 and not b2 then return end
	if b2 and (not b1 or not Duel.SelectYesNo(tp,aux.Stringid(34340008,2))) then
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c34340008.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c34340008.tgfilter(c)
	return c.setname=="WhiteMagician" and not c:IsCode(34340008) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c34340008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340008.tgfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c34340008.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	   if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		  Duel.SendtoGrave(eg,REASON_EFFECT)
	   end
	   if Duel.IsExistingMatchingCard(c34340008.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		  Duel.BreakEffect()
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		  local tg=Duel.SelectMatchingCard(tp,c34340008.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		  Duel.SendtoGrave(tg,REASON_EFFECT)
	   end
	end
end
function c34340008.splimit(e,se,sp,st)
	local rc=se:GetHandler()
	return rc.setname=="WhiteMagician"
end