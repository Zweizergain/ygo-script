--异位魔的威压
function c10106012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c10106012.cost)
	e1:SetTarget(c10106012.target)
	e1:SetOperation(c10106012.activate)
	c:RegisterEffect(e1) 
	--attack target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10106012,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_SPSUMMON)
	e2:SetCountLimit(1)
	e2:SetCondition(c10106012.tdcon)
	e2:SetCost(c10106012.cost)
	e2:SetTarget(c10106012.tdtg)
	e2:SetOperation(c10106012.tdop)
	c:RegisterEffect(e2)   
end
function c10106012.tdfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c10106012.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10106012.tdfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c10106012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10106012.sumfilter(c)
	return c:IsSetCard(0x3338) and c:IsSummonable(true,nil)
end
function c10106012.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
	   local g=Duel.GetMatchingGroup(c10106012.sumfilter,tp,LOCATION_HAND,0,nil)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10106012,1)) then
		  Duel.BreakEffect()
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  Duel.Summon(tp,tc,true,nil)
	   end
	end
end
function c10106012.cfilter(c)
	return c:IsSetCard(0x3338) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c10106012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10106012.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10106012.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10106012.selffilter(c)
	return c:IsSetCard(0x3338) and c:IsFaceup() and c:IsAbleToHand()
end
function c10106012.oppofilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsAbleToHand()
end
function c10106012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10106012.selffilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c10106012.oppofilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c10106012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c10106012.selffilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c10106012.oppofilter,tp,0,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local tg2=g2:Select(tp,1,1,nil)
	g3:Sub(tg2)
	if g3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10106012,2)) then
	   local tg3=g3:Select(tp,1,1,nil)
	   tg2:Merge(tg3)
	end
	tg1:Merge(tg2)  
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
end