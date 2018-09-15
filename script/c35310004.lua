--远古恶魔的士兵
function c35310004.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35310004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,35310004)
	e1:SetTarget(c35310004.target)
	e1:SetOperation(c35310004.operation)
	--c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--c:RegisterEffect(e2)
	--tgggggggggg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35310004,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,35310104)
	e3:SetCondition(c35310004.secon)
	e3:SetTarget(c35310004.setg)
	e3:SetOperation(c35310004.seop)
	--c:RegisterEffect(e3)   
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35310004,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,35310104)
	e4:SetTarget(c35310004.sptg)
	e4:SetOperation(c35310004.spop)
	c:RegisterEffect(e4)  
end
function c35310004.tdfilter(c)
	return c:IsSetCard(0x3656) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c35310004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c35310004.tdfilter(chkc) and chkc~=c end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c35310004.tdfilter,tp,LOCATION_GRAVE,0,5,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c35310004.tdfilter,tp,LOCATION_GRAVE,0,5,5,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c35310004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c35310004.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c35310004.seop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_ATTACK)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_TO_HAND)
	   e1:SetDescription(aux.Stringid(35310004,2))
	   e1:SetCountLimit(1,35310204)
	   e1:SetCondition(c35310004.thcon)
	   e1:SetOperation(c35310004.thop)
	   e1:SetLabel(TYPE_MONSTER)
	   Duel.RegisterEffect(e1,tp)
	   local e11=e1:Clone()
	   e11:SetCode(EVENT_CUSTOM+35310004)
	   Duel.RegisterEffect(e11,tp)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e2:SetCode(EVENT_TO_HAND)
	   e2:SetDescription(aux.Stringid(35310004,3))
	   e2:SetCountLimit(1,35310304)
	   e2:SetLabel(TYPE_SPELL)
	   e2:SetCondition(c35310004.thcon)
	   e2:SetOperation(c35310004.thop)
	   Duel.RegisterEffect(e2,tp)
	   local e22=e2:Clone()
	   e22:SetCode(EVENT_CUSTOM+35310004)
	   Duel.RegisterEffect(e22,tp)
	   local e3=Effect.CreateEffect(c)
	   e3:SetDescription(aux.Stringid(35310004,4))
	   e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e3:SetCode(EVENT_TO_HAND)
	   e3:SetCountLimit(1,35310404)
	   e3:SetCondition(c35310004.thcon)
	   e3:SetOperation(c35310004.thop)
	   e3:SetLabel(TYPE_TRAP)
	   Duel.RegisterEffect(e3,tp)
	   local e33=e3:Clone()
	   e33:SetCode(EVENT_CUSTOM+35310004)
	   Duel.RegisterEffect(e33,tp)
	   Duel.RaiseEvent(eg,EVENT_CUSTOM+35310004,re,r,rp,ep,ev)
	end
end
function c35310004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35310004.cfilter,1,nil,1-tp,e:GetLabel()) and Duel.IsExistingMatchingCard(c35310004.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
end
function c35310004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c35310004.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
function c35310004.thfilter(c,ctype)
	return (c:IsSetCard(0x3656) or c.setname=="acfiend") and c:IsAbleToHand() and c:IsType(ctype)
end
function c35310004.cfilter(c,tp,ctype)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW) and (not ctype or c:IsType(ctype))
end
function c35310004.secon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35310004.cfilter,1,nil,1-tp)
end
function c35310004.filter(c)
	return (c:IsSetCard(0x3656) or c.setname=="acfiend") and c:IsAbleToHand()
end
function c35310004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35310004.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c35310004.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c35310004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end